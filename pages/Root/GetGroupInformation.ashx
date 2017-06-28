<%@ WebHandler Language="C#" Class="GetGroupInformation" %>

using System;
using System.Web;
using System.Text;

public class GetGroupInformation : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = group();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string group()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT Name,Group_ID,user.ID uid FROM user WHERE Group_ID NOT IN(0) and Group_ID IS NOT NULL ORDER BY Group_ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        if (!reader.Read())
        {
            return "{\"user\":[{\"Name\":\"null\"}]}";
        }
        StringBuilder backString = new StringBuilder("{\"user\":[");
        while (true)
        {
            backString.Append("{\"Name\":\"");
            backString.Append(reader["Name"].ToString());
            backString.Append("\",\"GroupID\":\"");
            backString.Append(reader["Group_ID"].ToString());
            backString.Append("\",\"UID\":\"");
            backString.Append(reader["uid"].ToString());
            backString.Append("\"}");
            if (reader.Read())
            {
                backString.Append(",");
            }
            else
            {
                break;
            }
        }
        reader.Close();
        reader = null;
        backString.Append("],\"group\":[");

        sqlCommand = "SELECT * FROM groups ORDER BY ID";
        try
        {
            reader = sqlOperation.ExecuteReader(sqlCommand);
        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        if (!reader.Read())
            throw new Exception("user和group表不匹配");
        while (true)
        {
            backString.Append("{\"ID\":\"");
            backString.Append(reader["ID"].ToString());
            backString.Append("\",\"Name\":\"");
            backString.Append(reader["Charge_User_Name"].ToString());
            backString.Append("\",\"UID\":\"");
            backString.Append(reader["Charge_User_ID"].ToString());
            backString.Append("\"}");
            if (reader.Read())
            {
                backString.Append(",");
            }
            else
            {
                break;
            }
        }
        reader.Close();
        reader = null;
        sqlOperation.Close();
        sqlOperation.Dispose();
        backString.Append("]}");
        sqlOperation.Close();
        sqlOperation.Dispose();
        return backString.ToString();
    }
}