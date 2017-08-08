<%@ WebHandler Language="C#" Class="ReplacementApply" %>

using System;
using System.Web;
using System.Collections;
public class ReplacementApply : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    DataLayer sqlOperation3 = new DataLayer("sqlStr");
    DataLayer sqlOperation4 = new DataLayer("sqlStr");
    DataLayer sqlOperation5 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddReplaceRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation3.Close();
        sqlOperation3.Dispose();
        sqlOperation4.Close();
        sqlOperation4.Dispose();
        sqlOperation5.Close();
        sqlOperation5.Dispose();
        context.Response.Write(result);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string AddReplaceRecord(HttpContext context)
    {
        //获取表单信息
        string appoint = context.Request["id"];
        string treatid = context.Request["treatid"];
        string user = context.Request["user"];
        string require = context.Request["replacementrequire"];
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
                
                    strcommand = "select Patient_ID from treatment where ID=@treat";
                    sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                    string patient_ID = sqlOperation.ExecuteScalar(strcommand);

                    string finishappoint = "update appointment set Patient_ID=@Patient,Treatment_ID=@treat where ID=@appointid";
                    sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
                    sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                    int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);

                    //将信息写入数据库，并返回是否成功
                    string strSqlCommand = "INSERT INTO replacement(Appointment_ID,ReplacementRequirements_ID,Application_User_ID,ApplicationTime) " +
                                            "VALUES(@Appointment_ID,@ReplacementRequirements_ID,@Application_User_ID,@ApplicationTime)";
                    sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                    sqlOperation1.AddParameterWithValue("@ReplacementRequirements_ID", Convert.ToInt32(require));
                    sqlOperation1.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                    sqlOperation1.AddParameterWithValue("@ApplicationTime", DateTime.Now);
                    int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);

                    //查询插入的ID
                    string maxnumber = "select ID from replacement where Appointment_ID=@Appointment_ID and Application_User_ID=@Application_User_ID order by ID desc";
                    sqlOperation2.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                    sqlOperation2.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                    string idnumber = sqlOperation2.ExecuteScalar(maxnumber);
                    string select1 = "select Progress from treatment where ID=@treat";
                    string progress = sqlOperation.ExecuteScalar(select1);
                     string[] group = progress.Split(',');
                    bool exists = ((IList)group).Contains("12");
                    int Success = 0;
                    if (!exists)
                    {
                        //将诊断ID填入treatment表
                        string inserttreat = "update treatment set Replacement_ID=@fix_ID,Progress=@progress where ID=@treat";
                        sqlOperation3.AddParameterWithValue("@progress", progress + ",12");
                        sqlOperation3.AddParameterWithValue("@fix_ID", Convert.ToInt32(idnumber));
                        sqlOperation3.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                        Success = sqlOperation3.ExecuteNonQuery(inserttreat);
                    }
                    else
                    {
                        string inserttreat = "update treatment set Replacement_ID=@fix_ID where ID=@treat";
                        sqlOperation3.AddParameterWithValue("@fix_ID", Convert.ToInt32(idnumber));
                        sqlOperation3.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                        Success = sqlOperation3.ExecuteNonQuery(inserttreat);
                    }
                    if (Success1 > 0 && Success2 > 0 && Success > 0)
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
