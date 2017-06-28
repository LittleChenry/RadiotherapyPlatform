<%@ WebHandler Language="C#" Class="CHeckRegeditUserName" %>

using System;
using System.Web;

public class CHeckRegeditUserName : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        if (CheckDuplicateUserName(context))
        {
            context.Response.Write("true");
            return;
        }
        else
        {
            context.Response.Write("false");
            return;
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    #region 检查用户名是否重复
    /// <summary>
    /// 检查用户名是否重复
    /// </summary>
    /// <returns>不重复返回true否则返回false</returns>
    private bool CheckDuplicateUserName(HttpContext context)
    {
        string strSqlCommand = "SELECT COUNT(ID) FROM user WHERE NUMBER=@InputUserNumber";
        string strInputUserNumber = context.Request.QueryString["userName"];
        //MessageBox.Message(strInputUserNumber);
        sqlOperation.AddParameterWithValue("@InputUserNumber", strInputUserNumber);
        int intUserNumberCount = int.Parse(sqlOperation.ExecuteScalar(strSqlCommand));
        sqlOperation.Close();
        sqlOperation.Dispose();
        if (intUserNumberCount > 0)
            return false;
        return true;
    }
    #endregion

}