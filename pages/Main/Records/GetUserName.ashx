<%@ WebHandler Language="C#" Class="GetUserName" %>

/* ***********************************************************
 * FileName: GetUserName.ashx
 * Writer: peach
 * create Date: 2017-4-6
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 读取session用户信息中的用户名
 * **********************************************************/

using System;
using System.Web;
using System.Text;
using System.Web.SessionState;

public class GetUserName : IHttpHandler, IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        UserInformation user = (UserInformation)context.Session["loginUser"];
        string name = user.GetUserName();
        context.Response.Write(name);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}