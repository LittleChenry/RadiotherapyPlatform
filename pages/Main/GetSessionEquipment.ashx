<%@ WebHandler Language="C#" Class="GetSessionEquipment" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Collections.Generic;
using System.Text;

public class GetSessionEquipment : IHttpHandler, IRequiresSessionState{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result =  getEquipment(context);
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getEquipment(HttpContext context)
    {
        UserInformation user = (context.Session["loginUser"] as UserInformation);
        KeyValuePair<int, string> equipments = user.getEquipment();
        StringBuilder sb = new StringBuilder();
        sb.Append("{\"Name\":\"").Append(equipments.Value)
          .Append("\",\"ID\":\"").Append(equipments.Key)
          .Append("\"}");
        return sb.ToString();
    }
}