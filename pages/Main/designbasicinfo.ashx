<%@ WebHandler Language="C#" Class="designbasicinfo" %>

using System;
using System.Web;
using System.Text;

public class designbasicinfo : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = getdesignbasic(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getdesignbasic(HttpContext context)
    {
        string treatid = context.Request["treatID"];
        string command = "select treatment.TPS as tps,design.RadiotherapyHistory as radio,design.DosagePriority as dos,equipmenttype.Type as equipname,technology.Name as techname from design,treatment,technology,equipmenttype where  treatment.Design_ID=design.ID and design.Technology_ID=technology.ID and design.Equipment_ID=equipmenttype.ID and treatment.ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command);
        StringBuilder backText = new StringBuilder("{\"designInfo\":[");
        if (reader.Read())
        {
            string Do = reader["dos"].ToString();
            string Priority = Do.Split(new char[1] { '&' })[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"RadiotherapyHistory\":\"" + reader["radio"].ToString() + "\",\"DosagePriority\":\"" + Priority + "\",\"tps\":\"" + reader["tps"].ToString() + "\",\"Dosage\":\"" + Dosage + "\",\"techname\":\"" + reader["techname"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\"}");
        }
        backText.Append("]}");
        return backText.ToString();

    }

}