/* ***********************************************************
 * FileName: Role-information.aspx
 * Writer: lml
 * create Date: 2017-4-10
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 信息发布后台存入数据库
 * **********************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_information : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {
        string ispostback = Request.Form["postNews"];
        if (ispostback == null)
        {
            if (Session["loginUser"] == null)
            {
                MessageBox.Message("请先登陆");
                Response.Write("<script language=javascript>window.location.replace('../Login/Login.aspx');</script>");
            }
        }
        else if (IsPostBack && ispostback != null && ispostback == "true")
        {
            if (AddNews())
            {
                MessageBox.Message("发布成功！");
            }
           
        }


    }
    /// <summary>
    /// 消息发布到数据库
    /// </summary>
    /// <returns></returns>
    private Boolean AddNews()
    {
        //获取表单信息
        UserInformation loginUser = (UserInformation)Session["loginUser"];
        int Release_User_ID = loginUser.GetUserID();
        string Title = Request.Form["title"];
        string Content = Request.Form["mainText"];
        bool Important = (Request.Form["important"] == "1") ? true : false;
        string Permission = Request.Form["selectedRole"];
        string sqlSqlCommand = "SELECT COUNT(ID) FROM news WHERE Release_User_ID=@Release_User_ID AND Title=@Title AND Content=@Content";
        sqlOperation.AddParameterWithValue("@Release_User_ID", Release_User_ID);
        sqlOperation.AddParameterWithValue("@Title", Title);
        sqlOperation.AddParameterWithValue("@Content", Content);
        sqlOperation.AddParameterWithValue("@Important", Important);
        sqlOperation.AddParameterWithValue("@Permission", Permission);
        sqlOperation.AddParameterWithValue("@Releasetime", DateTime.Now);
        int has = int.Parse(sqlOperation.ExecuteScalar(sqlSqlCommand));
        if(has > 0){
            return false;
        }
        //将信息写入数据库，并返回是否成功
        string strSqlCommand = "INSERT INTO news(Release_User_ID,Title,Content,Important,Permission,Releasetime) " +
                                "VALUES(@Release_User_ID,@Title,@Content,@Important,@Permission,@Releasetime)";
        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
        return (intSuccess > 0) ? true : false;
    }
}