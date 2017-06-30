<%@ WebHandler Language="C#" Class="GetFixtime" %>
using System;
using System.Web;
using System.Text;
/* ***********************************************************
 * FileName:getFixtime.ashx
 * Writer: xubxiao
 * create Date: 2017-5-9
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 获取某个疗程的体位固定预约开始时间
 * **********************************************************/

public class GetFixtime : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getfixtime(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getfixtime(HttpContext context)
    {
        String treatid=context.Request.QueryString["treatid"];
        string sqlCommand = "select Date,Begin,End from Appointment where Treatment_ID=@treatid and Task='体位固定'";
        sqlOperation.AddParameterWithValue("@treatid",Convert.ToInt32(treatid));
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"fixtime\":[");
        if(reader.Read())
        {
            backText.Append("{\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\"}");
        }
        backText.Append("]}");
        return backText.ToString();
    }

}