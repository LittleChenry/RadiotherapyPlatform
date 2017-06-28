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
        string isposback = Request.Form["ispostback"];
        if (isposback != null && isposback == "true")
        {
            if (RecordUserInformation())
            {
                MessageBox.Message("添加成功");
            }
            else
            {
                MessageBox.Message("添加失败");
            }
        }
    }

    #region 检查用户名是否重复
    /// <summary>
    /// 检查用户名是否重复
    /// </summary>
    /// <returns>不重复返回true否则返回false</returns>
    private bool CheckDuplicateUserName()
    {
        string strSqlCommand = "SELECT COUNT(ID) FROM user WHERE NUMBER=@InputUserNumber";
        string strInputUserNumber = Request.Form["userNumber"];
        //MessageBox.Message(strInputUserNumber);
        sqlOperation.AddParameterWithValue("@InputUserNumber", strInputUserNumber);
        int intUserNumberCount = int.Parse(sqlOperation.ExecuteScalar(strSqlCommand));
        if (intUserNumberCount > 0)
            return false;
        return true;
    }
    #endregion

    #region 记录新用户信息
    /// <summary>
    /// 记录新用户信息
    /// </summary>
    /// <returns></returns>
    private bool RecordUserInformation()
    {
        if (!CheckDuplicateUserName())
        {
            MessageBox.Message("用户名重复请输入其他用户名");
            return false;
        }
        string strSqlCommand = "INSERT INTO user(number,password,name,gender,contact,office,Activate) VALUES("
         + "@userNumber,@psw,@name,@gender,@contact,@office,@activate)";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@userNumber", Request.Form["userNumber"]);
        sqlOperation.AddParameterWithValue("@psw", Request.Form["userKey"]);
        sqlOperation.AddParameterWithValue("@name", Request.Form["userName"]);
        sqlOperation.AddParameterWithValue("@gender", Request.Form["gender"]);
        sqlOperation.AddParameterWithValue("@contact", Request.Form["phoneNumber"]);
        sqlOperation.AddParameterWithValue("@office", Request.Form["officeSelect"]);
        sqlOperation.AddParameterWithValue("@activate", int.Parse(Request.Form["activate"]));

        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
        if (intSuccess > 0)
        {
            strSqlCommand = "SELECT ID FROM user WHERE Number=@userNumber";
            string id = sqlOperation.ExecuteScalar(strSqlCommand);
            string []roles = Request.Form["selectedRole"].Split(' ');
            strSqlCommand = "SELECT ID FROM role WHERE NAME=@roleName";
            for (int i = 0; i < roles.Length; i++)
            {
                if (roles[i] != " " && roles[i] != "")
                {                    
                    sqlOperation.AddParameterWithValue("@roleName", roles[i]);
                    string roleID = sqlOperation.ExecuteScalar(strSqlCommand);
                    string insertCommand = "INSERT INTO user2role(User_ID,Role_ID) VALUES('" + id + "','" + roleID + "')";
                    sqlOperation.ExecuteNonQuery(insertCommand);
                }
            }
            return true;
        }
        else
            return false;
    }
    #endregion
    #region 根据绑定的性别，显示相应中文
    /// <summary>
    /// 根据绑定的性别，显示相应中文
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public string GetGender(object str)
    {
        string gender = str.ToString();
        if (gender == "M")
        {
            return "男";
        }
        else
            return "女";
    }
    #endregion
    #region 根据绑定的激活状态，显示相应中文
    /// <summary>
    /// 根据绑定的激活状态，显示相应中文
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public string GetActive(object str)
    {
        int active = int.Parse(str.ToString());
        if (active == 1)
        {
            return "已激活";
        }
        else
            return "未激活";
    }
    #endregion
    #region 根据激活状态，显示按钮文本
    /// <summary>
    /// 根据激活状态，显示按钮文本
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    public string GetButtonText(object str)
    {
        int active = int.Parse(str.ToString());
        if (active == 1)
        {
            return "反激活";
        }
        else
            return "激活";
    }
    #endregion
    #region 数据源更新传参
    /// <summary>
    /// 数据源更新传参
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void userDataSource_Updating(object sender, ObjectDataSourceMethodEventArgs e)
    {
        int index = User.EditIndex;
        GridViewRow row = User.Rows[index];
        string sex = (row.FindControl("sexRadio") as RadioButtonList).SelectedValue;
        e.InputParameters["Gender"] = sex;
        string number = Request.Form["Number"];
        e.InputParameters["Number"] = number;
        string phone = Request.Form["contact"];
        e.InputParameters["contact"] = phone;
        string office = (row.FindControl("office") as DropDownList).SelectedValue;
        e.InputParameters["office"] = office;
    }
    #endregion
    #region 改变激活状态，同时修改按钮文本
    /// <summary>
    /// 改变激活状态，同时修改按钮文本
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Activate_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)((LinkButton)sender).NamingContainer).RowIndex;
        GridViewRow row = User.Rows[rowIndex];
        string number = (row.FindControl("userNumber") as Label).Text;
        string activate = (row.FindControl("ActivateLabel") as Label).Text;
        int bit = (activate == "已激活" ? 0 : 1);
        string sqlCommand = "UPDATE user set Activate=@activate WHERE Number=@number";
        sqlOperation.AddParameterWithValue("@activate", bit);
        sqlOperation.AddParameterWithValue("@number", number);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        if (bit == 0)
        {
            (row.FindControl("ActivateLabel") as Label).Text = "未激活";
            (sender as LinkButton).Text = "激活";
        }
        else
        {
            (row.FindControl("ActivateLabel") as Label).Text = "已激活";
            (sender as LinkButton).Text = "反激活";
        }
    }
    #endregion
    #region 数据源删除操作传参
    /// <summary>
    /// 数据源删除操作传参
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void userDataSource_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
    {
        int rowIndex = deleteRow;
        GridViewRow row = User.Rows[rowIndex];
        string number = (row.FindControl("userNumber") as Label).Text;
        e.InputParameters["Number"] = number;
    }
    #endregion
    #region 找到要删除的行
    /// <summary>
    /// 找到要删除的行
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void DeleteLinkButton_Click(object sender, EventArgs e)
    {
        int rowIndex = ((GridViewRow)((LinkButton)sender).NamingContainer).RowIndex;
        deleteRow = rowIndex;
    }
    #endregion
}