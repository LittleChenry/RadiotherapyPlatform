<%@ WebHandler Language="C#" Class="test" %>

using System;
using System.Web;

public class test : IHttpHandler {
    
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
                return Dcm.get(infile);
            }
            catch (System.Exception Ex)
            {
                context.Response.Write(Ex);
            }
        }
        return "";
    }
}