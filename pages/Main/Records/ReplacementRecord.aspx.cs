using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_ReplacementRecord : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {

        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
        //不是第一次加载页面进行录入
        if (myispostback != null && myispostback == "true")
        {
            if (RecordPatientInformation())
            {
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
        string savepath2 = "";
        int first = Convert.ToInt32(Request.Form["cankaodrr"]);
        int second = Convert.ToInt32(Request.Form["yanzheng"]);
        HttpFileCollection files = HttpContext.Current.Request.Files;
        savePath = Server.MapPath("~/upload/replacerecord");
        if (!System.IO.Directory.Exists(savePath))
        {
            System.IO.Directory.CreateDirectory(savePath);
        }
        savePath = savePath + "\\";
        try
        {
            for (int i = 0; i < files.Count; i++)
            {
                if (i <= first)
                {
                    System.Web.HttpPostedFile postedFile = files[i];
                    string fileName = postedFile.FileName;//完整的路径
                    fileName = System.IO.Path.GetFileName(postedFile.FileName); //获取到名称
                    string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
                    string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
                    if (files[i].ContentLength > 0)
                    {
                        files[i].SaveAs(savePath + DateTime.Now.ToString("yyyyMMdd") + fileName);
                        savepath1 = savepath1 + "," + "/RadiotherapyPlatform/upload/replacerecord/" + DateTime.Now.ToString("yyyyMMdd") + fileName;
                    }

                }
                else
                {
                    System.Web.HttpPostedFile postedFile = files[i];
                    string fileName = postedFile.FileName;//完整的路径
                    fileName = System.IO.Path.GetFileName(postedFile.FileName); //获取到名称
                    string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
                    string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
                    if (files[i].ContentLength > 0)
                    {
                        files[i].SaveAs(savePath + DateTime.Now.ToString("yyyyMMdd") + fileName);
                        savepath2 = savepath2 + "," + "/RadiotherapyPlatform/upload/replacerecord/" + DateTime.Now.ToString("yyyyMMdd") + fileName;
                    }

                }

            }
        }
        catch (System.Exception Ex)
        {
            Response.Write(Ex);
        }
        string treatid = Request.Form["hidetreatID"];
        int treatID = Convert.ToInt32(treatid);
        string replacementid = "select Replacement_ID from treatment where treatment.ID=@treatid";
        sqlOperation.AddParameterWithValue("@treatid", treatID);
        int replacementID = int.Parse(sqlOperation.ExecuteScalar(replacementid));
        string userID = Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;
        string strSqlCommand = "UPDATE replacement SET Remarks=@remark,OriginCenter=@OriginCenter,PlanCenter=@PlanCenter,Movement=@Movement,ReferenceDRRPicture=@ReferenceDRRPicture,VerificationPicture=@VerificationPicture,Result=@Result,OperateTime=@datetime,Operate_User_ID=@userid where replacement.ID=@replacementID";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@replacementID", replacementID);
        sqlOperation.AddParameterWithValue("@OriginCenter", Request.Form["OriginCenter1"] + "," + Request.Form["OriginCenter2"] + "," + Request.Form["OriginCenter3"]);
        sqlOperation.AddParameterWithValue("@PlanCenter", Request.Form["PlanCenter1"] + "," + Request.Form["PlanCenter2"] + "," + Request.Form["PlanCenter3"]);
        sqlOperation.AddParameterWithValue("@Movement", Request.Form["Movement1"] + "," + Request.Form["Movement2"] + "," + Request.Form["Movement3"]);
        sqlOperation.AddParameterWithValue("@ReferenceDRRPicture", savepath1);
        sqlOperation.AddParameterWithValue("@VerificationPicture", savepath2);
        sqlOperation.AddParameterWithValue("@Result", Request.Form["Result1"] + "," + Request.Form["Result2"] + "," + Request.Form["Result3"]);
        sqlOperation.AddParameterWithValue("@datetime", datetime);
        sqlOperation.AddParameterWithValue("@userid", userid);
        sqlOperation.AddParameterWithValue("@remark", Request.Form["remark"]);
        int intSuccess1=sqlOperation.ExecuteNonQuery(strSqlCommand);
        string strSqlCommand1 = "UPDATE  appointment  SET Completed=1 where Treatment_ID=@treatid and Task='模拟定位'";
        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand1);
        string strSqlCommand2 = "UPDATE  treatment  SET Progress=15 where ID=@treatid ";
        int intSuccess2 = sqlOperation.ExecuteNonQuery(strSqlCommand2);
        if (intSuccess > 0 && intSuccess2 > 0 && intSuccess1>0)
        {
            
            return true;
        }
        else
        {
            return false;
        }

    }
}