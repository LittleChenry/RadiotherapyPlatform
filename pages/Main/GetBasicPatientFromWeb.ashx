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
        return s;
        //HIS.Service service = new HIS.Service();
       // return service.GetBasicInfo(s);
        
        
        
    }

}