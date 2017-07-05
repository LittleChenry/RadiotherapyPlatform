<%@ WebHandler Language="C#" Class="setAssistant" %>

using System;
using System.Web;
using System.Web.SessionState;

public class setAssistant : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        setSession(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void setSession(HttpContext context)
    {
        string assistant = context.Request.Form["assistant"];

        UserInformation user = (UserInformation)context.Session["loginUser"];
        user.setAssistant(assistant);

        context.Session["loginUser"] = user;
    }

}