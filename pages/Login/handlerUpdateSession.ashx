<%@ WebHandler Language="C#" Class="handlerUpdateSession" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Collections.Generic;

public class handlerUpdateSession : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        updateSession(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    
    private void updateSession(HttpContext context){
        string role = context.Request.Form["role"];
        LinkedList<int> progress = getRoleProgress(role);
        string rolename = getRoleName(role);
        
        UserInformation user = (UserInformation)context.Session["loginUser"];
        user.setUserRole(rolename);
        user.setProgress(progress);
        context.Session["loginUser"] = user;
    }

    private LinkedList<int> getRoleProgress(string des)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT function.progress FROM function LEFT JOIN function2role ON function.ID=function2role.Function_ID LEFT JOIN role ON function2role.Role_ID=role.ID WHERE role.Name=@name";
        sqlOperator.AddParameterWithValue("@name", des);
        LinkedList<int> progress = new LinkedList<int>();
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            progress.AddLast(int.Parse(reader["progress"].ToString()));
        }
        reader.Close();
        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
        return progress;
    }

    private string getRoleName(string role)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT Description FROM role WHERE Name=@name";
        sqlOperator.AddParameterWithValue("@name", role);
        return sqlOperator.ExecuteScalar(sqlCommand);
    }
}