<%@ WebHandler Language="C#" Class="locationRecordRecord" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class locationRecordRecord : IHttpHandler {
     private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation3 = new DataLayer("sqlStr");
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
            sqlOperation3.Close();
            sqlOperation3.Dispose();
            sqlOperation3 = null;
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
        savePath = System.Web.HttpContext.Current.Server.MapPath("~/upload/LocationRecord");

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
                    savepath1 = savepath1 + "," + "/RadiotherapyPlatform/upload/LocationRecord/" + DateTime.Now.ToString("yyyyMMdd") + fileName;

                }
            }
        }
        catch (System.Exception Ex)
        {
            context.Response.Write(Ex);
        }
        try
        {
            string treatid = context.Request.Form["hidetreatID"];
            int treatID = Convert.ToInt32(treatid);
            string locationid = "select Location_ID from treatment where treatment.ID=@treatid";
            sqlOperation.AddParameterWithValue("@treatid", treatID);
            int LocationID = int.Parse(sqlOperation.ExecuteScalar(locationid));
            //string userID = "1";
            string userID = context.Request.Form["userID"];
            int userid = Convert.ToInt32(userID);
            DateTime datetime = DateTime.Now;
            //bool state = false;
            string select1 = "select Progress from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatID);
            string progress = sqlOperation.ExecuteScalar(select1);
            string[] group = progress.Split(',');
            bool exists = ((IList)group).Contains("5");

            if (!exists)
            {
                string strSqlCommand = "UPDATE  location  SET ScanPart_ID=@ScanPart_ID,ScanMethod_ID=@ScanMethod_ID,RemarksRecords=@RemarksRecords,EnhanceMethod_ID=@EnhanceMethod_ID,Enhance=@Enhance,Remarks=@Remarks,LowerBound=@LowerBound,UpperBound=@UpperBound,LocationRequirements_ID=@LocationRequirements_ID,CTPictures=@picture,Thickness=@thickness,Number=@number,ReferenceNumber=@ReferenceNumber,ReferenceScale=@ReferenceScale,OperateTime=@datetime,Operate_User_ID=@userid where location.ID=@locationID";
                //各参数赋予实际值
                sqlOperation.AddParameterWithValue("@locationID", LocationID);
                sqlOperation.AddParameterWithValue("@thickness", context.Request.Form["Thickness"]);
                sqlOperation.AddParameterWithValue("@ScanPart_ID", context.Request.Form["scanpart"]);
                sqlOperation.AddParameterWithValue("@ScanMethod_ID", Convert.ToInt32(context.Request.Form["scanmethod"]));
                sqlOperation.AddParameterWithValue("@LocationRequirements_ID", Convert.ToInt32(context.Request.Form["special"]));
                sqlOperation.AddParameterWithValue("@Enhance", Convert.ToInt32(context.Request.Form["add"]));
                if (Convert.ToInt32(context.Request.Form["add"]) == 1)
                {
                    sqlOperation.AddParameterWithValue("@EnhanceMethod_ID", Convert.ToInt32(context.Request.Form["addmethod"]));
                }
                else
                {
                    sqlOperation.AddParameterWithValue("@EnhanceMethod_ID", null);
                }
                sqlOperation.AddParameterWithValue("@RemarksRecords", context.Request.Form["Remarks"]);
                sqlOperation.AddParameterWithValue("@UpperBound", context.Request.Form["up"]);
                sqlOperation.AddParameterWithValue("@LowerBound", context.Request.Form["down"]);
                sqlOperation.AddParameterWithValue("@Remarks", context.Request.Form["remark"]);
                sqlOperation.AddParameterWithValue("@number", context.Request.Form["Number"]);
                sqlOperation.AddParameterWithValue("@ReferenceNumber", context.Request.Form["ReferenceNumber"]);
                sqlOperation.AddParameterWithValue("@ReferenceScale", context.Request.Form["ReferenceScale"]);
                sqlOperation.AddParameterWithValue("@datetime", datetime);
                sqlOperation.AddParameterWithValue("@userid", userid);
                sqlOperation.AddParameterWithValue("@picture", savepath1);
                int intSuccess1 = sqlOperation.ExecuteNonQuery(strSqlCommand);
                string strSqlCommand1 = "UPDATE  appointment  SET Completed=@state where Treatment_ID=@treat and Task='模拟定位'";
                sqlOperation1.AddParameterWithValue("@state", 1);
                sqlOperation1.AddParameterWithValue("@treat", treatID);
                int intSuccess2 = sqlOperation1.ExecuteNonQuery(strSqlCommand1);
                int intSuccess = 0;

                string strSqlCommand2 = "INSERT INTO ct(ID) VALUES(@loc)";
                sqlOperation2.AddParameterWithValue("@loc", LocationID);
                intSuccess = sqlOperation2.ExecuteNonQuery(strSqlCommand2);
                string strSqlCommand4 = "UPDATE  location  SET CT_ID=@loc where location.ID=@locationID";
                sqlOperation2.AddParameterWithValue("@locationID", LocationID);
                int intSuccesss = sqlOperation2.ExecuteNonQuery(strSqlCommand4);
                string strSqlCommand3 = "UPDATE  treatment  SET Progress=@Progress where Treatment.ID=@tr";
                sqlOperation3.AddParameterWithValue("@Progress", progress + ",5");
                sqlOperation3.AddParameterWithValue("@tr", treatID);
                int intSuccess3 = sqlOperation3.ExecuteNonQuery(strSqlCommand3);
                if (intSuccess > 0 && intSuccess1 > 0 && intSuccess2 > 0 && intSuccess3 > 0)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
            }
            else
            {
                string strSqlCommand = "UPDATE  location  SET ScanPart_ID=@ScanPart_ID,ScanMethod_ID=@ScanMethod_ID,RemarksRecords=@RemarksRecords,EnhanceMethod_ID=@EnhanceMethod_ID,Enhance=@Enhance,Remarks=@Remarks,LowerBound=@LowerBound,UpperBound=@UpperBound,LocationRequirements_ID=@LocationRequirements_ID,Thickness=@thickness,Number=@number,ReferenceNumber=@ReferenceNumber,ReferenceScale=@ReferenceScale,OperateTime=@datetime,Operate_User_ID=@userid where location.ID=@locationID";
                //各参数赋予实际值
                sqlOperation.AddParameterWithValue("@locationID", LocationID);
                sqlOperation.AddParameterWithValue("@thickness", context.Request.Form["Thickness"]);
                sqlOperation.AddParameterWithValue("@ScanPart_ID", context.Request.Form["scanpart"]);
                sqlOperation.AddParameterWithValue("@ScanMethod_ID", Convert.ToInt32(context.Request.Form["scanmethod"]));
                sqlOperation.AddParameterWithValue("@LocationRequirements_ID", Convert.ToInt32(context.Request.Form["special"]));
                sqlOperation.AddParameterWithValue("@Enhance", Convert.ToInt32(context.Request.Form["add"]));
                if (Convert.ToInt32(context.Request.Form["add"]) == 1)
                {
                    sqlOperation.AddParameterWithValue("@EnhanceMethod_ID", Convert.ToInt32(context.Request.Form["addmethod"]));
                }
                else
                {
                    sqlOperation.AddParameterWithValue("@EnhanceMethod_ID", null);
                }
                sqlOperation.AddParameterWithValue("@RemarksRecords", context.Request.Form["Remarks"]);
                sqlOperation.AddParameterWithValue("@UpperBound", context.Request.Form["up"]);
                sqlOperation.AddParameterWithValue("@LowerBound", context.Request.Form["down"]);
                sqlOperation.AddParameterWithValue("@Remarks", context.Request.Form["remark"]);
                sqlOperation.AddParameterWithValue("@number", context.Request.Form["Number"]);
                sqlOperation.AddParameterWithValue("@ReferenceNumber", context.Request.Form["ReferenceNumber"]);
                sqlOperation.AddParameterWithValue("@ReferenceScale", context.Request.Form["ReferenceScale"]);
                sqlOperation.AddParameterWithValue("@datetime", datetime);
                sqlOperation.AddParameterWithValue("@userid", userid);
            
                int intSuccess1 = sqlOperation.ExecuteNonQuery(strSqlCommand);
                if (intSuccess1 > 0)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
            }
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }
    }

}