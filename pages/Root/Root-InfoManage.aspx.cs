using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
/* ***********************************************************
 * FileName: Root-InfoManage.aspx.cs
 * Writer: xubixiao
 * create Date: 2017-4-2
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 消息管理后台
 * **********************************************************/
public partial class Root_Root_InfoManage : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");//数据库操作类
    protected void Page_Load(object sender, EventArgs e)
    {
        string id=Request.QueryString["ID"];
        int newsid=Convert.ToInt32(id);
        string type = Request.QueryString["Type"];
        int newstype=Convert.ToInt32(type);
         switch(newstype)
         {
             case 0: delete(id); break;
             case 1: setTop(id); break;
             case 10: removeTop(id); break;
             default: break;
         }
         if (Session["loginUser"] == null)
         {
             MessageBox.Message("请先登陆");
             Response.Write("<script language=javascript>window.location.replace('../Main/Login.aspx');</script>");
         }
    }
    public void delete(String  id)
    {
        sqlOperation.clearParameter();
         string sqlCommand = "DELETE FROM news WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
         sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    public void setTop(String id)
    {
        sqlOperation.clearParameter();
        string sqlCommand = "UPDATE news SET Important=1 WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    public void removeTop(String id)
    {
    
        sqlOperation.clearParameter();
        string sqlCommand = "UPDATE news SET Important=0 WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
 
}