<%@ WebHandler Language="C#" Class="handlerSetRole" %>

using System;
using System.Web;
using System.Web.SessionState;

public class handlerSetRole : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        UserInformation user = (UserInformation)(context.Session["loginUser"]);
        user.setUserRole(context.Request.QueryString["role"]);
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}