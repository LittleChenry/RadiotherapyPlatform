<%@ WebHandler Language="C#" Class="LoginInformation" %>

using System;
using System.Web;
using System.Collections.Generic;

public class LoginInformation : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");//数据库操作类

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backText = "{\"userRole\":[";
        string getText = UserLogin(context);
        if (getText.Length >= 5 && getText.Substring(0, 5) == "false")
        {
            backText += "{\"Name\":\"" + getText + "\",\"Type\":\"null\"}]}";
            context.Response.Write(backText);
            return;
        }

        string[] Roles = getText.Split(' ');
        Dictionary<string, string> roleDrroleDescription = UserInformation.GetRoleName();
        for (int i = 0; i < Roles.Length - 1; i++)
        {
            backText += "{\"Name\":\"" + Roles[i] + "\",\"Type\":\"" + roleDrroleDescription[Roles[i]] + "\"}";
            if (i < Roles.Length - 2)
            {
                backText += ",";
            }
            else
            {
                backText += "]}";
            }
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backText);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    #region 检查用户名是否存在
    /// <summary>
    /// 检查用户名是否存在
    /// </summary>
    /// <returns></returns>
    private bool CheckUserNameExist()
    {
        string strSqlCommand = "SELECT COUNT(id) FROM user WHERE number=@number";
        int intResult = int.Parse(sqlOperation.ExecuteScalar(strSqlCommand));
        return (intResult > 0);
    }
    #endregion

    #region 核查用户是否激活
    /// <summary>
    /// 核查用户是否激活
    /// </summary>
    /// <returns></returns>
    private bool CheckUserIsActivate()
    {
        string strSqlCommand = "SELECT activate FROM user WHERE number=@number";
        string isActivate = sqlOperation.ExecuteScalar(strSqlCommand);
        return (isActivate == "1");
    }
    #endregion

    #region 获取密码
    /// <summary>
    /// 获取数据库中用户密码
    /// </summary>
    /// <returns></returns>
    private string GetUserPassword(HttpContext context)
    {
        string strSqlCommand = "SELECT password FROM user WHERE number=@number";
        //string userName = context.Request.Form["userNumber"];
        string userName = context.Request.QueryString["userNumber"];
        return sqlOperation.ExecuteScalar(strSqlCommand);
    }
    #endregion

    #region 核查用户角色
    /// <summary>
    /// 核查用户所有拥有角色
    /// </summary>
    /// <returns></returns>
    private string CheckUserRole()
    {
        string strSqlCommand = "SELECT role.description roleDescription,role.name roleName FROM role,user,user2role WHERE user.number=@number"
            + " and user.id=user2role.User_ID and user2role.Role_ID=role.ID";
        string userType = "";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(strSqlCommand);
        while (reader.Read())
        {
            userType += reader["roleDescription"].ToString() + " ";
            //this.RoleName[reader["roleDescription"].ToString()] = reader["roleName"].ToString();
        }
        return userType;
    }
    #endregion

    #region @number参数赋予
    /// <summary>
    /// 给sql命令@number参数赋予对象
    /// </summary>
    private void addParam(HttpContext context)
    {
        sqlOperation.clearParameter();//先清空防止多次赋予异常
        if (context.Request.Form["userNumber"] != "")
        {
            //string userName = context.Request.Form["userNumber"];
            string userName = context.Request["userNumber"];
            sqlOperation.AddParameterWithValue("@number", userName);
        }
    }
    #endregion

    #region 用户登录
    /// <summary>
    /// 用户登陆
    /// </summary>
    private string UserLogin(HttpContext context)
    {
        addParam(context);
        if (!CheckUserNameExist())
        {
            return "false-notexist";
        }
        string userKey = GetUserPassword(context);
        //string entrePsw = context.Request.Form["userKey"];
        string entrePsw = context.Request.QueryString["userKey"];
        if (userKey == entrePsw)
        {
            if (!CheckUserIsActivate())
            {
                return "false-notactivate";
            }
            string userRoles = CheckUserRole();//核查用户角色
            return userRoles;
        }
        else
        {
            return "false-errorKey";
        }
    }
    #endregion

}