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
        String designID = context.Request["treatID"];
        int treatID = Convert.ToInt32(designID);
        int state=Convert.ToInt32(context.Request["state"]);
        int progress = Convert.ToInt32(context.Request["progress"]);
        string stoptime = "select stoptime from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        sqlOperation.AddParameterWithValue("@progress", progress);
        stoptime = sqlOperation.ExecuteScalar(stoptime);
        string restarttime = "select RestartTime from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
        int i = 1;
        restarttime = sqlOperation.ExecuteScalar(restarttime);
        string count = "select count(*) from worktimetable where Date>=@date1 and Date<=@date2 and IsUsed=1";
        sqlOperation.AddParameterWithValue("@date1", context.Request["date1"]);
        sqlOperation.AddParameterWithValue("@date2", context.Request["date2"]);
        int Count = int.Parse(sqlOperation.ExecuteScalar(count));
        string sqlCommand = "select Date from worktimetable where Date>=@date1 and Date<=@date2 and IsUsed=1";
        
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        StringBuilder backText = new StringBuilder("{\"warningInfo\":[");
        //backText.Append(reader.Read());
        backText.Append("{\"StopTime\":\"" + stoptime + "\",\"RestartTime\":\"" + restarttime + "\"}],");
        backText.Append("\"Date\":[");
        while (reader.Read())
        {

            backText.Append("\"" + reader["Date"].ToString() + "\"");
            if (i < Count)
            {
                backText.Append(",");
            }
            i++;
        }

        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}