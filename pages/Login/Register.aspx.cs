using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Login_Register : System.Web.UI.Page
{
    //数据层操作类
    private DataLayer sqlOperation = new DataLayer("sqlStr");

    #region PageLoad
    protected void Page_Load(object sender, EventArgs e)
    {
        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
        //不是第一次加载页面进行录入
        if (myispostback != null && myispostback == "true")
        {
            if (RecordUserInformation())
            {
                MessageBox.Message("注册成功,即将跳转到登陆界面");
                Response.Write("<script language=javascript>window.location.replace('Login.aspx');</script>");
            }
            else
            {
                MessageBox.Message("注册失败");
            }
        }
    }
    #endregion

    #region 检查用户名是否重复
    /// <summary>
    /// 检查用户名是否重复
    /// </summary>
    /// <returns>不重复返回true否则返回false</returns>
    private bool CheckDuplicateUserName()
    {
        string strSqlCommand = "SELECT COUNT(ID) FROM user WHERE NUMBER=@InputUserNumber";
        string strInputUserNumber = Request.Form["userName"];
        //MessageBox.Message(strInputUserNumber);
        sqlOperation.AddParameterWithValue("@InputUserNumber", strInputUserNumber);
        int intUserNumberCount = int.Parse(sqlOperation.ExecuteScalar(strSqlCommand));
        if (intUserNumberCount > 0)
            return false;
        return true;
    }
    #endregion

    #region 记录新用户信息
    /// <summary>
    /// 记录新用户信息
    /// </summary>
    /// <returns></returns>
    private bool RecordUserInformation()
    {
        if (!CheckDuplicateUserName())
        {
            MessageBox.Message("用户名重复请输入其他用户名");
            return false;
        }
        string strSqlCommand = "INSERT INTO user(number,password,name,gender,contact,office) VALUES("
         + "@userNumber,@psw,@name,@gender,@contact,@office)";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@userNumber", Request.Form["userName"]);
        sqlOperation.AddParameterWithValue("@psw", Request.Form["userKey"]);
        sqlOperation.AddParameterWithValue("@name", Request.Form["name"]);
        sqlOperation.AddParameterWithValue("@gender", Request.Form["sex"]);
        sqlOperation.AddParameterWithValue("@contact", Request.Form["phoneNumber"]);
        sqlOperation.AddParameterWithValue("@office", Request.Form["office"]);

        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
        if (intSuccess > 0)
            return true;
        else
            return false;
    }
    #endregion
}