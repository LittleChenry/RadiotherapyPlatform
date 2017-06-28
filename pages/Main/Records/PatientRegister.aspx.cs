using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_PatientRegister : System.Web.UI.Page
{
    //数据层操作类
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    
    private DataLayer sqlOperation3 = new DataLayer("sqlStr");
   
    private DataLayer sqlOperation5 = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {


        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
        //不是第一次加载页面进行录入
        if (myispostback != null && myispostback == "true")
        {
            if (RecordPatientInformation())
            {
                sqlOperation.Close();
                sqlOperation.Dispose();
                sqlOperation1.Close();
                sqlOperation1.Dispose();
                sqlOperation3.Close();
                sqlOperation3.Dispose();
                sqlOperation5.Close();
                sqlOperation5.Dispose();
                MessageBox.Message("更新成功");
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
        if (FileUpload.HasFile)
        {
            savePath = Server.MapPath("~/upload/Patient");//指定上传文件在服务器上的保存路径
            //检查服务器上是否存在这个物理路径，如果不存在则创建
            if (!System.IO.Directory.Exists(savePath))
            {
                System.IO.Directory.CreateDirectory(savePath);
            }
            savePath = savePath + "\\" + DateTime.Now.ToString("yyyyMMdd") + FileUpload.FileName;
            savepath1 = "../../upload/Patient/" + DateTime.Now.ToString("yyyyMMdd") + FileUpload.FileName;
            FileUpload.SaveAs(savePath);
        }
        
        int doctorid = Convert.ToInt32(Request.Form["docter"]);
        string strSqlCommand = "UPDATE patient SET IdentificationNumber=@IdentificationNumber,Hospital=@Hospital,RecordNumber=@RecordNumber,Picture=@Picture,Name=@Name,Gender=@Gender,Age=@Age,Birthday=@Birthday,Nation=@Nation,Address=@Address,Contact1=@Contact1,Contact2=@Contact2,Height=@Height,Weight=@Weight,SickPart=@SickPart,RegisterDoctor=@doctorid where ID=@patientID";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@IdentificationNumber", Request.Form["IDcardNumber"]);
        sqlOperation.AddParameterWithValue("@Hospital", Request.Form["Hospital"]);
        sqlOperation.AddParameterWithValue("@RecordNumber", Request.Form["RecordNumber"]);
        sqlOperation.AddParameterWithValue("@Picture", savepath1);
        sqlOperation.AddParameterWithValue("@Name", Request.Form["userName"]);
        sqlOperation.AddParameterWithValue("@Gender", sex(Request.Form["Gender"]));
        sqlOperation.AddParameterWithValue("@Birthday", Request.Form["Birthday"]);
        sqlOperation.AddParameterWithValue("@Age", Convert.ToInt32(DateTime.Now.Year.ToString()) - Convert.ToInt32(Request.Form["Birthday"].Substring(0, 4)));
        sqlOperation.AddParameterWithValue("@Nation", Request.Form["Nation"]);
        sqlOperation.AddParameterWithValue("@Address", Request.Form["Address"]);
        sqlOperation.AddParameterWithValue("@Contact1", Request.Form["Number1"]);
        sqlOperation.AddParameterWithValue("@Contact2", Request.Form["Number2"]);
        sqlOperation.AddParameterWithValue("@Height", Request.Form["height"]);
        sqlOperation.AddParameterWithValue("@Weight", Request.Form["weight"]);
        sqlOperation.AddParameterWithValue("@patientID", Request.Form["patientID"]);
        sqlOperation.AddParameterWithValue("@doctorid", doctorid);
        sqlOperation.AddParameterWithValue("@SickPart", Convert.ToInt32(Request.Form["SickPart"]));
        int Success = sqlOperation.ExecuteNonQuery(strSqlCommand);

        string groupid="SELECT Group_ID from user where ID=@doctor";
        sqlOperation5.AddParameterWithValue("@doctor", doctorid);
        int groupID = int.Parse(sqlOperation5.ExecuteScalar(groupid));
        int treatid=Convert.ToInt32(Request.Form["treatID"]);
        int subid = Convert.ToInt32(Request.Form["Sub"]);
       
        string str1 = "UPDATE  diagnosisrecord SET SubCenterPrincipal_ID=@SubCenterPrincipal, Principal_User_ID=@Principal_User_ID where Treatment_ID=@treatID";

            sqlOperation3.AddParameterWithValue("@SubCenterPrincipal", subid);
            sqlOperation3.AddParameterWithValue("@Principal_User_ID", 1);
            sqlOperation3.AddParameterWithValue("@treatID", treatid);
            int Success1 = sqlOperation3.ExecuteNonQuery(str1);
           
                string treatupdate = " update treatment set Group_ID=@Group_ID where ID=@Treatment_ID";

                sqlOperation1.AddParameterWithValue("@Group_ID", groupID);
                sqlOperation1.AddParameterWithValue("@Treatment_ID", treatid);
                int Success3 = sqlOperation1.ExecuteNonQuery(treatupdate);

            
        
        if (Success3 > 0 && Success>0 && Success3>0)
        {
            return true;
        }
        else
        {
            return false;
        }


    }
    string sex(string gen)
    {
        if (gen == "男")
            return "M";
        else
            return "F";


    }

}