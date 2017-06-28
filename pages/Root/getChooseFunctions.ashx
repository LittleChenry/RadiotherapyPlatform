<%@ WebHandler Language="C#" Class="getChooseFunctions" %>

using System;
using System.Web;

public class getChooseFunctions : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getSelected(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getSelected(HttpContext context)
    {
        string id = context.Request.QueryString["id"];
        string sqlCommand = "SELECT Function_ID FROM function2role WHERE Role_ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        string backString = "";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString += reader["Function_ID"].ToString() + " ";
        }
        reader.Close();
        return backString;
    }

}