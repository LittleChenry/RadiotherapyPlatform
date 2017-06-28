using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_function : System.Web.UI.Page
{
    private int deleteRow;
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void functionObjectDataSource_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
    {
        GridViewRow row = functionGridView.Rows[deleteRow];
        string id = row.Cells[0].Text;
        e.InputParameters["ID"] = id;
    }
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)((LinkButton)sender).NamingContainer).RowIndex;
        deleteRow = rowIndex;
    }
}