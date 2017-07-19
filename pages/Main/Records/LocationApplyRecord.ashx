<%@ WebHandler Language="C#" Class="LocationApplyRecord" %>

using System;
using System.Web;

public class LocationApplyRecord : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    DataLayer sqlOperation3 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddLocationApplyRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(result);
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string AddLocationApplyRecord(HttpContext context)
    {
        //获取表单信息
        string appoint = context.Request["id"];
        string treatid = context.Request["treatid"];
        string scanpart = context.Request["scanpart"];
        string scanmethod = context.Request["scanmethod"];
        string user = context.Request["user"];
        string add = context.Request["add"];
        string addmethod = context.Request["addmethod"];
        string down = context.Request["down"];
        string up = context.Request["up"];
        string remark = context.Request["remark"];
        string requirement = context.Request["requirement"];
        
        string strcommand = "select State from appointment where ID=@appointid";
        sqlOperation.AddParameterWithValue("@appointid", Convert.ToInt32(appoint));
        string count = sqlOperation.ExecuteScalar(strcommand);
        if (count == "1")
        {
            return "busy";
        }
        else
        {
            string strcommand1 = "update appointment set State=1 where ID=@appointid and State=0";
            int intSuccess = sqlOperation.ExecuteNonQuery(strcommand1);
            if (intSuccess == 0)
            {
                return "busy";
            }
            else
            {
                string strcommand2 = "select Patient_ID from treatment where ID=@treat";
                sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                string patient_ID = sqlOperation.ExecuteScalar(strcommand2);

                string finishappoint = "update appointment set Patient_ID=@Patient,Treatment_ID=@treat where ID=@appointid";
                sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
                int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);
                //将信息写入数据库，并返回是否成功
                string strSqlCommand = "INSERT INTO location(Appointment_ID,ScanPart_ID,ScanMethod_ID,UpperBound,Enhance,EnhanceMethod_ID,LowerBound,LocationRequirements_ID,Remarks,Application_User_ID,ApplicationTime) " +
                                        "VALUES(@Appointment_ID,@ScanPart_ID,@ScanMethod_ID,@UpperBound,@Enhance,@EnhanceMethod_ID,@LowerBound,@LocationRequirements_ID,@Remarks,@Application_User_ID,@ApplicationTime)";
                sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                sqlOperation1.AddParameterWithValue("@ScanPart_ID", Convert.ToInt32(scanpart));
                sqlOperation1.AddParameterWithValue("@ScanMethod_ID", Convert.ToInt32(scanmethod));
                sqlOperation1.AddParameterWithValue("@UpperBound", up);
                sqlOperation1.AddParameterWithValue("@ApplicationTime", DateTime.Now);
                sqlOperation1.AddParameterWithValue("@LowerBound", down);
                sqlOperation1.AddParameterWithValue("@LocationRequirements_ID", Convert.ToInt32(requirement));
                sqlOperation1.AddParameterWithValue("@Remarks", remark);
                sqlOperation1.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                sqlOperation1.AddParameterWithValue("@Enhance", Convert.ToInt32(add));
                if (Convert.ToInt32(add) == 1)
                {
                    sqlOperation1.AddParameterWithValue("@EnhanceMethod_ID", Convert.ToInt32(addmethod));
                }
                else
                {
                    sqlOperation1.AddParameterWithValue("@EnhanceMethod_ID", null);
                }

                int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);


                string maxnumber = "select ID from  location where Appointment_ID=@appointid and Application_User_ID=@Application_User_ID order by ID desc";
                sqlOperation.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                string maxfixid = sqlOperation.ExecuteScalar(maxnumber);
                string select1 = "select Progress from treatment where ID=@treat";
                string progress=sqlOperation.ExecuteScalar(select1);
                //将诊断ID填入treatment表
                string inserttreat = "update treatment set Location_ID=@Location_ID,Progress=@progress where ID=@treat";
                sqlOperation.AddParameterWithValue("@progress", progress + ",3");
                sqlOperation.AddParameterWithValue("@Location_ID", Convert.ToInt32(maxfixid));
                int Success = sqlOperation.ExecuteNonQuery(inserttreat);
                if (Success > 0 && Success2 > 0 && Success1 > 0)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
            }
        }

    }


}