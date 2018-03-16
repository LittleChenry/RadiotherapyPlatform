<%@ WebHandler Language="C#" Class="designConfirmRecord" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class designConfirmRecord : IHttpHandler {
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
            string state = context.Request.Form["state"];
            bool state1 = false;
            if (state == "审核通过")
            {
                state1 = true;
                string strSqlCommand = "UPDATE  design  SET State=@state,Checkadvice=@advice,ConfirmTime=@datetime,Confirm_User_ID=@userid where design.ID=@ctID";
                //各参数赋予实际值
                sqlOperation.AddParameterWithValue("@state", state1);
                sqlOperation.AddParameterWithValue("@advice", context.Request.Form["advice"]);
                //sqlOperation.AddParameterWithValue("@Remarks", context.Request.Form["Remarks"]);        
                sqlOperation.AddParameterWithValue("@datetime", datetime);
                sqlOperation.AddParameterWithValue("@ctID", designID);
                sqlOperation.AddParameterWithValue("@userid", userid);
                int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
                string select1 = "select Progress from treatment where ID=@treat";
                sqlOperation.AddParameterWithValue("@treat", CTID);
                string progress = sqlOperation.ExecuteScalar(select1);
                string[] group = progress.Split(',');
                bool exists = ((IList)group).Contains("10");
                int Success = 0;
                if (!exists)
                {
                    string inserttreat = "update treatment set Progress=@progress where ID=@treat";
                    sqlOperation2.AddParameterWithValue("@progress", progress + ",10");
                    sqlOperation2.AddParameterWithValue("@treat", CTID);
                    Success = sqlOperation2.ExecuteNonQuery(inserttreat);
                }
                else
                {
                    Success = 1;
                }
                if (intSuccess > 0 && Success > 0)
                {
                    return "success";
                 }
                else
                {
                    return "failure";
                }
            }
            else
            {
                state1 = false;
                string strSqlCommand = "UPDATE  design  SET State=@state,Checkadvice=@advice,ConfirmTime=@datetime,Confirm_User_ID=@userid where design.ID=@ctID";
                //各参数赋予实际值
                DateTime time = DateTime.Now;
                sqlOperation.AddParameterWithValue("@state", state1);
                sqlOperation.AddParameterWithValue("@advice", context.Request.Form["advice"]);
                //sqlOperation.AddParameterWithValue("@Remarks", context.Request.Form["Remarks"]);        
                sqlOperation.AddParameterWithValue("@datetime", datetime);
                sqlOperation.AddParameterWithValue("@ctID", designID);
                sqlOperation.AddParameterWithValue("@userid", userid);
                int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
                string submittime = "select submitTime from design where ID=@ID";
                sqlOperation.AddParameterWithValue("@ID", designID);
                submittime = sqlOperation.ExecuteScalar(submittime);
                string warning = "insert into warningcase (TreatID,progress,Stoptime,Type,RestartTime)values(@TreatID,@progress,@Stoptime,@Type,@RestartTime)";
                sqlOperation.AddParameterWithValue("@TreatID", CTID);
                sqlOperation.AddParameterWithValue("@progress", 7);
                sqlOperation.AddParameterWithValue("@Stoptime", submittime);
                sqlOperation.AddParameterWithValue("@RestartTime", time);
                sqlOperation.AddParameterWithValue("@Type", 2);
                sqlOperation.ExecuteNonQuery(warning);
                string inserttreat = "update treatment set Progress=@progress,isback=1 where ID=@treat";
                sqlOperation2.AddParameterWithValue("@progress", "0,1,2,3,4,5,6,7");
                sqlOperation2.AddParameterWithValue("@treat", CTID);
                int Success = sqlOperation2.ExecuteNonQuery(inserttreat);
                if (intSuccess > 0 && Success > 0)
                {
                    return "back";
                }
                else
                {
                    return "failure";
                }
            }

            
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }


    }
}