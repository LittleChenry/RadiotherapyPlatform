<%@ WebHandler Language="C#" Class="getalllog" %>

using System;
using System.Web;
using System.Text;
public class getalllog : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = getlog(context);
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
    private string getlog(HttpContext context)
    {
        string treatID=context.Request.QueryString["treatmentID"];
        int treatid = Convert.ToInt32(treatID);
        string command = "select ChangeLog,SpecialEnjoin,SplitWay_ID from treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command);
        if (reader.Read())
        {
            string select = "select Ways from splitway where ID=@id";
            sqlOperation1.AddParameterWithValue("@id", reader["SplitWay_ID"].ToString());
            string result = sqlOperation1.ExecuteScalar(select);
            backText.Append("{\"ChangeLog\":\"" + reader["ChangeLog"].ToString() + "\",\"SpecialEnjoin\":\"" + reader["SpecialEnjoin"].ToString() + "\",\"SplitWay_ID\":\"" + reader["SplitWay_ID"].ToString() + "\",\"SplitWay\":\"" + result + "\"}");
        }

        backText.Append("]}");
        return backText.ToString();   
    }

}