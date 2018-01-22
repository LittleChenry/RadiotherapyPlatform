<%@ WebHandler Language="C#" Class="changeChdesignState" %>

using System;
using System.Web;

public class changeChdesignState : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        changestate(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private void changestate(HttpContext context)
    {
        string type = context.Request["type"];
        string state = context.Request["state"];
        string chid = context.Request["childdesignid"];
        if (type == "0")
        {
            string command = "update childdesign set State=0 where ID=@chid";
            sqlOperation.AddParameterWithValue("@chid", chid);
            sqlOperation.ExecuteNonQuery(command);
            
        }
        if (type == "1")
        {
            string command = "update childdesign set State=@state where ID=@chid";
            sqlOperation.AddParameterWithValue("@chid", chid);
            if (state == "true")
            {
                sqlOperation.AddParameterWithValue("@state", 3);

            }
            else
            {
                sqlOperation.AddParameterWithValue("@state", 2);
            }
            sqlOperation.ExecuteNonQuery(command);
            
        }
    }

}