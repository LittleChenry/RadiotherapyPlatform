<%@ WebHandler Language="C#" Class="gettimeselect" %>

using System;
using System.Web;
using System.Text;

public class gettimeselect : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = gettimeduan(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string gettimeduan(HttpContext context)
    {
        StringBuilder info = new StringBuilder("{\"timeselect\":[");
        string countnum = "select count(*) FROM firstacctime";
        int number = int.Parse(sqlOperation.ExecuteScalar(countnum));
        int tempcoun = 1;
        string sqlCommand = "SELECT begintime,endtime FROM firstacctime";
        MySql.Data.MySqlClient.MySqlDataReader  reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            info.Append("{\"begin\":\"" + reader["begintime"].ToString() + "\",\"end\":\"" + reader["endtime"].ToString() + "\"}");
            if (tempcoun < number)
            {
                info.Append(",");
            }
            tempcoun++;

        }
        reader.Close();
        info.Append("]}");
        return info.ToString();
    }

}