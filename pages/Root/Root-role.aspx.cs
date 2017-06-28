using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_role : System.Web.UI.Page
{
    private int deleteRow;
    private DataLayer sqlOperation = new DataLayer("sqlStr");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["loginUser"] == null)
            {
                //MessageBox.Message("请先登陆");
                //Response.Write("<script language=javascript>window.location.replace('../Main/Login.aspx');</script>");
            }
        }
        string isposback = Request.Form["ispostback"];
        if (isposback != null && isposback == "true")
        {
            if (addNewRole())
            {
                MessageBox.Message("成功添加");
            }else{
                MessageBox.Message("添加失败");
            }
        }
    }

    private bool addNewRole()
    {
        string Name = Request.Form["roleName"];
        string Description = Request.Form["roleDescription"];
        string Selected = Request.Form["selectedFunction"];
        string sqlCommand = "INSERT INTO role(Name,Description) VALUES(@name,@description)";
        sqlOperation.AddParameterWithValue("@name", Name);
        sqlOperation.AddParameterWithValue("@description", Description);
        int success = sqlOperation.ExecuteNonQuery(sqlCommand);
        if (success > 0)
        {
            sqlCommand = "SELECT ID FROM role WHERE Name=@name";
            string id = sqlOperation.ExecuteScalar(sqlCommand);
            sqlOperation.AddParameterWithValue("@RID", id);
            string[] select = Selected.Split(' ');
            for (int i = 0; i < select.Length; i++)
            {
                if (select[i] != "")
                {
                    sqlCommand = "INSERT INTO function2role(Function_ID,Role_ID) VALUES(@FID,@RID)";
                    sqlOperation.AddParameterWithValue("@FID", select[i]);
                    sqlOperation.ExecuteNonQuery(sqlCommand);
                }
            }
            return true;
        }
        return false;
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)((LinkButton)sender).NamingContainer).RowIndex;
        deleteRow = rowIndex;
    }
    protected void roleObjectDataSource_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
    {
        GridViewRow row = roleGridView.Rows[deleteRow];
        string id = (row.FindControl("Label1") as Label).Text;
        e.InputParameters["id"] = id;
    }
    protected void roleObjectDataSource_Updating(object sender, ObjectDataSourceMethodEventArgs e)
    {
        int editIndex = roleGridView.EditIndex;
        GridViewRow editRow = roleGridView.Rows[editIndex];
        string id = (editRow.FindControl("Label2") as Label).Text;
        e.InputParameters["id"] = id;
    }
}