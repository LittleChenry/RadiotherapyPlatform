<%@ WebHandler Language="C#" Class="getSession" %>

using System;
using System.Web;
using System.Text;
using System.Web.SessionState;
using System.Collections.Generic;


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

        LinkedList<int> progress = user.getProgress();
        
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
              .Append("\",\"progress\":\"");
        StringBuilder pro = new StringBuilder();
        foreach (int x in progress)
        {
            pro.Append(x).Append(" ");
        }
        if (pro.Length > 0)
        {
            pro.Remove(pro.Length - 1, 1);
        }
        
        result.Append(pro)
              .Append("\"}");
        return result.ToString();
    }

}