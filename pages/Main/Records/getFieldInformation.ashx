<%@ WebHandler Language="C#" Class="getFieldInformation" %>

using System;
using System.Web;
using System.IO;

public class getFieldInformation : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(handlerFile(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string handlerFile(HttpContext context)
    {
        string exist = context.Request.Form["exist"];
        if (exist == "true")
        {
            HttpFileCollection files = context.Request.Files;
            
            try
            {

                System.Web.HttpPostedFile postedFile = files[0];
                System.IO.Stream infile = postedFile.InputStream;
                StreamReader reader = new StreamReader(infile);
                String content = reader.ReadToEnd();
                return FileHandler.handler(content);
            }
            catch (System.Exception Ex)
            {
                context.Response.Write(Ex);
            }
        }
        return "";
    }
}