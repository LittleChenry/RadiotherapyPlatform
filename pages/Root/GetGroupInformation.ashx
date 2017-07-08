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
        string sqlCommand = "SELECT user.ID uid,user.Name userName,groups.ID gid,groups.groupName groupName,groups.Charge_User_Name,groups.Charge_User_ID "
                            + "FROM user LEFT JOIN groups ON user.Group_ID=groups.ID "
                            + "WHERE user.Group_ID NOT IN(0,-1) and user.Group_ID IS NOT NULL ORDER BY user.Group_ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder result = new StringBuilder("[");
        while(reader.Read()){
         result.Append("{\"userID\":\"")
             .Append(reader["uid"].ToString())
             .Append("\",\"userName\":\"")
             .Append(reader["userName"].ToString())
             .Append("\",\"gid\":\"")
             .Append(reader["gid"].ToString())
             .Append("\",\"groupName\":\"")
             .Append(reader["groupName"].ToString())
             .Append("\",\"chagerID\":\"")
             .Append(reader["Charge_User_ID"].ToString())
             .Append("\",\"chargerName\":\"")
             .Append(reader["Charge_User_Name"].ToString())
             .Append("\"},");     
        }
        result.Remove(result.Length-1,1);
        result.Append("]");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return result.ToString();
    }
}