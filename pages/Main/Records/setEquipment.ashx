<%@ WebHandler Language="C#" Class="setEquipment" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Web.SessionState;

public class setEquipment : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        
        context.Response.Write(set(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string set(HttpContext context)
    {
        string name = context.Request.Form["name"];
        int id = int.Parse(context.Request.Form["id"]);

        KeyValuePair<int, string> equipment = new KeyValuePair<int, string>(id, name);
        if (context.Session["loginUser"] == null)
        {
            return "null";
        }
        UserInformation user = (UserInformation)context.Session["loginUser"];
        user.setEquipment(equipment);
        context.Session["loginUser"] = user;
        return "success";
    }
}