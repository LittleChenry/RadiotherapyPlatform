using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;

public partial class pages_Main_Records_DesignConfirm : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {

        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
        //不是第一次加载页面进行录入
        if (myispostback != null && myispostback == "true")
        {
            if (RecordPatientInformation())
            {
                sqlOperation.Close();
                sqlOperation.Dispose();
                sqlOperation = null;              
                sqlOperation2.Close();
                sqlOperation2.Dispose();
                sqlOperation2 = null;
                MessageBox.Message("保存成功!");

            }
            else
            {            
                MessageBox.Message("保存失败");
            }
        }

    }

    private bool RecordPatientInformation()
    {
        string savePath = "";
        string savepath1 = "";
        HttpFileCollection files = HttpContext.Current.Request.Files;
        savePath = Server.MapPath("~/upload/PDF");
        if (!System.IO.Directory.Exists(savePath))
        {
            System.IO.Directory.CreateDirectory(savePath);
        }
        savePath = savePath + "\\";
        try
        {
            System.Web.HttpPostedFile postedFile = files[0];
            string fileName = postedFile.FileName;//完整的路径         
            fileName = System.IO.Path.GetFileName(postedFile.FileName); //获取到名称
            string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
            string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
            files[0].SaveAs(savePath + DateTime.Now.ToString("yyyyMMdd") + fileName);
            savepath1 = "../../../upload/PDF/" + DateTime.Now.ToString("yyyyMMdd") + fileName;            
        }
        catch (System.Exception Ex)
        {
            Response.Write(Ex);
        }
        string ctid = Request.Form["hidetreatID"];
        int CTID = Convert.ToInt32(ctid);
        //string userID = "1";
        string userID = Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;
        string design = "select Design_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", CTID);
        int designID = Convert.ToInt32(sqlOperation.ExecuteScalar(design));
        string state = Request.Form["state"];
        bool state1 = false;
        if (state == "审核通过")
        {
            state1 = true;
        }
        string strSqlCommand = "UPDATE  design  SET State=@state,PDF=@pdf,Checkadvice=@advice,ConfirmTime=@datetime,Confirm_User_ID=@userid where design.ID=@ctID";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@state", state1);
        sqlOperation.AddParameterWithValue("@advice", Request.Form["advice"]);
        sqlOperation.AddParameterWithValue("@pdf", savepath1);
        //sqlOperation.AddParameterWithValue("@Remarks", Request.Form["Remarks"]);        
        sqlOperation.AddParameterWithValue("@datetime", datetime);
        sqlOperation.AddParameterWithValue("@ctID", designID);
        sqlOperation.AddParameterWithValue("@userid", userid);

        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
        string inserttreat = "update treatment set Progress=11 where ID=@treat";
        sqlOperation2.AddParameterWithValue("@treat", CTID);
        int Success = sqlOperation2.ExecuteNonQuery(inserttreat);


        if (intSuccess > 0 && Success > 0)
        {

            return true;
        }
        else
        {
            return false;
        }

    }
}