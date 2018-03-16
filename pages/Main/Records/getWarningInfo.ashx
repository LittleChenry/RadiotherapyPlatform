<%@ WebHandler Language="C#" Class="getWarningInfo" %>

using System;
using System.Web;
using System.Text;
public class getWarningInfo : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
           
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
        int state=Convert.ToInt32(context.Request.QueryString["state"]);
        int progress = Convert.ToInt32(context.Request.QueryString["progress"]);
        string sqlCommand = "select warningcase.* from warningcase where TrestID=@treatID and progress=@progress and (Type=0 or Type=2)";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        sqlOperation.AddParameterWithValue("@progress", progress);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        StringBuilder backText = new StringBuilder("{\"warningInfo\":[");
        //backText.Append(reader.Read());

        while (reader.Read())
        {

            backText.Append("{\"StopTime\":\"" + reader["stoptime"].ToString() + "\",\"RestartTime\":\"" + reader["RestartTime"].ToString() + "\"}");
           
        }//

        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}