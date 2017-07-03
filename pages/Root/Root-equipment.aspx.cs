using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_equipment : System.Web.UI.Page
{
    DataLayer sqlOperation = new DataLayer("sqlStr");
    private int deleteIndex;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["loginUser"] == null)
        {
            MessageBox.Message("请先登陆");
            Response.Write("<script language=javascript>window.location.replace('../Login/Login.aspx');</script>");
        }
    }
    

    public string GetState(object str)
    {
        int state = int.Parse(str.ToString());
        switch (state)
        {
            case 1:
                return "可使用";
            case 2:
                return "检查中";
            case 3:
                return "维修中";
        }
        return "";
    }

    public string GetTime(object str)
    {
        int time = int.Parse(str.ToString());
        int hour = time / 60;
        int minute = time - hour*60;
        return (hour.ToString() + ":" + (minute < 10 ? "0" : "") + minute.ToString());
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)((LinkButton)sender).NamingContainer).RowIndex;
        deleteIndex = rowIndex;
    }
    protected void equipmentObjectDataSource_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
    {
        GridViewRow row = equipmentGridView.Rows[deleteIndex];
        string id = (row.FindControl("equipmentID") as HiddenField).Value;
        e.InputParameters["id"] = id;
    }

}