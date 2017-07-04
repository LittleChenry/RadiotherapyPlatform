using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_DesignReview : System.Web.UI.Page
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

        string treatid = Request.Form["hidetreatID"];
        int treatID = Convert.ToInt32(treatid);
        //string userID = "1";
        string userID = Request.Form["userID"];
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
        string x1 = Request.Form["ReferenceCenterX"];
        string y1 = Request.Form["ReferenceCenterY"];
        string z1 = Request.Form["ReferenceCenterZ"];
        string x2 = Request.Form["TreatmentCenterX"];
        string y2 = Request.Form["TreatmentCenterY"];
        string z2 = Request.Form["TreatmentCenterZ"];
        string x3 = Request.Form["MovementX"];
        string y3 = Request.Form["MovementY"];
        string z3 = Request.Form["MovementZ"];
        string ReferenceCenter = x1 + "," + y1 + "," + z1;
        string TreatmentCenter = x2 + "," + y2 + "," + z2;
        string Movement = x3 + "," + y3 + "," + z3;
        string strSqlCommand = "INSERT INTO review(ID,TechnologyConfirm,EquipmentConfirm,CoplanarConfirm,AngleConfirm,MachineNumbeConfirm,ControlPointConfirm,GridConfirm,FeasibilityConfirm,AlgorithmConfirm,Reoptimization,PlaceInformation,DRR,IsExport,ReferenceCenter,TreatmentCenter,Movement,_User_ID,ReviewTime,PlanSystemConfirm) " +
                                "VALUES(@ID,@confirmTechnology,@EquipmentConfirm,@CoplanarConfirm,@AngleConfirm,@MachineNumbeConfirm,@ControlPointConfirm,@GridConfirm,@FeasibilityConfirm,@AlgorithmConfirm,@Reoptimization,@PlaceInformation,@DRR,@IsExport,@ReferenceCenter,@TreatmentCenter,@Movement,@User_ID,@ReviewTime,@planSystemConfirm)";
        sqlOperation.AddParameterWithValue("@ID", Count);
        sqlOperation.AddParameterWithValue("@confirmTechnology", Convert.ToInt32(Request.Form["TechnologyConfirm1"]));
        sqlOperation.AddParameterWithValue("@EquipmentConfirm", Convert.ToInt32(Request.Form["EquipmentConfirm1"]));

        sqlOperation.AddParameterWithValue("@AngleConfirm", Convert.ToInt32(Request.Form["confirmAngle1"]));
        sqlOperation.AddParameterWithValue("@CoplanarConfirm", Convert.ToInt32(Request.Form["confirmCoplanar1"]));
        sqlOperation.AddParameterWithValue("@MachineNumbeConfirm", Convert.ToInt32(Request.Form["confirmMachineNumbe1"]));
        sqlOperation.AddParameterWithValue("@ControlPointConfirm", Convert.ToInt32(Request.Form["confirmControlPoint1"]));
        sqlOperation.AddParameterWithValue("@GridConfirm", Convert.ToInt32(Request.Form["confirmGrid1"]));
        sqlOperation.AddParameterWithValue("@AlgorithmConfirm", Convert.ToInt32(Request.Form["confirmAlgorithm1"]));
        sqlOperation.AddParameterWithValue("@Reoptimization", Convert.ToInt32(Request.Form["confirmReoptimization1"]));
        sqlOperation.AddParameterWithValue("@FeasibilityConfirm", Convert.ToInt32(Request.Form["confirmFeasibility1"]));
        sqlOperation.AddParameterWithValue("@PlaceInformation", Convert.ToInt32(Request.Form["confirmPlaceInformation1"]));
        sqlOperation.AddParameterWithValue("@IsExport", Convert.ToInt32(Request.Form["confirmIsExport1"]));
        sqlOperation.AddParameterWithValue("@DRR", Convert.ToInt32(Request.Form["confirmDRR1"]));
        sqlOperation.AddParameterWithValue("@planSystemConfirm", Convert.ToInt32(Request.Form["confirmPlanSystem1"]));
        sqlOperation.AddParameterWithValue("@ReferenceCenter", ReferenceCenter);
        sqlOperation.AddParameterWithValue("@TreatmentCenter", TreatmentCenter);
        sqlOperation.AddParameterWithValue("@ReviewTime", datetime1);
        sqlOperation.AddParameterWithValue("@Movement", Movement);
        sqlOperation.AddParameterWithValue("@User_ID", userid);
        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
       
        string inserttreat = "update treatment set Review_ID=@Design_ID,Progress=14 where ID=@treat";
        sqlOperation2.AddParameterWithValue("@Design_ID", Count);
        sqlOperation2.AddParameterWithValue("@treat", treatID);
        int Success = sqlOperation2.ExecuteNonQuery(inserttreat);
        if (intSuccess > 0 && Success > 0)
        {

            return true;
        }
        else
        {
            return false;
        }

    }
}