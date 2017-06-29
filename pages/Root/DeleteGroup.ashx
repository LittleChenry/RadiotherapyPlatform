﻿<%@ WebHandler Language="C#" Class="DeleteGroup" %>

using System;
using System.Web;
using System.Text;

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
        string id = context.Request.Form["ids"];
        string[] ids = id.Split(' ');
        string sqlCommand = "DELETE FROM groups WHERE ID=@gid";
        sqlOperation.AddParameterWithValue("@gid", ids[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        StringBuilder update = new StringBuilder("UPDATE user set Group_ID=0 WHERE ID in(");
        for (int i = 0; i < ids.Length - 1; i++)
        {
            update.Append(ids[i]).Append(",");
        }
        update.Remove(update.Length - 1, 1).Append(")");
        sqlCommand = update.ToString();
        sqlOperation.ExecuteNonQuery(sqlCommand);

        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
    }
}