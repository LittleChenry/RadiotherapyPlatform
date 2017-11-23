<%@ WebHandler Language="C#" Class="FirstAcclerateRecord" %>

using System;
using System.Web;

public class FirstAcclerateRecord : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
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
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
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
        string equipid = context.Request["equipid"];
        string date = context.Request["date"];
        string begin = context.Request["begin"];
        string end = context.Request["end"];
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
            string check2 = "select count(*) from treatmentrecord where ApplyUser is not NULL and Treatment_ID=@treat";
            string checkappoint = sqlOperation.ExecuteScalar(check2);
            int Success = 0;
            if (Convert.ToInt32(isfinished) == 1)
            {
                string selectallaccerappoint = "select ID from appointment_accelerate where Treatment_ID=@treat and Completed=0";
                sqlOperation2.AddParameterWithValue("@treat", treatid);
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(selectallaccerappoint);
                while (reader.Read())
                {
                    string deletecommand = "delete from appointment_accelerate where ID=@appointid";
                    sqlOperation1.AddParameterWithValue("@appointid", reader["ID"].ToString());
                    sqlOperation1.ExecuteNonQuery(deletecommand);
                    string deletecommand2 = "delete from treatmentrecord where Appointment_ID=@appointid";
                    sqlOperation1.ExecuteNonQuery(deletecommand2);
                }
                reader.Close();
                    string select = "select ChangeLog from treatment where ID=@treat";
                    string log = sqlOperation.ExecuteScalar(select);
                    string select1 = "select Progress from treatment where ID=@treat";
                    string progress = sqlOperation.ExecuteScalar(select1);
                    //将诊断ID填入treatment表
                    string inserttreat = "update treatment set Progress=@progress,TotalNumber=@total,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                    sqlOperation.AddParameterWithValue("@progress", progress + ",13,14");
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
      }else
     {
         string strcommand = "select count(*) from appointment_accelerate where Equipment_ID=@equip and Date=@date and ((Begin<=@begin and End>=@begin) or (Begin<=@end and End>=@end))";
         sqlOperation.AddParameterWithValue("@equip", equipid);
         sqlOperation.AddParameterWithValue("@date", date);
         sqlOperation.AddParameterWithValue("@begin", begin);
         sqlOperation.AddParameterWithValue("@end", end);
        string count = sqlOperation.ExecuteScalar(strcommand);
        if (count == "1")
        {
            return "busy";
        }
        else
        {
            string strcommand1 = "insert into appointment_accelerate(Equipment_ID,Date,Begin,End,Treatment_ID,State,Completed) values(@equip,@date,@begin,@end,@Treatment_ID,0,0);SELECT @@IDENTITY ";
            sqlOperation.AddParameterWithValue("@Treatment_ID", treatid);
            string appointid = sqlOperation.ExecuteScalar(strcommand1);
            string strcommand2 = "select Patient_ID from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
            string patient_ID = sqlOperation.ExecuteScalar(strcommand2);
            string strcommandTask = "select TreatmentItem from equipment where ID=@equip";
            string treattask = sqlOperation.ExecuteScalar(strcommandTask);
            string finishappoint = "update appointment_accelerate set Patient_ID=@Patient,Treatment_ID=@treat,Task=@task where ID=@appointid";
            sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
            sqlOperation.AddParameterWithValue("@appointid", appointid);
            sqlOperation.AddParameterWithValue("@task",treattask);
            int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);

            string strSqlCommand = "INSERT INTO treatmentrecord(Treatment_ID,Appointment_ID,ApplyUser,ApplyTime) " +
                                            "VALUES(@Treatment_ID,@Appointment_ID,@ApplyUser,@ApplyTime)";
            sqlOperation1.AddParameterWithValue("@Appointment_ID", appointid);
            sqlOperation1.AddParameterWithValue("@Treatment_ID", Convert.ToInt32(treatid));
            sqlOperation1.AddParameterWithValue("@ApplyTime", DateTime.Now);
            sqlOperation1.AddParameterWithValue("@ApplyUser", Convert.ToInt32(user));
            int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);
             int Success = 0;
                    if (Convert.ToInt32(isfinished) == 1)
                    {
                        string selectallaccerappoint = "select ID from appointment_accelerate where Treatment_ID=@treat and Completed=0";
                        sqlOperation2.AddParameterWithValue("@treat", treatid);
                        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(selectallaccerappoint);
                        while (reader.Read())
                        {
                            string deletecommand = "delete from appointment_accelerate where ID=@appointid";
                            sqlOperation1.AddParameterWithValue("@appointid", reader["ID"].ToString());
                            sqlOperation1.ExecuteNonQuery(deletecommand);
                            string deletecommand2 = "delete from treatmentrecord where Appointment_ID=@appointid";
                            sqlOperation1.ExecuteNonQuery(deletecommand2);
                        }
                        reader.Close();
                        string select = "select ChangeLog from treatment where ID=@treat";
                        string log = sqlOperation.ExecuteScalar(select);
                        string select1 = "select Progress from treatment where ID=@treat";
                        string progress = sqlOperation.ExecuteScalar(select1);
                        //将诊断ID填入treatment表
                        string inserttreat = "update treatment set Progress=@progress,TotalNumber=@total,ChangeLog=@log,SplitWay_ID=@split,SpecialEnjoin=@remark where ID=@treat";
                        sqlOperation.AddParameterWithValue("@progress", progress + ",13,14");
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

