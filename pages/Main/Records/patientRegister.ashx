<%@ WebHandler Language="C#" Class="patientRegister" %>

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

            int doctorid = Convert.ToInt32(context.Request.Form["doctor"]);
            string strSqlCommand = "UPDATE patient SET IdentificationNumber=@IdentificationNumber,Nameping=@nameping,Hospital=@Hospital,Picture=@Picture,Name=@Name,Gender=@Gender,Age=@Age,Birthday=@Birthday,Nation=@Nation,Address=@Address,Contact1=@Contact1,Contact2=@Contact2,Height=@Height,Weight=@Weight,Ishospital=@Ishospital,Hospital_ID=@Hospital_ID,Radiotherapy_ID=@Radiotherapy_ID where ID=@patientID";
            //各参数赋予实际值
            sqlOperation.AddParameterWithValue("@IdentificationNumber", context.Request.Form["IDcardNumber"]);
            sqlOperation.AddParameterWithValue("@Hospital", context.Request.Form["Hospital"]);
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
            sqlOperation.AddParameterWithValue("@Radiotherapy_ID", context.Request.Form["radionumber"]);
            sqlOperation.AddParameterWithValue("@nameping", context.Request.Form["usernamepingyin"]);
            if (context.Request.Form["RecordNumber"] == "1")
            {
                sqlOperation.AddParameterWithValue("@Hospital_ID", context.Request.Form["hospitalnumber"]);
            }
            else
            {
                sqlOperation.AddParameterWithValue("@Hospital_ID", null);
            }
            sqlOperation.AddParameterWithValue("@Ishospital", context.Request.Form["RecordNumber"]);
            sqlOperation.AddParameterWithValue("@patientID", context.Request.Form["patientID"]);
            int Success = sqlOperation.ExecuteNonQuery(strSqlCommand);
            if (context.Request.Form["group"] != "allItem")
            {
                string command = "update treatment set Group_ID=@group where ID=@treat";
                sqlOperation.AddParameterWithValue("@group", Convert.ToInt32(context.Request.Form["group"]));
                sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(context.Request.Form["treatID"]));
                int success2 = sqlOperation.ExecuteNonQuery(command);
            }
            return "success";

      
    }
}