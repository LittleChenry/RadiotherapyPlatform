<%@ WebHandler Language="C#" Class="receiveInfo" %>

using System;
using System.Web;
using System.Text;
public class receiveInfo : IHttpHandler {
     private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
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
    private string getfixrecordinfo(HttpContext context)
    {
        String designID = context.Request.QueryString["treatID"];
 
        int treatID = Convert.ToInt32(designID);
        string sqlCommand = "select technology.name as tname,equipmenttype.type as eqname,user.Name as doctor,design.* from technology,equipmenttype,design,user,treatment where technology.ID=design.Technology_ID and equipmenttype.ID=design.Equipment_ID and design.ID=treatment.Design_ID and design.Application_User_ID =user.ID  and treatment.ID = @designid";      
        sqlOperation.AddParameterWithValue("@designid", treatID);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        StringBuilder backText = new StringBuilder("{\"receiveInfo\":[");
        //backText.Append(reader.Read());
        
        while (reader.Read())           
        {
            string date = reader["ApplicationTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            string date2 = reader["ReceiveTime"].ToString();              
            if (date2 != "")
            {
                DateTime dt2 = Convert.ToDateTime(date2);
                date2 = dt2.ToString("yyyy-MM-dd HH:mm");
            }
            string receiver = null;
             if (reader["Receive_User_ID"] is DBNull)
             {

                 receiver = null;
             }
             else
             {
                 string sqlCommand1 = "select user.Name from design,user,treatment where design.ID=treatment.Design_ID and design.Receive_User_ID =user.ID and treatment.ID = @treatid";
                 sqlOperation1.AddParameterWithValue("@treatid", treatID);
                 receiver = sqlOperation1.ExecuteScalar(sqlCommand1);
             }
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] {'&'})[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"apptime\":\"" + date1 +
                 "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"ReceiveUser\":\"" + receiver + "\",\"ReceiveTime\":\"" + date2 +
                  "\",\"technology\":\"" + reader["tname"].ToString() + "\",\"equipment\":\"" + reader["eqname"].ToString() +
                  "\",\"RadiotherapyHistory\":\"" + reader["RadiotherapyHistory"].ToString() + "\",\"DosagePriority\":\"" + Priority + "\",\"Dosage\":\"" + Dosage + "\"}");
           
        }

        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}


  