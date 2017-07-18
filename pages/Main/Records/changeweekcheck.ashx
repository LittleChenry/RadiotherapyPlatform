<%@ WebHandler Language="C#" Class="changeweekcheck" %>

using System;
using System.Web;

public class changeweekcheck : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = gettotal(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string gettotal(HttpContext context)
    {
        string weekid = context.Request.QueryString["ID"];
        string[] group= weekid.Split(new char[1] { '-' });
        string user = context.Request.QueryString["user"];
        int userid = int.Parse(user);
        Boolean s = false;
        for (int i = 0; i <= group.Length - 1; i++)
        {
            string sqlcommand = "update treatmentrecord set Check_User_ID=@user where ID=@id";
            sqlOperation.AddParameterWithValue("@user", userid);
            sqlOperation.AddParameterWithValue("@id", Convert.ToInt32(group[i]));
            int success=sqlOperation.ExecuteNonQuery(sqlcommand);
        
        }
        return "success";
        

    }
}