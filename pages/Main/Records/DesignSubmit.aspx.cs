using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_DesignSubmit : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
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
                sqlOperation = null;
                sqlOperation1.Close();
                sqlOperation1.Dispose();
                sqlOperation1 = null;
                sqlOperation2.Close();
                sqlOperation2.Dispose();
                sqlOperation2 = null;
                MessageBox.Message("保存成功!");

            }

            else
            {
                sqlOperation.Close();
                sqlOperation.Dispose();
                sqlOperation = null;
                sqlOperation1.Close();
                sqlOperation1.Dispose();
                sqlOperation1 = null;
                MessageBox.Message("无法保存，请查看您是否是领取人");
            }
        }

    }

    private bool RecordPatientInformation()
    {

        string ctid = Request.Form["hidetreatID"];
        int CTID = Convert.ToInt32(ctid);
        //string userID = "1";
        string userID = Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;
        string design = "select Design_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", CTID);
        int designID = Convert.ToInt32(sqlOperation.ExecuteScalar(design));
        string receive = "select Receive_User_ID from design where design.ID=@designID";
        sqlOperation1.AddParameterWithValue("@designID", designID);
        int receiver = Convert.ToInt32(sqlOperation1.ExecuteScalar(receive));
        if (receiver != userid)
        {
            return false;
        }
        string strSqlCommand = "UPDATE  design  SET PlanSystem_ID=@PlanSystem_ID,IlluminatedNumber=@IlluminatedNumber,Coplanar=@Coplanar,MachineNumbe=@MachineNumbe,ControlPoint=@ControlPoint,Grid_ID=@Grid_ID,Algorithm_ID=@Algorithm_ID,Feasibility=@Feasibility,SubmitTime=@datetime,Submit_User_ID=@userid where design.ID=@ctID";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@PlanSystem_ID", Convert.ToInt32(Request.Form["PlanSystem"]));
        sqlOperation.AddParameterWithValue("@IlluminatedNumber", Request.Form["IlluminatedNumber"]);
        sqlOperation.AddParameterWithValue("@Coplanar", Convert.ToInt32(Request.Form["Coplanar"]));
        //sqlOperation.AddParameterWithValue("@Remarks", Request.Form["Remarks"]);
        sqlOperation.AddParameterWithValue("@MachineNumbe", Request.Form["MachineNumbe"]);
        sqlOperation.AddParameterWithValue("@ControlPoint", Request.Form["ControlPoint"]);
        sqlOperation.AddParameterWithValue("@Grid_ID", Convert.ToInt32(Request.Form["Grid"]));
        sqlOperation.AddParameterWithValue("@Algorithm_ID", Convert.ToInt32(Request.Form["Algorithm"]));
        sqlOperation.AddParameterWithValue("@Feasibility", Convert.ToInt32(Request.Form["Feasibility"]));
        sqlOperation.AddParameterWithValue("@datetime", datetime);
        sqlOperation.AddParameterWithValue("@ctID", designID);
        sqlOperation.AddParameterWithValue("@userid", userid);

        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
        string inserttreat = "update treatment set Progress=10 where ID=@treat";
        sqlOperation2.AddParameterWithValue("@treat", CTID);
        int Success = sqlOperation2.ExecuteNonQuery(inserttreat);


        if (intSuccess > 0 && Success>0)
        {

            return true;
        }
        else
        {
            return false;
        }

    }
}