using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Login_Login : System.Web.UI.Page
{
    DataLayer sqlOperation = new DataLayer("sqlStr");//数据库操作对象
    protected void Page_Load(object sender, EventArgs e)
    {
        string ispostback = Request.QueryString["ispostback"];
        if (ispostback == null)
        {
            Session.Clear();
        }
        if (ispostback != null && ispostback == "true")
        {
            RecordUserInformation();
        }
    }

    #region 记录登陆用户信息
    /// <summary>
    /// 记录登陆用户信息
    /// </summary>
    private void RecordUserInformation()
    {
        string strSqlCommand = "SELECT * FROM user WHERE number=@number";
        addParam();
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(strSqlCommand);

        if (reader.Read())
        {
            int userID = int.Parse(reader["ID"].ToString());
            string userName = reader["name"].ToString();
            string userNumber = reader["number"].ToString();
            UserInformation thisUser = new UserInformation(userID, userNumber, userName);
            Session.Timeout = 1440;
            Session["loginUser"] = thisUser;
        }
        sqlOperation.Close();
    }
    #endregion

    #region @number参数赋予
    /// <summary>
    /// 给sql命令@number参数赋予对象
    /// </summary>
    private void addParam()
    {
        sqlOperation.clearParameter();//先清空防止多次赋予异常
        if (Request.Form["userID"] != "")
        {
            string userName = Request.QueryString["userID"];
            sqlOperation.AddParameterWithValue("@number", userName);
        }
    }
    #endregion
}