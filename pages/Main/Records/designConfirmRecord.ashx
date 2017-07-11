<%@ WebHandler Language="C#" Class="designConfirmRecord" %>

using System;
using System.Web;
  using System.Text;
public class designConfirmRecord : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = RecordPatientInformation(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;           
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string RecordPatientInformation(HttpContext context)
    {
        string savePath = "";
        string savepath1 = "";
        HttpFileCollection files = HttpContext.Current.Request.Files;
        savePath = System.Web.HttpContext.Current.Server.MapPath("~/upload/PDF");
        if (!System.IO.Directory.Exists(savePath))
        {
            System.IO.Directory.CreateDirectory(savePath);
        }
        savePath = savePath + "\\";
        try
        {
            System.Web.HttpPostedFile postedFile = files[0];
            string fileName = postedFile.FileName;//完整的路径 
            if (fileName == "")
            {
                savepath1 = "";
            }
            else
            {
                fileName = System.IO.Path.GetFileName(postedFile.FileName); //获取到名称
                string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
                string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
                files[0].SaveAs(savePath + DateTime.Now.ToString("yyyyMMdd") + fileName);
                savepath1 = "../../../upload/PDF/" + DateTime.Now.ToString("yyyyMMdd") + fileName;
            }       
        }
        catch (System.Exception Ex)
        {
            context.Response.Write(Ex);
        }
        try{
            string ctid = context.Request.Form["hidetreatID"];
            int CTID = Convert.ToInt32(ctid);
            //string userID = "1";
            string userID = context.Request.Form["userID"];
            int userid = Convert.ToInt32(userID);
            DateTime datetime = DateTime.Now;
            string design = "select Design_ID from treatment where treatment.ID=@treatID";
            sqlOperation.AddParameterWithValue("@treatID", CTID);
            int designID = Convert.ToInt32(sqlOperation.ExecuteScalar(design));
            string state = context.Request.Form["state"];
            bool state1 = false;
            if (state == "审核通过")
            {
                state1 = true;
            }
            string strSqlCommand = "UPDATE  design  SET State=@state,PDF=@pdf,Checkadvice=@advice,ConfirmTime=@datetime,Confirm_User_ID=@userid where design.ID=@ctID";
            //各参数赋予实际值
            sqlOperation.AddParameterWithValue("@state", state1);
            sqlOperation.AddParameterWithValue("@advice", context.Request.Form["advice"]);
            sqlOperation.AddParameterWithValue("@pdf", savepath1);
            //sqlOperation.AddParameterWithValue("@Remarks", context.Request.Form["Remarks"]);        
            sqlOperation.AddParameterWithValue("@datetime", datetime);
            sqlOperation.AddParameterWithValue("@ctID", designID);
            sqlOperation.AddParameterWithValue("@userid", userid);

            int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            string inserttreat = "update treatment set Progress=11 where ID=@treat";
            sqlOperation2.AddParameterWithValue("@treat", CTID);
            int Success = sqlOperation2.ExecuteNonQuery(inserttreat);


            if (intSuccess > 0 && Success > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }


    }
}