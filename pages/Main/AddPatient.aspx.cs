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
        string strSqlCommand = "INSERT INTO patient(IdentificationNumber,Hospital,RecordNumber,Picture,Name,Gender,Age,Birthday,Nation,Address,Contact1,Contact2,Height,RegisterDoctor,Weight,Register_User_ID,RegisterTime,SickPart) VALUES("
         + "@IdentificationNumber,@Hospital,@RecordNumber,@Picture,@Name,@Gender,@Age,@Birthday,@Nation,@Address,@Contact1,@Contact2,@Height,@doctorid,@Weight,@Register_User_ID,@RegisterTime,@SickPart)";
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
        sqlOperation.AddParameterWithValue("@doctorid", doctorid);
        sqlOperation.AddParameterWithValue("@Register_User_ID", userID);
        sqlOperation.AddParameterWithValue("@RegisterTime", datetime);
        sqlOperation.AddParameterWithValue("@SickPart", Convert.ToInt32(Request.Form["SickPart"]));
        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);

        string patientID = "select ID  from patient where Name=@Name and IdentificationNumber=@IdentificationNumber order by ID desc";
        sqlOperation1.AddParameterWithValue("@IdentificationNumber", Request.Form["IDcardNumber"]);
        sqlOperation1.AddParameterWithValue("@Name", Request.Form["userName"]);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation1.ExecuteReader(patientID);
        int intSuccess2 = 0;
        int intSuccess3 = 0;
        int max = 0;
        int treatID = 0;
        if (reader.Read())
        {
            string treatid = DateTime.Now.Year.ToString() + Request.Form["SickPart"] + reader["ID"].ToString();
            max = Convert.ToInt32(reader["ID"].ToString());
            treatID = Convert.ToInt32(treatid);

        }
        if (intSuccess > 0 && max > 0 && treatID > 0)
        {
            string treatinsert = "insert into treatment(ID,Patient_ID) values(@ID,@PID)";
            sqlOperation2.AddParameterWithValue("@ID", treatID);
            sqlOperation2.AddParameterWithValue("@PID", max);
            intSuccess2 = sqlOperation2.ExecuteNonQuery(treatinsert);

        }
        if (intSuccess2 > 0)
        {

            //将信息写入数据库，并返回是否成功
            string str1 = "INSERT INTO diagnosisrecord(SubCenterPrincipal_ID,Principal_User_ID,Part_ID,Treatment_ID) " +
                                    "VALUES(@SubCenterPrincipal_ID,@Principal_User_ID,@SickPart,@Treatment_ID)";
            sqlOperation3.AddParameterWithValue("@SickPart", Convert.ToInt32(Request.Form["SickPart"]));
            sqlOperation3.AddParameterWithValue("@SubCenterPrincipal_ID", Convert.ToInt32(Request.Form["Sub"]));
            sqlOperation3.AddParameterWithValue("@Principal_User_ID", 1);
            sqlOperation3.AddParameterWithValue("@Treatment_ID", treatID);
            int suc = sqlOperation3.ExecuteNonQuery(str1);
            string diagID = "select ID  from diagnosisrecord where Treatment_ID=@Treatment_ID order by ID desc";
            sqlOperation4.AddParameterWithValue("@Treatment_ID", treatID);
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation4.ExecuteReader(diagID);

            if (reader1.Read())
            {
                string treatupdate = " update treatment set DiagnosisRecord_ID=@DiagnosisRecord_ID,Group_ID=@Group_ID,Progress=1 where ID=@Treatment_ID";
                sqlOperation5.AddParameterWithValue("@DiagnosisRecord_ID", Convert.ToInt32(reader1["ID"].ToString()));
                sqlOperation5.AddParameterWithValue("@Group_ID", groupID);
                sqlOperation5.AddParameterWithValue("@Treatment_ID", treatID);
                intSuccess3 = sqlOperation5.ExecuteNonQuery(treatupdate);

            }
        }
        if (intSuccess3 > 0)
        {
            return true;
        }
        else
        {
            return false;
        }


    }
}