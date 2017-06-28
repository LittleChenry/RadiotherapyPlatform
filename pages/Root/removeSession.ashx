<%@ WebHandler Language="C#" Class="removeSession" %>

using System;
using System.Web;
using System.Web.SessionState;

public class removeSession : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        removeUserSession(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void removeUserSession(HttpContext context)
    {
        context.Session.Remove("loginUser");
    }

}