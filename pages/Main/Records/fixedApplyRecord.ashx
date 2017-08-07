<%@ WebHandler Language="C#" Class="fixedApplyRecord" %>

using System;
using System.Web;
using System.Collections;
public class fixedApplyRecord : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");  
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddFixRecord(context);
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
    public string AddFixRecord(HttpContext context)
    {
        //获取表单信息
        string appoint = context.Request["id"];
        string treatid = context.Request["treatid"];
        string model = context.Request["model"];
        string fixreq = context.Request["fixreq"];
        string user = context.Request["user"];
        string fixequip = context.Request["fixequip"];
        string bodypost = context.Request["bodypost"];
        string Remarks = context.Request["Remarks"];
        string select1 = "select Progress from treatment where ID=@treatid";
        sqlOperation.AddParameterWithValue("@treatid", Convert.ToInt32(treatid));
        string progress = sqlOperation.ExecuteScalar(select1);
        string[] group = progress.Split(',');
        bool exists = ((IList)group).Contains("2");
        if (!exists)
        {
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
                    string strSqlCommand = "INSERT INTO fixed(Appointment_ID,Model_ID,FixedRequirements_ID,Application_User_ID,ApplicationTime,BodyPosition,RemarksApply,FixedEquipment_ID) " +
                                            "VALUES(@Appointment_ID,@Model_ID,@FixedRequirements_ID,@Application_User_ID,@ApplicationTime,@BodyPosition,@RemarksApply,@FixedEquipment_ID)";
                    sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                    sqlOperation1.AddParameterWithValue("@Model_ID", Convert.ToInt32(model));
                    sqlOperation1.AddParameterWithValue("@FixedRequirements_ID", Convert.ToInt32(fixreq));
                    sqlOperation1.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                    sqlOperation1.AddParameterWithValue("@ApplicationTime", DateTime.Now);
                    sqlOperation1.AddParameterWithValue("@BodyPosition", bodypost);
                    sqlOperation1.AddParameterWithValue("@RemarksApply", Remarks);
                    sqlOperation1.AddParameterWithValue("@FixedEquipment_ID", fixequip);
                    int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);

                    string maxnumber = "select ID from fixed where Appointment_ID=@appointid and Application_User_ID=@Application_User_ID order by ID desc";
                    sqlOperation.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                    string maxfixid = sqlOperation.ExecuteScalar(maxnumber);

                    //将诊断ID填入treatment表
                    string inserttreat = "update treatment set Fixed_ID=@fix_ID,Progress=@progress where ID=@treat";
                    sqlOperation.AddParameterWithValue("@progress", "0,1,2");
                    sqlOperation.AddParameterWithValue("@fix_ID", Convert.ToInt32(maxfixid));
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
        else
        {
            string time = DateTime.Now.ToString();
            string strSqlCommand = "INSERT INTO fixed(Appointment_ID,Model_ID,FixedRequirements_ID,Application_User_ID,ApplicationTime,BodyPosition,RemarksApply,FixedEquipment_ID) " +
                                            "VALUES(@Appointment_ID,@Model_ID,@FixedRequirements_ID,@Application_User_ID,@ApplicationTime,@BodyPosition,@RemarksApply,@FixedEquipment_ID)";
            sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
            sqlOperation1.AddParameterWithValue("@Model_ID", Convert.ToInt32(model));
            sqlOperation1.AddParameterWithValue("@FixedRequirements_ID", Convert.ToInt32(fixreq));
            sqlOperation1.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
            sqlOperation1.AddParameterWithValue("@ApplicationTime", time);
            sqlOperation1.AddParameterWithValue("@BodyPosition", bodypost);
            sqlOperation1.AddParameterWithValue("@RemarksApply", Remarks);
            sqlOperation1.AddParameterWithValue("@FixedEquipment_ID", fixequip);
            int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);

            string maxnumber = "select ID from fixed where Appointment_ID=@appointid and ApplicationTime=@ApplicationTime order by ID desc";
            sqlOperation.AddParameterWithValue("@ApplicationTime", time);
            sqlOperation.AddParameterWithValue("@appointid", Convert.ToInt32(appoint));
            string maxfixid = sqlOperation.ExecuteScalar(maxnumber);

            //将诊断ID填入treatment表
            string inserttreat = "update treatment set Fixed_ID=@fix_ID where ID=@treat";
            sqlOperation.AddParameterWithValue("@fix_ID", Convert.ToInt32(maxfixid));
            sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
            int Success = sqlOperation.ExecuteNonQuery(inserttreat);
            if (Success > 0 && Success2 > 0)
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