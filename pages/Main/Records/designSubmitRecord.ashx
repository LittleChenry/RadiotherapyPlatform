<%@ WebHandler Language="C#" Class="designSubmitRecord" %>

using System;
using System.Web;
using System.Text;
public class designSubmitRecord : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
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
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
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
        try{
            string ctid = context.Request.Form["hidetreatID"];
            int CTID = Convert.ToInt32(ctid);
            //string userID = "1";
            string userID = context.Request.Form["userID"];
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
                return "message";
            }
            string strSqlCommand = "UPDATE  design  SET PlanSystem_ID=@PlanSystem_ID,IlluminatedNumber=@IlluminatedNumber,Coplanar=@Coplanar,MachineNumbe=@MachineNumbe,ControlPoint=@ControlPoint,Grid_ID=@Grid_ID,Algorithm_ID=@Algorithm_ID,Feasibility=@Feasibility,SubmitTime=@datetime,Submit_User_ID=@userid where design.ID=@ctID";
            //各参数赋予实际值
            sqlOperation.AddParameterWithValue("@PlanSystem_ID", Convert.ToInt32(context.Request.Form["PlanSystem"]));
            sqlOperation.AddParameterWithValue("@IlluminatedNumber", context.Request.Form["IlluminatedNumber"]);
            sqlOperation.AddParameterWithValue("@Coplanar", Convert.ToInt32(context.Request.Form["Coplanar"]));
            //sqlOperation.AddParameterWithValue("@Remarks", context.Request.Form["Remarks"]);
            sqlOperation.AddParameterWithValue("@MachineNumbe", context.Request.Form["MachineNumbe"]);
            sqlOperation.AddParameterWithValue("@ControlPoint", context.Request.Form["ControlPoint"]);
            sqlOperation.AddParameterWithValue("@Grid_ID", Convert.ToInt32(context.Request.Form["Grid"]));
            sqlOperation.AddParameterWithValue("@Algorithm_ID", Convert.ToInt32(context.Request.Form["Algorithm"]));
            sqlOperation.AddParameterWithValue("@Feasibility", Convert.ToInt32(context.Request.Form["Feasibility"]));
            sqlOperation.AddParameterWithValue("@datetime", datetime);
            sqlOperation.AddParameterWithValue("@ctID", designID);
            sqlOperation.AddParameterWithValue("@userid", userid);

            int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            string inserttreat = "update treatment set Progress=10 where ID=@treat";
            sqlOperation2.AddParameterWithValue("@treat", CTID);
            int Success = sqlOperation2.ExecuteNonQuery(inserttreat);


            if (intSuccess > 0 && Success>0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }


    }
}