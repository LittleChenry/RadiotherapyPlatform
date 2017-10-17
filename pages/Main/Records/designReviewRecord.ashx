﻿<%@ WebHandler Language="C#" Class="designReviewRecord" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class designReviewRecord : IHttpHandler {
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
        string savePath2 = "";
        string savepath3 = "";
        HttpFileCollection files = context.Request.Files;
        savePath = System.Web.HttpContext.Current.Server.MapPath("~/upload/DesignPDF");
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
                savepath1 = "../../../upload/DesignPDF/" + DateTime.Now.ToString("yyyyMMdd") + fileName;
            }       
        }
        catch (System.Exception Ex)
        {
            context.Response.Write(Ex);
        }
        savePath2 = System.Web.HttpContext.Current.Server.MapPath("~/upload/PDF");
        if (!System.IO.Directory.Exists(savePath2))
        {
            System.IO.Directory.CreateDirectory(savePath2);
        }
        savePath2 = savePath2 + "\\";
        try
        {

            System.Web.HttpPostedFile postedFile1 = files[1];
            string fileName = postedFile1.FileName;//完整的路径
            if (fileName == "")
            {
                savepath3 = "";
            }
            else
            {
                fileName = System.IO.Path.GetFileName(postedFile1.FileName); //获取到名称
                string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
                string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
                files[1].SaveAs(savePath2 + DateTime.Now.ToString("yyyyMMdd") + fileName);
                savepath3 = "../../../upload/PDF/" + DateTime.Now.ToString("yyyyMMdd") + fileName;
            }
        }
        catch (System.Exception Ex)
        {
            context.Response.Write(Ex);
        }

             string treatid = context.Request.Form["hidetreatID"];
            int treatID = Convert.ToInt32(treatid);
            //string userID = "1";
            string userID = context.Request.Form["userID"];
            int userid = Convert.ToInt32(userID);
            DateTime datetime = DateTime.Now;
            DateTime datetime1 = datetime;
            string maxnumber = "select max(ID) from review";

            string count = sqlOperation1.ExecuteScalar(maxnumber);

            int Count;
            if (count == "")
            {
                Count = 1;
            }
            else
            {
                Count = Convert.ToInt32(count) + 1;
            }
            string strSqlCommand = "INSERT INTO review(ID,PlanQA,_User_ID,ReviewTime,Remark,PDF1,PDF2,SUM,Percent) " +
                                    "VALUES(@ID,@PlanQA,@User_ID,@ReviewTime,@Remark,@PDF1,@PDF2,@SUM,@Percent)";
            sqlOperation.AddParameterWithValue("@ID", Count);
            sqlOperation.AddParameterWithValue("@PlanQA", Convert.ToInt32(context.Request.Form["PlanQA"]));
            sqlOperation.AddParameterWithValue("@Remark", context.Request.Form["Remark"]);
            sqlOperation.AddParameterWithValue("@SUM", 1);
            sqlOperation.AddParameterWithValue("@Percent",context.Request.Form["degree"]);
            sqlOperation.AddParameterWithValue("@ReviewTime", datetime1);
            sqlOperation.AddParameterWithValue("@User_ID", userid);
            sqlOperation.AddParameterWithValue("@PDF1", savepath1);
            sqlOperation.AddParameterWithValue("@PDF2", savepath3);
            int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            string select1 = "select Progress from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatID);
            string progress = sqlOperation.ExecuteScalar(select1);
            string[] group = progress.Split(',');
            bool exists = ((IList)group).Contains("12");
            int Success = 0;
            if (!exists)
            {
                string inserttreat = "update treatment set Review_ID=@Design_ID,Progress=@progress where ID=@treat";
                sqlOperation2.AddParameterWithValue("@progress", progress + ",12");
                sqlOperation2.AddParameterWithValue("@Design_ID", Count);
                sqlOperation2.AddParameterWithValue("@treat", treatID);
                Success = sqlOperation2.ExecuteNonQuery(inserttreat);
            }
            else
            {
                string inserttreat = "update treatment set Review_ID=@Design_ID where ID=@treat";
                sqlOperation2.AddParameterWithValue("@Design_ID", Count);
                sqlOperation2.AddParameterWithValue("@treat", treatID);
                Success = sqlOperation2.ExecuteNonQuery(inserttreat);
            }
            if (intSuccess > 0 && Success > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }




    }
}