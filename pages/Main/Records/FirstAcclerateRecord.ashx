<%@ WebHandler Language="C#" Class="FirstAcclerateRecord" %>

using System;
using System.Web;

public class FirstAcclerateRecord : IHttpHandler {
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
        string totalnumber = context.Request["totalnumber"];
        string isfinished = context.Request["isfinished"];
        string user = context.Request["user"];
        string username = context.Request["username"];
        string check = "select count(Appointment_ID) from treatmentrecord where ApplyUser is not NULL and Treatment_ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        int checkcount = Convert.ToInt32(sqlOperation.ExecuteScalar(check));
        if (checkcount != 0)
        {
            string check2 = "select Appointment_ID from treatmentrecord where ApplyUser is not NULL and Treatment_ID=@treat";
            string checkappoint = sqlOperation.ExecuteScalar(check2);
            if (checkappoint == appoint)
            {
                int Success = 0;
                if (Convert.ToInt32(isfinished) == 1)
                {
                    string select = "select ChangeLog from treatment where ID=@treat";
                    string log = sqlOperation.ExecuteScalar(select);
                    string select1 = "select Progress from treatment where ID=@treat";
                    string progress = sqlOperation.ExecuteScalar(select1);
                    //将诊断ID填入treatment表
                    string inserttreat = "update treatment set Progress=@progress,TotalNumber=@total,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                    sqlOperation.AddParameterWithValue("@progress", progress + ",14,15");
                    sqlOperation.AddParameterWithValue("@total", Convert.ToInt32(totalnumber));
                    sqlOperation.AddParameterWithValue("@log", log + ";" + username + "," + DateTime.Now + "," + totalnumber);
                    sqlOperation.AddParameterWithValue("@split", context.Request["splitway"]);
                    sqlOperation.AddParameterWithValue("@remark", context.Request["remarks"]);
                    Success = sqlOperation.ExecuteNonQuery(inserttreat);
                }
                else
                {
                    string select = "select ChangeLog from treatment where ID=@treat";
                    string log = sqlOperation.ExecuteScalar(select);
                    string inserttreat = "update treatment set TotalNumber=@total,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                    sqlOperation.AddParameterWithValue("@log", log + ";" + username + "," + DateTime.Now + "," + totalnumber);
                    sqlOperation.AddParameterWithValue("@total", Convert.ToInt32(totalnumber));
                    sqlOperation.AddParameterWithValue("@split", context.Request["splitway"]);
                    sqlOperation.AddParameterWithValue("@remark", context.Request["remarks"]);
                    Success = sqlOperation.ExecuteNonQuery(inserttreat);
                }
                if (Success > 0)
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
                        return context.Request["remarks"];
                        string strcommand2 = "select Patient_ID from treatment where ID=@treat";
                        sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                        string patient_ID = sqlOperation.ExecuteScalar(strcommand2);
                        string finishappoint1 = "update appointment set state=0 where ID=@appoint";
                        sqlOperation.AddParameterWithValue("@appoint", Convert.ToInt32(checkappoint));
                        sqlOperation.ExecuteNonQuery(finishappoint1);
                        string finishappoint = "update appointment set Patient_ID=@Patient,Treatment_ID=@treat where ID=@appointid";
                        sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
                        int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);
                        //将信息写入数据库，并返回是否成功
                        string strSqlCommand = "update treatmentrecord set Appointment_ID=@Appointment_ID,ApplyUser=@user,ApplyTime=@time where Treatment_ID=@Treatment_ID";
                        sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                        sqlOperation1.AddParameterWithValue("@Treatment_ID", Convert.ToInt32(treatid));
                        sqlOperation1.AddParameterWithValue("@time", DateTime.Now);
                        sqlOperation1.AddParameterWithValue("@user", Convert.ToInt32(user));
                        int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);
                        int Success = 0;
                        if (Convert.ToInt32(isfinished) == 1)
                        {
                            string select = "select ChangeLog from treatment where ID=@treat";
                            string log = sqlOperation.ExecuteScalar(select);
                            string select1 = "select Progress from treatment where ID=@treat";
                            string progress = sqlOperation.ExecuteScalar(select1);
                            //将诊断ID填入treatment表
                            string inserttreat = "update treatment set Progress=@progress,TotalNumber=@total,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                            sqlOperation.AddParameterWithValue("@progress", progress + ",14,15");
                            sqlOperation.AddParameterWithValue("@log", log + ";" + username + "," + DateTime.Now + "," + totalnumber);
                            sqlOperation.AddParameterWithValue("@total", Convert.ToInt32(totalnumber));
                            sqlOperation.AddParameterWithValue("@split", context.Request["splitway"]);
                            sqlOperation.AddParameterWithValue("@remark", context.Request["remarks"]);
                            Success = sqlOperation.ExecuteNonQuery(inserttreat);
                        }
                        else
                        {
                            string select = "select ChangeLog from treatment where ID=@treat";
                            string log = sqlOperation.ExecuteScalar(select);
                            string inserttreat = "update treatment set TotalNumber=@total,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                            sqlOperation.AddParameterWithValue("@total", Convert.ToInt32(totalnumber));
                            sqlOperation.AddParameterWithValue("@log", log + ";" + username + "," + DateTime.Now + "," + totalnumber);
                            sqlOperation.AddParameterWithValue("@split", context.Request["splitway"]);
                            sqlOperation.AddParameterWithValue("@remark", context.Request["remarks"]);
                            Success = sqlOperation.ExecuteNonQuery(inserttreat);
                        }
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
        }
        else
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
                    string strSqlCommand = "INSERT INTO treatmentrecord(Treatment_ID,Appointment_ID,ApplyUser,ApplyTime) " +
                                            "VALUES(@Treatment_ID,@Appointment_ID,@ApplyUser,@ApplyTime)";
                    sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                    sqlOperation1.AddParameterWithValue("@Treatment_ID", Convert.ToInt32(treatid));
                    sqlOperation1.AddParameterWithValue("@ApplyTime", DateTime.Now);
                    sqlOperation1.AddParameterWithValue("@ApplyUser", Convert.ToInt32(user));
                    int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);
                    int Success = 0;
                    if (Convert.ToInt32(isfinished) == 1)
                    {
                        string select = "select ChangeLog from treatment where ID=@treat";
                        string log = sqlOperation.ExecuteScalar(select);
                        string select1 = "select Progress from treatment where ID=@treat";
                        string progress = sqlOperation.ExecuteScalar(select1);
                        //将诊断ID填入treatment表
                        string inserttreat = "update treatment set Progress=@progress,TotalNumber=@total,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                        sqlOperation.AddParameterWithValue("@progress", progress + ",14,15");
                        sqlOperation.AddParameterWithValue("@log", log + ";" + username + "," + DateTime.Now + "," + totalnumber);
                        sqlOperation.AddParameterWithValue("@total", Convert.ToInt32(totalnumber));
                        sqlOperation.AddParameterWithValue("@split", context.Request["splitway"]);
                        sqlOperation.AddParameterWithValue("@remark", context.Request["remarks"]);
                        Success = sqlOperation.ExecuteNonQuery(inserttreat);
                    }
                    else
                    {
                        string select = "select ChangeLog from treatment where ID=@treat";
                        string log = sqlOperation.ExecuteScalar(select);
                        string inserttreat = "update treatment set TotalNumber=@total,ChangeLog=@log,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                        sqlOperation.AddParameterWithValue("@total", Convert.ToInt32(totalnumber));
                        sqlOperation.AddParameterWithValue("@log", log + ";" + username + "," + DateTime.Now + "," + totalnumber);
                        sqlOperation.AddParameterWithValue("@split", context.Request["splitway"]);
                        sqlOperation.AddParameterWithValue("@remark", context.Request["remarks"]);
                        Success = sqlOperation.ExecuteNonQuery(inserttreat);
                    }
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

  }
 }

