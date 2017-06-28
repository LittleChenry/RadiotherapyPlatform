using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

public partial class Main_Notice : System.Web.UI.Page
{ 
    
    private DataLayer sqlOperation = new DataLayer("sqlStr");//数据库操作类
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["loginUser"] == null)
        {
            MessageBox.Message("请先登陆");
            Response.Write("<script language=javascript>window.location.replace('../Main/Login.aspx');</script>");
        }
        string id=Request.QueryString["ID"];
        string sqlCommand = "SELECT Title,Content,Releasetime,user.Name RName FROM news,user WHERE news.ID=@id AND user.ID=news.Release_User_ID";
        sqlOperation.AddParameterWithValue("@id", id);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        
        if (reader.Read())
        {
            DateTime date = Convert.ToDateTime(reader["Releasetime"].ToString());
            string day = date.Year.ToString() + "-" + date.Month.ToString() + "-" + date.Day.ToString();
            this.Label3.Text = reader["Title"].ToString();
            this.Label2.Text = "发布时间:" + day + "&nbsp;&nbsp;&nbsp;&nbsp" + "发布者：" + reader["RName"];
            this.Label1.Text = reader["Content"].ToString();              
        }
    }
}