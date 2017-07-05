<%@ WebHandler Language="C#" Class="getSession" %>

using System;
using System.Web;
using System.Text;
using System.Web.SessionState;

public class getSession : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string user = getLoginUser(context);
        context.Response.Write(user);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getLoginUser(HttpContext context)
    {
        UserInformation user = (UserInformation)context.Session["loginUser"];
        StringBuilder result = new StringBuilder("{");

        result.Append("\"userID\":\"")
              .Append(user.GetUserID())
              .Append("\",\"userNumber\":\"")
              .Append(user.GetUserNumber())
              .Append("\",\"userName\":\"")
              .Append(user.GetUserName())
              .Append("\",\"role\":\"")
              .Append(user.GetUserRole())
              .Append("\",\"assistant\":\"")
              .Append(user.getAssistant())
              .Append("\"}");
        return result.ToString();
    }

}