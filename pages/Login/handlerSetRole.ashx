<%@ WebHandler Language="C#" Class="handlerSetRole" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Collections.Generic;

public class handlerSetRole : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string des = context.Request.QueryString["des"];
        LinkedList<int> progress = getRoleProgress(des);
        UserInformation user = (UserInformation)(context.Session["loginUser"]);
        user.setUserRole(context.Request.QueryString["role"]);
        user.setProgress(progress);
        context.Session["loginUser"] = user;
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
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
}