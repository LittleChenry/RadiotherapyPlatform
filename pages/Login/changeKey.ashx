<%@ WebHandler Language="C#" Class="changeKey" %>

using System;
using System.Web;

public class changeKey : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(change(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string change(HttpContext context)
    {
        string number = context.Request.Form["number"];
        string oldKey = context.Request.Form["oldKey"];
        string newKey = context.Request.Form["newKey"];

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT COUNT(ID) FROM user WHERE Number=@number";
        sqlOperator.AddParameterWithValue("@number", number);

        int num = int.Parse(sqlOperator.ExecuteScalar(sqlCommand));

        if (num == 0)
        {
            return "number";
        }

        sqlCommand = "SELECT COUNT(ID) FROM user WHERE Number=@number AND Password=@oldKey";
        sqlOperator.AddParameterWithValue("@oldKey", oldKey);

        num = int.Parse(sqlOperator.ExecuteScalar(sqlCommand));
        if (num == 0)
        {
            return "key";
        }

        sqlCommand = "UPDATE user SET Password=@newKey WHERE Number=@number AND Password=@oldKey";
        sqlOperator.AddParameterWithValue("@newKey", newKey);

        sqlOperator.ExecuteNonQuery(sqlCommand);

        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
        return "true";
    }
}