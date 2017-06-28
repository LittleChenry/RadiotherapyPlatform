using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_EquipmentInspection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["loginUser"] == null)
        {
            MessageBox.Message("请先登陆");
            Response.Write("<script language=javascript>window.location.replace('../Login/Login.aspx');</script>");
        }
    }
}