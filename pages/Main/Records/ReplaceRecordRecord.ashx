<%@ WebHandler Language="C#" Class="ReplaceRecordRecord" %>

using System;
using System.Web;
using System.Text;
public class ReplaceRecordRecord : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(RecordReplaceInformation(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string RecordReplaceInformation(HttpContext context)
    {
        string savePath = "";
        string savepath1 = "";
        HttpFileCollection files =context.Request.Files;
        savePath = System.Web.HttpContext.Current.Server.MapPath("~/upload/replacerecord");
        if (!System.IO.Directory.Exists(savePath))
        {
            System.IO.Directory.CreateDirectory(savePath);
        }
        savePath = savePath + "\\";
        try
        {
            for (int i = 0; i < files.Count; i++)
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
        }
        catch (System.Exception Ex)
        {
            context.Response.Write(Ex);
        }
        string treatid = context.Request.Form["hidetreatID"];
        int treatID = Convert.ToInt32(treatid);
        string replacementid = "select Replacement_ID from treatment where treatment.ID=@treatid";
        sqlOperation.AddParameterWithValue("@treatid", treatID);
        int replacementID = int.Parse(sqlOperation.ExecuteScalar(replacementid));
        string userID = context.Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;
        string strSqlCommand = "UPDATE replacement SET Remarks=@remark,OriginCenter=@OriginCenter,PlanCenter=@PlanCenter,Movement=@Movement,VerificationPicture=@VerificationPicture,Result=@Result,Distance=@distance,OperateTime=@datetime,Operate_User_ID=@userid where replacement.ID=@replacementID";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@replacementID", replacementID);
        sqlOperation.AddParameterWithValue("@OriginCenter", context.Request.Form["OriginCenter1"] + "," +context.Request.Form["OriginCenter2"] + "," + context.Request.Form["OriginCenter3"]);
        sqlOperation.AddParameterWithValue("@PlanCenter", context.Request.Form["PlanCenter1"] + "," + context.Request.Form["PlanCenter2"] + "," + context.Request.Form["PlanCenter3"]);
        sqlOperation.AddParameterWithValue("@Movement", context.Request.Form["Movement1"] + "," + context.Request.Form["Movement2"] + "," + context.Request.Form["Movement3"]);
        sqlOperation.AddParameterWithValue("@distance", context.Request.Form["distance1"] + "," + context.Request.Form["distance2"] + "," + context.Request.Form["distance3"]);
        sqlOperation.AddParameterWithValue("@VerificationPicture", savepath1);
        sqlOperation.AddParameterWithValue("@Result", context.Request.Form["Result1"] + "," + context.Request.Form["Result2"] + "," + context.Request.Form["Result3"]);
        sqlOperation.AddParameterWithValue("@datetime", datetime);
        sqlOperation.AddParameterWithValue("@userid", userid);
        sqlOperation.AddParameterWithValue("@remark", context.Request.Form["Remarks"]);
        int intSuccess1 = sqlOperation.ExecuteNonQuery(strSqlCommand);
        string strSqlCommand1 = "UPDATE  appointment  SET Completed=1 where Treatment_ID=@treatid and Task='模拟定位'";
        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand1);
        string select1 = "select Progress from treatment where ID=@treatid";
        string progress = sqlOperation.ExecuteScalar(select1);
        string strSqlCommand2 = "UPDATE  treatment  SET Progress=@progress where ID=@treatid ";
        sqlOperation.AddParameterWithValue("@progress", progress + ",13");
        int intSuccess2 = sqlOperation.ExecuteNonQuery(strSqlCommand2);
        if (intSuccess > 0 && intSuccess2 > 0 && intSuccess1 > 0)
        {

            return "success";
        }
        else
        {
            return "error";
        }

    }
}