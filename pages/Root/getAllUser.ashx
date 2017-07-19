<%@ WebHandler Language="C#" Class="getAllUser" %>

using System;
using System.Web;
using System.Text;

public class getAllUser : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getUser(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getUser(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string activate = context.Request.Form["activate"];
        string office = context.Request.Form["office"];
        activate = activate == null ? "" : activate;
        office = office == null ? "" : office;
        string add = "";
        if (activate != "")
        {
            add += " WHERE Activate=@activate";
            sqlOperator.AddParameterWithValue("@activate", activate);
        }
        if (office != "")
        {
            if (add == "")
            {
                add += " WHERE Office=@office";
            }else{
                add += " AND Office=@office";
            }
            sqlOperator.AddParameterWithValue("@office", office);
        }
        string sqlCommand = "SELECT * FROM user" + add;
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);
        StringBuilder result = new StringBuilder("[");
        while (reader.Read())
        {
            result.Append("{\"Number\":\"")
                  .Append(reader["Number"].ToString())
                  .Append("\",\"Name\":\"")
                  .Append(reader["Name"].ToString())
                  .Append("\",\"Gender\":\"")
                  .Append((reader["Gender"].ToString() == "M") ? "男" : "女")
                  .Append("\",\"Contact\":\"")
                  .Append(reader["Contact"].ToString())
                  .Append("\",\"Office\":\"")
                  .Append(reader["Office"].ToString())
                  .Append("\",\"password\":\"")
                  .Append(reader["Password"].ToString())
                  .Append("\",\"Activate\":\"")
                  .Append(((reader["Activate"].ToString() == "1") ? "已激活" : "未激活"))
                  .Append("\"},");
        }
        result.Remove(result.Length - 1, 1)
            .Append("]");
        return result.ToString();
    }

}