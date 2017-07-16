<%@ WebHandler Language="C#" Class="Addpatient" %>

using System;
using System.Web;
 using System.Text;

public class Addpatient : IHttpHandler {
     //数据层操作类
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation3 = new DataLayer("sqlStr");
    private DataLayer sqlOperation4 = new DataLayer("sqlStr");
    private DataLayer sqlOperation5 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = RecordPatientInformation(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
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
        HttpFileCollection files = context.Request.Files;
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
                savepath1 = "";
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
            int userID = Convert.ToInt32(context.Request.Form["userID"]);
            DateTime datetime = DateTime.Now;
            DateTime date = DateTime.Now;
            string date1 = date.ToString("yyyy-MM-dd");
            string date2 = date.ToString("yyyyMMdd");
            string count = "select count(ID) from patient where RegisterTime LIKE @time ";
            sqlOperation1.AddParameterWithValue("@time", "%" + date1 + "%");
            int Count = Convert.ToInt32(sqlOperation1.ExecuteScalar(count));
            string add = Count.ToString();
            if (Count < 10)
            {
                add = "0" + Count;
            }
            int treatID = 0;
            string treatid = date2 + add;
            treatID = Convert.ToInt32(treatid);
            string strSqlCommand = "INSERT INTO patient(IdentificationNumber,Hospital,RecordNumber,Picture,Name,Gender,Age,Birthday,Nation,Address,Contact1,Contact2,Height,RegisterDoctor,Weight,Register_User_ID,RegisterTime,SubCenterPrincipal_ID,Radiotherapy_ID,Principal_User_ID,Hospital_ID) VALUES("
             + "@IdentificationNumber,@Hospital,@RecordNumber,@Picture,@Name,@Gender,@Age,@Birthday,@Nation,@Address,@Contact1,@Contact2,@Height,@doctorid,@Weight,@Register_User_ID,@RegisterTime,@SubCenterPrincipal_ID,@Radiotherapy_ID,@Principal_User_ID,@hospitalnumber)";
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
            sqlOperation.AddParameterWithValue("@Address", context.Request.Form["provSelect_text"] + context.Request.Form["citySelect_text"] + context.Request.Form["areaSelect_text"] + context.Request.Form["addressmore"]);
            sqlOperation.AddParameterWithValue("@Contact1", context.Request.Form["Number1"]);
            sqlOperation.AddParameterWithValue("@Contact2", context.Request.Form["Number2"]);
            sqlOperation.AddParameterWithValue("@Height", context.Request.Form["height"]);
            sqlOperation.AddParameterWithValue("@Weight", context.Request.Form["weight"]);
            sqlOperation.AddParameterWithValue("@Radiotherapy_ID", treatID);
            sqlOperation.AddParameterWithValue("@doctorid", doctorid);
            sqlOperation.AddParameterWithValue("@SubCenterPrincipal_ID", context.Request.Form["Sub"]);
            sqlOperation.AddParameterWithValue("@Principal_User_ID", 1);
            sqlOperation.AddParameterWithValue("@Register_User_ID", userID);
            sqlOperation.AddParameterWithValue("@RegisterTime", datetime);
            sqlOperation.AddParameterWithValue("@hospitalnumber", Convert.ToInt32(context.Request.Form["hospitalnumber"]));
            int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            string patientID = "select ID  from patient where Name=@Name and IdentificationNumber=@IdentificationNumber order by ID desc";
            sqlOperation1.AddParameterWithValue("@IdentificationNumber", context.Request.Form["IDcardNumber"]);
            sqlOperation1.AddParameterWithValue("@Name", context.Request.Form["userName"]);
            int patient = Convert.ToInt32(sqlOperation1.ExecuteScalar(patientID));
            int intSuccess2 = 0;
            if (intSuccess > 0 && treatID > 0)
            {
                if (context.Request.Form["group"] == "allItem")
                {
                    string treatinsert = "insert into treatment(TreatmentName,Patient_ID,Progress,State) values(@ID,@PID,@progress,1)";
                    sqlOperation2.AddParameterWithValue("@progress", "0");
                    sqlOperation2.AddParameterWithValue("@ID", 1);
                    sqlOperation2.AddParameterWithValue("@PID", patient);
                    intSuccess2 = sqlOperation2.ExecuteNonQuery(treatinsert);
                }
                else
                {
                    string treatinsert = "insert into treatment(TreatmentName,Patient_ID,Progress,State,Group_ID,Belongingdoctor) values(@ID,@PID,@progress,0,@group,@doc)";
                    sqlOperation2.AddParameterWithValue("@progress", "0");
                    sqlOperation2.AddParameterWithValue("@group", Convert.ToInt32(context.Request.Form["group"]));
                    sqlOperation2.AddParameterWithValue("@ID", 1);
                    sqlOperation2.AddParameterWithValue("@PID", patient);
                    sqlOperation2.AddParameterWithValue("@doc", doctorid);
                    intSuccess2 = sqlOperation2.ExecuteNonQuery(treatinsert);
                    
                }
                
            }
            if (intSuccess2 > 0)
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