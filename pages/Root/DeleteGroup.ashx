<%@ WebHandler Language="C#" Class="DeleteGroup" %>

using System;
using System.Web;

public class DeleteGroup : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/x-www-form-urlencoded";
        DeleteG(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void DeleteG(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string gid = context.Request.Form["data"];
        string memeber = context.Request.Form["delete"];
        string[] members = memeber.Split(' ');
        string sqlCommand = "DELETE FROM groups WHERE ID=@gid";
        sqlOperation.AddParameterWithValue("@gid", gid);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        sqlCommand = "UPDATE user SET Group_ID=0 WHERE ID in(";
        int len = members.Length;
        for (int i = 0; i < len; i++)
        {
            if (members[i] != "")
            {
                sqlCommand += members[i];
                if (i < (len - 2))
                {
                    sqlCommand += ",";
                }
            }
        }
        sqlCommand +=");";
        sqlOperation.ExecuteNonQuery(sqlCommand);
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}