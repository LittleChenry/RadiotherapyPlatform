using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_userInformation : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private int deleteRow;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["loginUser"] == null)
            {
                MessageBox.Message("请先登陆");
                Response.Write("<script language=javascript>window.location.replace('../Login/Login.aspx');</script>");
            }
        }
       
    }
}