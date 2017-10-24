<%@ WebHandler Language="C#" Class="sortParameterTable" %>

using System;
using System.Web;

public class sortParameterTable : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        sortTable(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private void sortTable(HttpContext context)
    {
        string table = context.Request.Form["table"];
        string orders = context.Request.Form["orders"];
        string[] priority = orders.Split(' ');

        for (int i = 0; i < priority.Length - 1;++i )
        {
            string sqlCommand = "update " + table + " set Orders=@Orders where ID=@id";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@Orders",i);
            sqlOperation.AddParameterWithValue("@id",priority[i]);

            sqlOperation.ExecuteNonQuery(sqlCommand);
        }
    }
}