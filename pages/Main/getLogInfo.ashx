<%@ WebHandler Language="C#" Class="getLogInfo" %>

using System;
using System.Web;
using System.Text;

public class getLogInfo : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getloginfomation(context);
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
    public string getloginfomation(HttpContext context)
    {

        string startdate = context.Request["startdate"];
        string enddate = context.Request["enddate"];
        StringBuilder s = new StringBuilder("[");
        string command = "select loginfo.ID as logid,user.Name as username,Date,loginfo.logInformation as logInformation,isChecked  from loginfo,user where loginfo.userID=user.ID and Date>=@date1 and Date<=@date2 ORDER BY Date";
        sqlOperation.AddParameterWithValue("@date1", startdate);
        sqlOperation.AddParameterWithValue("@date2", enddate);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command);
        Boolean boolname = false;
        while (reader.Read())
        {
            if (boolname == false)
            {
                s.Append("{\"userName\":\"" + reader["username"].ToString() + "\",\"date\":\"" + reader["Date"].ToString() + "\",\"id\":\"" + reader["logid"].ToString() + "\",\"logcontext\":\"" + reader["logInformation"].ToString() + "\",\"ischecked\":\"" + reader["isChecked"].ToString() + "\"}");
                boolname = true;
            }
            else
            {
                s.Append(",{\"userName\":\"" + reader["username"].ToString() + "\",\"date\":\"" + reader["Date"].ToString() + "\",\"id\":\"" + reader["logid"].ToString() + "\",\"logcontext\":\"" + reader["logInformation"].ToString() + "\",\"ischecked\":\"" + reader["isChecked"].ToString() + "\"}");
                
            }
 
        }
        s.Append("]");
        return s.ToString();

    }
    
    
    

}