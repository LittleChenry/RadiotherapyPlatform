<%@ WebHandler Language="C#" Class="designSubmitRecord" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
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
            string aa = context.Request.Form["a1"];
            string bb = context.Request.Form["a2"];
            string DosagePriority = "";
            int a1 = Convert.ToInt32(aa);
            int i = 0;
            while (i <= a1)
            {
                string ii = Convert.ToString(i);
                string Prioritytype = context.Request.Form["Prioritytype" + ii];
                string Priorityout = context.Request.Form["Priorityout" + ii];
                string Prioritptv = context.Request.Form["Prioritptv" + ii];
                string Prioritcgy = context.Request.Form["Prioritcgy" + ii];
                string Priorittime = context.Request.Form["Priorittime" + ii];
                string Prioritsum = context.Request.Form["Prioritsum" + ii];
                string Prioritremark = context.Request.Form["Prioritremark" + ii];
                string Priorit = context.Request.Form["Priorit" + ii];
                DosagePriority = DosagePriority + Prioritytype + "," + Priorityout + "," + Prioritptv + "," + Prioritcgy + "," + Priorittime + "," + Prioritsum + "," + Prioritremark + "," + Priorit + ";";
                i++;
            }
            int b1 = Convert.ToInt32(bb);
            int j = 0;
            DosagePriority = DosagePriority + "&";
            while (j <= b1)
            {
                string jj = Convert.ToString(j);
                string type = context.Request.Form["type" + jj];
                string dv = context.Request.Form["dv" + jj];
                string number = context.Request.Form["number" + jj];
                string outt = context.Request.Form["out" + jj];
                string prv = context.Request.Form["prv" + jj];
                string num = context.Request.Form["num" + jj];
                string numbers = context.Request.Form["numbers" + jj];
                string pp = context.Request.Form["pp" + jj];
                DosagePriority = DosagePriority + type + "," + dv + ",<," + number + "," + outt + "," + prv + "," + num + ",<," + numbers + "," + pp + ";";
                j++;
            }
            string strSqlCommand = "UPDATE  design  SET PlanSystem_ID=@PlanSystem_ID,DosagePriority=@DosagePriority,IlluminatedNumber=@IlluminatedNumber,Coplanar=@Coplanar,MachineNumbe=@MachineNumbe,ControlPoint=@ControlPoint,Grid_ID=@Grid_ID,Algorithm_ID=@Algorithm_ID,Feasibility=@Feasibility,SubmitTime=@datetime,Submit_User_ID=@userid where design.ID=@ctID";
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
            sqlOperation.AddParameterWithValue("@DosagePriority", DosagePriority);
            sqlOperation.AddParameterWithValue("@ctID", designID);
            sqlOperation.AddParameterWithValue("@userid", userid);

            int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            string select1 = "select Progress from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", CTID);
            string progress = sqlOperation.ExecuteScalar(select1);
            string[] group = progress.Split(',');
            bool exists = ((IList)group).Contains("9");
            int Success = 0;
            if (!exists)
            {
                string inserttreat = "update treatment set Progress=@progress where ID=@treat";
                sqlOperation2.AddParameterWithValue("@progress", progress + ",9");
                sqlOperation2.AddParameterWithValue("@treat", CTID);
                Success = sqlOperation2.ExecuteNonQuery(inserttreat);
            }
            else
            {
                Success = 1;

            }


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