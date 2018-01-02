using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Root_Root_user2role : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {
        string ispostback = Request.Form["ispostback"];
        if (ispostback != null && ispostback == "true")
        {
            recordNewRole();
            int index = int.Parse(Request.Form["pageIndex"]);
            MessageBox.Message("更改成功");
        }
        if (Session["loginUser"] == null)
        {
            MessageBox.Message("请先登陆");
            Response.Write("<script language=javascript>window.location.replace('../Login/Login.aspx');</script>");
        }
    }
    /// <summary>
    /// 向数据库记录修改的角色。
    /// </summary>
    private void recordNewRole()
    {
        string newRoles = Request.Form["updateRoles"];
        string []roles = newRoles.Split(' ');
        string Number = Request.Form["userNumber"];
        string sqlCommand = "DELETE FROM user2role WHERE User_ID=(SELECT ID FROM user WHERE user.Number=@number)";
        sqlOperation.AddParameterWithValue("@number",Number);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        string userID = sqlOperation.ExecuteScalar("SELECT ID FROM user WHERE user.Number=@number");
        sqlOperation.AddParameterWithValue("@userID", userID);
        for (int i = 0; i < roles.Length; i++)
        {
            if (roles[i] != "")
            {
                sqlCommand = "SELECT ID FROM role WHERE Name=@name";
                sqlOperation.AddParameterWithValue("@name", roles[i]);
                string roleID = sqlOperation.ExecuteScalar(sqlCommand);
                sqlCommand = "INSERT INTO user2role(User_ID,Role_ID) VALUES(@userID,@roleID)";
                sqlOperation.AddParameterWithValue("@roleID", roleID);
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
        }
    }
    /// <summary>
    /// 根据绑定激活状态(1,0)，显示(已激活，未激活)
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public string GetActivate(object str)
    {
        int activate = int.Parse(str.ToString());
        if (activate == 1)
        {
            return "已激活";
        }
        else
        {
            return "未激活";
        }
    }
    /// <summary>
    /// 根据绑定的已拥有角色，显示相应中文。
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public string GetRoles(object str)
    {
        string id = str.ToString();
        string sqlCommand = "SELECT Description FROM user2role,role WHERE user2role.User_ID=@id AND user2role.Role_ID=role.ID";
        sqlOperation.AddParameterWithValue("@id", id);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        string backString = "";
        while (reader.Read())
        {
            backString += reader["Description"].ToString() + "  ";
        }
        sqlOperation.Close();
        if (backString == "")
        {
            backString = "无";
        }
        return backString;
    }

}