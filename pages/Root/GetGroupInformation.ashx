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
        
        string sqlCommand = "SELECT `user`.`Name`,`user`.ID uid,groups.ID gid,groups.groupName,groups2user.identity FROM "
                            + "`user` RIGHT JOIN groups2user ON `user`.ID=groups2user.User_ID "
                            +"RIGHT JOIN groups ON groups2user.Group_ID=groups.ID WHERE groups2user.state=1 OR groups2user.identity=1 ORDER BY gid,identity";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder result = new StringBuilder("[");
        while(reader.Read()){
         result.Append("{\"userID\":\"")
             .Append(reader["uid"].ToString())
             .Append("\",\"userName\":\"")
             .Append(reader["Name"].ToString())
             .Append("\",\"gid\":\"")
             .Append(reader["gid"].ToString())
             .Append("\",\"groupName\":\"")
             .Append(reader["groupName"].ToString())
             .Append("\",\"identity\":\"")
             .Append(reader["identity"].ToString())
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