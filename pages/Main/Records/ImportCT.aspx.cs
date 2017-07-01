using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_ImportCT : System.Web.UI.Page
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

        string treatid = Request.Form["treatmentID"];
        int treat = Convert.ToInt32(treatid);
        string userID = Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;

        string strSqlCommand1 = "select ct.ID  from ct,treatment,location where treatment.ID=@treat and treatment.Location_ID=location.ID and location.CT_ID=ct.ID";
        sqlOperation.AddParameterWithValue("@treat", treat);
        string CTID = sqlOperation.ExecuteScalar(strSqlCommand1);
        string strSqlCommand = "UPDATE  ct  SET DensityConversion_ID=@densityconversion,SequenceNaming=@sequencenaming,Thickness=@Thickness,Number=@Number,ReferenceScale=@ReferenceScale,MultimodalImage=@MultimodalImage,Remarks=@Remarks,OperateTime=@datetime,Operate_User_ID=@userid where ct.ID=@ctID";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@ctID", CTID);
        sqlOperation.AddParameterWithValue("@densityconversion", Convert.ToInt32(Request.Form["DensityConversion"]));
        sqlOperation.AddParameterWithValue("@sequencenaming", Request.Form["SequenceNaming"]);
        sqlOperation.AddParameterWithValue("@Remarks", Request.Form["Remarks"]);
        sqlOperation.AddParameterWithValue("@datetime", datetime);
        sqlOperation.AddParameterWithValue("@userid", userid);
        sqlOperation.AddParameterWithValue("@Thickness", Request.Form["Thickness"]);
        sqlOperation.AddParameterWithValue("Number", Request.Form["Number"]);
        sqlOperation.AddParameterWithValue("ReferenceScale", Request.Form["ReferenceScale"]);
        sqlOperation.AddParameterWithValue("MultimodalImage", Request.Form["MultimodalImage"]);
        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
        string strSqlCommand2 = "UPDATE  treatment  SET Progress=7 where treatment.ID=@treat";
        int intSuccess2 = sqlOperation.ExecuteNonQuery(strSqlCommand2);
        if (intSuccess > 0 & intSuccess2>0)
        {

            return true;
        }
        else
        {
            return false;
        }

    }
}