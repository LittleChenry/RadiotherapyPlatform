<%@ WebHandler Language="C#" Class="GetUserID" %>


using System;
using System.Web;
using System.Web.SessionState;

public class GetUserID : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        UserInformation loginUser = (context.Session["loginUser"] as UserInformation);
        int id = loginUser.GetUserID();
        context.Response.Write(id);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}