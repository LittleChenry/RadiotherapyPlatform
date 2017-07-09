﻿<%@ WebHandler Language="C#" Class="patientRegister" %>

using System;
using System.Web;
using System.Text;
public class patientRegister : IHttpHandler
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");

    private DataLayer sqlOperation3 = new DataLayer("sqlStr");

    private DataLayer sqlOperation5 = new DataLayer("sqlStr");
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
            sqlOperation3.Close();
            sqlOperation3.Dispose();
            sqlOperation3 = null;
            sqlOperation5.Close();
            sqlOperation5.Dispose();
            sqlOperation5 = null;
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
        savePath = System.Web.HttpContext.Current.Server.MapPath("~/upload/PatientPicture");
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
                savepath1 = context.Request.Form["picture1"];
            }
            else
            {
                fileName = System.IO.Path.GetFileName(postedFile.FileName); //获取到名称
                string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
                string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
                files[0].SaveAs(savePath + DateTime.Now.ToString("yyyyMMdd") + fileName);
                savepath1 = "../../../upload/PatientPicture/" + DateTime.Now.ToString("yyyyMMdd") + fileName;
            }
        }
        catch (System.Exception Ex)
        {
            context.Response.Write(Ex);
        }
        try
        {
            int doctorid = Convert.ToInt32(context.Request.Form["doctor"]);
            string strSqlCommand = "UPDATE patient SET IdentificationNumber=@IdentificationNumber,Hospital=@Hospital,RecordNumber=@RecordNumber,Picture=@Picture,Name=@Name,Gender=@Gender,Age=@Age,Birthday=@Birthday,Nation=@Nation,Address=@Address,Contact1=@Contact1,Contact2=@Contact2,Height=@Height,Weight=@Weight,SickPart=@SickPart,RegisterDoctor=@doctorid where ID=@patientID";
            //各参数赋予实际值
            sqlOperation.AddParameterWithValue("@IdentificationNumber", context.Request.Form["IDcardNumber"]);
            sqlOperation.AddParameterWithValue("@Hospital", context.Request.Form["Hospital"]);
            sqlOperation.AddParameterWithValue("@RecordNumber", context.Request.Form["RecordNumber"]);
            sqlOperation.AddParameterWithValue("@Picture", savepath1);
            sqlOperation.AddParameterWithValue("@Name", context.Request.Form["userName"]);
            sqlOperation.AddParameterWithValue("@Gender", context.Request.Form["Gender"]);
            sqlOperation.AddParameterWithValue("@Birthday", context.Request.Form["Birthday"]);
            sqlOperation.AddParameterWithValue("@Age", Convert.ToInt32(DateTime.Now.Year.ToString()) - Convert.ToInt32(context.Request.Form["Birthday"].Substring(0, 4)));
            sqlOperation.AddParameterWithValue("@Nation", context.Request.Form["Nation"]);
            sqlOperation.AddParameterWithValue("@Address", context.Request.Form["Address"]);
            sqlOperation.AddParameterWithValue("@Contact1", context.Request.Form["Number1"]);
            sqlOperation.AddParameterWithValue("@Contact2", context.Request.Form["Number2"]);
            sqlOperation.AddParameterWithValue("@Height", context.Request.Form["height"]);
            sqlOperation.AddParameterWithValue("@Weight", context.Request.Form["weight"]);
            sqlOperation.AddParameterWithValue("@patientID", context.Request.Form["patientID"]);
            sqlOperation.AddParameterWithValue("@doctorid", doctorid);
            sqlOperation.AddParameterWithValue("@SickPart", Convert.ToInt32(context.Request.Form["SickPart"]));
            int Success = sqlOperation.ExecuteNonQuery(strSqlCommand);

            string groupid = "SELECT Group_ID from user where ID=@doctor";
            sqlOperation5.AddParameterWithValue("@doctor", doctorid);
            int groupID = int.Parse(sqlOperation5.ExecuteScalar(groupid));
            int treatid = Convert.ToInt32(context.Request.Form["treatID"]);
            int subid = Convert.ToInt32(context.Request.Form["Sub"]);

            string str1 = "UPDATE  diagnosisrecord SET SubCenterPrincipal_ID=@SubCenterPrincipal,Part_ID=@SickPart, Principal_User_ID=@Principal_User_ID where Treatment_ID=@treatID";
            sqlOperation3.AddParameterWithValue("@SickPart", Convert.ToInt32(context.Request.Form["SickPart"]));
            sqlOperation3.AddParameterWithValue("@SubCenterPrincipal", subid);
            sqlOperation3.AddParameterWithValue("@Principal_User_ID", 1);
            sqlOperation3.AddParameterWithValue("@treatID", treatid);
            int Success1 = sqlOperation3.ExecuteNonQuery(str1);

            string treatupdate = " update treatment set Group_ID=@Group_ID where ID=@Treatment_ID";

            sqlOperation1.AddParameterWithValue("@Group_ID", groupID);
            sqlOperation1.AddParameterWithValue("@Treatment_ID", treatid);
            int Success3 = sqlOperation1.ExecuteNonQuery(treatupdate);



            if (Success3 > 0 && Success > 0 && Success3 > 0)
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