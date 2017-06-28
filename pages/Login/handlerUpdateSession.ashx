<%@ WebHandler Language="C#" Class="handlerUpdateSession" %>

using System;
using System.Web;
using System.Web.SessionState;

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
        UserInformation user = (UserInformation)context.Session["loginUser"];
        user.setUserRole(context.Request.Form["role"]);
    }
}