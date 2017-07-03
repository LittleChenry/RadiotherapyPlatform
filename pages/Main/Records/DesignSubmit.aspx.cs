using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_DesignSubmit : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {

        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
        //不是第一次加载页面进行录入
        if (myispostback != null && myispostback == "true")
        {
            if (RecordPatientInformation())
            {
                MessageBox.Message("保存成功!");

            }

            else
            {
                MessageBox.Message("保存失败");
            }
        }

    }

    private bool RecordPatientInformation()
    {

        string ctid = Request.Form["designID"];
        int CTID = Convert.ToInt32(ctid);
        //string userID = "1";
        string userID = Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;


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
        sqlOperation.AddParameterWithValue("@ctID", CTID);
        sqlOperation.AddParameterWithValue("@userid", userid);

        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);

        if (intSuccess > 0)
        {

            return true;
        }
        else
        {
            return false;
        }

    }
}