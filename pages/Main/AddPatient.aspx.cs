using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_AddPatient : System.Web.UI.Page
{
    //数据层操作类
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation3 = new DataLayer("sqlStr");
    private DataLayer sqlOperation4 = new DataLayer("sqlStr");
    private DataLayer sqlOperation5 = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {


        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
        //不是第一次加载页面进行录入
        if (myispostback != null && myispostback == "true")
        {
            if (RecordPatientInformation())
            {
                MessageBox.Message("登记成功,即将跳转到患者注册界面");
                Response.Write("<script language=javascript>window.location.replace('../Main/AddPatient.aspx');</script>");
            }
            else
            {
                MessageBox.Message("登记失败");
            }
        }

    }
    private bool RecordPatientInformation()
    {
        string savePath = "";
        string savepath1 = "";
        HttpFileCollection files = HttpContext.Current.Request.Files;
        savePath = Server.MapPath("~/upload/PatientPicture");
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
            Response.Write(Ex);
        }
        int doctorid = Convert.ToInt32(Request.Form["doctor"]);
        int userID = Convert.ToInt32(Request.Form["userID"]);
        string groupid = "SELECT Group_ID from user where ID=@doctor";
        sqlOperation5.AddParameterWithValue("@doctor", doctorid);
        int groupID = int.Parse(sqlOperation5.ExecuteScalar(groupid));
        DateTime datetime = DateTime.Now;
        DateTime date = DateTime.Now;
        string date1 = date.ToString("yyyy-MM-dd");
        string date2 = date.ToString("yyyyMMdd");
        string count = "select count(ID) from patient where RegisterTime LIKE @time ";
        sqlOperation1.AddParameterWithValue("@time", "%"+date1+"%");
        int Count = Convert.ToInt32(sqlOperation1.ExecuteScalar(count));
        string add = Count.ToString();
        if (Count < 10)
        {
            add = "0" + Count;
        }
        int treatID = 0;
        string treatid = date2 + add;
        treatID = Convert.ToInt32(treatid);
        string strSqlCommand = "INSERT INTO patient(IdentificationNumber,Hospital,RecordNumber,Picture,Name,Gender,Age,Birthday,Nation,Address,Contact1,Contact2,Height,RegisterDoctor,Weight,Register_User_ID,RegisterTime,SubCenterPrincipal_ID,Radiotherapy_ID,Principal_User_ID) VALUES("
         + "@IdentificationNumber,@Hospital,@RecordNumber,@Picture,@Name,@Gender,@Age,@Birthday,@Nation,@Address,@Contact1,@Contact2,@Height,@doctorid,@Weight,@Register_User_ID,@RegisterTime,@SubCenterPrincipal_ID,@Radiotherapy_ID,@Principal_User_ID)";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@IdentificationNumber", Request.Form["IDcardNumber"]);
        sqlOperation.AddParameterWithValue("@Hospital", Request.Form["Hospital"]);
        sqlOperation.AddParameterWithValue("@RecordNumber", Request.Form["RecordNumber"]);
        sqlOperation.AddParameterWithValue("@Picture", savepath1);
        sqlOperation.AddParameterWithValue("@Name", Request.Form["userName"]);
        sqlOperation.AddParameterWithValue("@Gender", Request.Form["Gender"]);
        sqlOperation.AddParameterWithValue("@Birthday", Request.Form["Birthday"]);
        sqlOperation.AddParameterWithValue("@Age", Convert.ToInt32(DateTime.Now.Year.ToString()) - Convert.ToInt32(Request.Form["Birthday"].Substring(0, 4)));
        sqlOperation.AddParameterWithValue("@Nation", Request.Form["Nation"]);
        sqlOperation.AddParameterWithValue("@Address", Request.Form["Address"]);
        sqlOperation.AddParameterWithValue("@Contact1", Request.Form["Number1"]);
        sqlOperation.AddParameterWithValue("@Contact2", Request.Form["Number2"]);
        sqlOperation.AddParameterWithValue("@Height", Request.Form["height"]);
        sqlOperation.AddParameterWithValue("@Weight", Request.Form["weight"]);
        sqlOperation.AddParameterWithValue("@Radiotherapy_ID", treatID);
        sqlOperation.AddParameterWithValue("@doctorid", doctorid);
        sqlOperation.AddParameterWithValue("@SubCenterPrincipal_ID", Request.Form["Sub"]);
        sqlOperation.AddParameterWithValue("@Principal_User_ID", 1);
        sqlOperation.AddParameterWithValue("@Register_User_ID", userID);
        sqlOperation.AddParameterWithValue("@RegisterTime", datetime);       
        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);   
        string patientID = "select ID  from patient where Name=@Name and IdentificationNumber=@IdentificationNumber order by ID desc";
        sqlOperation1.AddParameterWithValue("@IdentificationNumber", Request.Form["IDcardNumber"]);
        sqlOperation1.AddParameterWithValue("@Name", Request.Form["userName"]);
        int patient = Convert.ToInt32(sqlOperation1.ExecuteScalar(patientID));
        int intSuccess2 = 0;
        int intSuccess3 = 0;
            
        if (intSuccess > 0 && treatID > 0)
        {
            string treatinsert = "insert into treatment(TreatmentName,Patient_ID,Group_ID,Progress,State) values(@ID,@PID,Group_ID,0,1)";
            sqlOperation2.AddParameterWithValue("@ID", 1);
            sqlOperation2.AddParameterWithValue("@PID", patient);
            sqlOperation5.AddParameterWithValue("@Group_ID", groupID);
            intSuccess2 = sqlOperation2.ExecuteNonQuery(treatinsert);

        }
       
        if (intSuccess2 > 0)
        {
            return true;
        }
        else
        {
            return false;
        }


    }
}