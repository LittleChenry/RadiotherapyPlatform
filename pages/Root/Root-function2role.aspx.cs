using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_function2role : System.Web.UI.Page
{
    DataLayer sqlOperation = new DataLayer("sqlStr");

    protected void Page_Load(object sender, EventArgs e)
    {
        string ispostback = Request.Form["ispostback"];
        if (ispostback != null && ispostback == "true")
        {
            recordNewFunction();
            int index = int.Parse(Request.Form["pageIndex"]);
            f2rGridView.PageIndex = index;
            MessageBox.Message("更改成功");
        }
        if (Session["loginUser"] == null)
        {
            MessageBox.Message("请先登陆");
            Response.Write("<script language=javascript>window.location.replace('../Main/Login.aspx');</script>");
        }
    }

    private void recordNewFunction()
    {
        string selectedFunction = Request.Form["updateFunctions"];
        string[] selectArray = selectedFunction.Split(' ');
        string roleID = Request.Form["RoleID"];
        string deleteAll = "DELETE FROM function2role WHERE Role_ID=@id";
        sqlOperation.AddParameterWithValue("@id", roleID);
        sqlOperation.ExecuteNonQuery(deleteAll);
        string sqlCommand = "INSERT INTO function2role(Function_ID,Role_ID) VALUES(@fid,@rid)";
        sqlOperation.AddParameterWithValue("@rid", roleID);
        for (int i = 0; i < selectArray.Length; i++)
        {
            if (selectArray[i] != "")
            {
                sqlOperation.AddParameterWithValue("@fid", selectArray[i]);
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
        }
    }

    public string GetFunction(object str)
    {
        string id = str.ToString();
        string sqlCommand = "SELECT Function_ID,Name FROM function2role,function WHERE Role_ID=@id AND Function_ID=function.ID";
        sqlOperation.AddParameterWithValue("@id", id);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        string backString = "";
        while (reader.Read())
        {
            backString += reader["Name"] + " ";
        }
        sqlOperation.Close();
        if (backString == "")
        {
            return "无";
        }
        return backString;
    }
}