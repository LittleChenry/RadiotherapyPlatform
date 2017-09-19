<%@ WebHandler Language="C#" Class="GetBasicPatientFromWeb" %>

using System;
using System.Web;

public class GetBasicPatientFromWeb : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(GetBasicInfo(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public String GetBasicInfo(HttpContext context)
    {
        string s = context.Request["info"];
        string xmlstring = "<?xml version=\"1.0\" encoding=\"utf-8\"?><patients><patient><name>张俊东</name><sex>男</sex><birthdate>2008-10-7</birthdate></patient></patients>";
        return xmlstring;
        //HIS.Service service = new HIS.Service();
       // return service.GetBasicInfo(s);
        
        
        
    }

}