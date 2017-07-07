<%@ WebHandler Language="C#" Class="getreplaceApply" %>

using System;
using System.Web;
using System.Text;


public class getreplaceApply : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getreplaceapplydinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getreplaceapplydinfo(HttpContext context)
    {
        String treat = context.Request.QueryString["treatmentID"];
        int treatID = Convert.ToInt32(treat);
        string sqlCommand = "select replacementrequirements.Requirements as replacerequire,user.Name as doctor,replacement.ApplicationTime as ApplicationTime from treatment,user,replacement,replacementrequirements where treatment.ID=@treatid and replacement.Application_User_ID=user.ID and treatment.Replacement_ID=replacement.ID and replacement.ReplacementRequirements_ID=replacementrequirements.ID ";
        sqlOperation.AddParameterWithValue("@treatid", treatID);
        string desgin = "select PDF from design,treatment where treatment.Design_ID=design.ID and treatment.ID=@treatid";
        string pdf = sqlOperation.ExecuteScalar(desgin);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"replace\":[");
        while (reader.Read())
        {
            backText.Append("{\"replacerequire\":\"" + reader["replacerequire"].ToString() + "\",\"pdf\":\"" + pdf.ToString()+ "\",\"ApplicationUser\":\"" + reader["doctor"].ToString() + "\",\"ApplicationTime\":\"" + reader["ApplicationTime"].ToString() 
                     + "\"}");
        }     
        reader.Close();
        backText.Append("]}");
        return backText.ToString();
    }
   
          

}