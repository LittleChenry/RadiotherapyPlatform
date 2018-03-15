using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Timers;
using System.Collections;

/// <summary>
/// AutoRun 的摘要说明
/// </summary>
public class AutoRun
{
    public static bool IsOpen = false;
    public static DateTime LastOpenTime = DateTime.Now;
    public static void Execute()
    {
        Timer objTimer = new Timer();
        objTimer.Interval = 60000; 
        objTimer.Enabled = true;
        objTimer.Elapsed += new ElapsedEventHandler(objTimer_Elapsed);
    }

    public static void objTimer_Elapsed(object sender, ElapsedEventArgs e)
    {
        //DataLayer sqlOperation3 = new DataLayer("sqlStr");
        //string testinsert = "insert into test(content) values(@date)";
        //sqlOperation3.AddParameterWithValue("@date", DateTime.Now.Hour + ":" + DateTime.Now.Minute);
        //sqlOperation3.ExecuteNonQuery(testinsert);
        //sqlOperation3.Close();
        //sqlOperation3.Dispose();
        //sqlOperation3 = null;

        if (int.Parse(DateTime.Now.Hour.ToString()) >= 5 && int.Parse(DateTime.Now.Hour.ToString()) <= 6)
        {
            //如果上一次执行时间为昨天，就设置IsOpen为false,说明今天还没有执行
            if (DateTime.Today.AddDays(-1) == LastOpenTime.Date)
            {
                IsOpen = false;
            }
            //如果今天还没执行，并且当前时间大于指定执行时间，就执行，
            //执行完后，设置IsOpen为true,说明今天已执行过了。
            if (!IsOpen)
            {
                transferappoint();
                IsOpen = true;
                LastOpenTime = DateTime.Today;
            }
        }
    }

    public static void transferappoint()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string checkcommmand = "select treatmentrecord.ID as treatid,appointment_accelerate.Begin as appbegin,appointment_accelerate.End as append,appointment_accelerate.ID as appointid,treatmentrecord.isfirst as isfirst,treatmentrecord.ChildDesign_ID as chid,appointment_accelerate.Equipment_ID as equipid,treatmentrecord.ApplyUser as userid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.Treat_User_ID is null and appointment_accelerate.Date=@nowdate";
        sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(checkcommmand);
        while (reader.Read())
        {
            if (reader["isfirst"].ToString() == "1")
            {
                string checkisfirstcommand = "SELECT count(*) from appointment_accelerate where Equipment_ID=@equip and Begin=@begin and Date=@date";
                sqlOperation1.AddParameterWithValue("@date", DateTime.Now.ToString("yyyy-MM-dd"));
                sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                int count = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommand));
                if (count > 0)
                {
                    DateTime temp = DateTime.Now;
                    string firsttimecommand = "select begintime,endtime from firstacctime";
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(firsttimecommand);
                    ArrayList beginarray = new ArrayList();
                    ArrayList endarray = new ArrayList();
                    while (reader1.Read())
                    {
                        beginarray.Add(reader1["begintime"].ToString());
                        endarray.Add(reader1["endtime"].ToString());
                    }
                    reader1.Close();
                    int BeginFinal = 0;

                    while (true)
                    {
                        for (int i = 0; i < beginarray.Count; i++)
                        {
                            int begintime = int.Parse(beginarray[i].ToString());
                            int endtime = int.Parse(endarray[i].ToString());
                            while (begintime < endtime)
                            {
                                string checkisfirstcommandtemp = "SELECT count(*) from appointment_accelerate where Equipment_ID=@equip and Begin=@begin and Date=@date";
                                sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                sqlOperation1.AddParameterWithValue("@begin", begintime);
                                sqlOperation1.AddParameterWithValue("@equip", begintime + 10);
                                int counttemp = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommandtemp));
                                if (counttemp > 0)
                                {
                                    begintime = begintime + 10;
                                }
                                else
                                {
                                    BeginFinal = begintime;
                                    break;
                                }

                            }
                            if (BeginFinal != 0)
                            {
                                break;
                            }

                        }
                        if (BeginFinal != 0)
                        {
                            break;
                        }
                        else
                        {
                            temp = temp.AddDays(1);
                        }
                    }
                    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                    sqlOperation1.AddParameterWithValue("@task", "加速器");
                    sqlOperation1.AddParameterWithValue("@pid", pid);
                    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    sqlOperation1.AddParameterWithValue("@begin", BeginFinal);
                    sqlOperation1.AddParameterWithValue("@end", BeginFinal + 10);
                    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                }
                else
                {
                    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                    sqlOperation1.AddParameterWithValue("@task", "加速器");
                    sqlOperation1.AddParameterWithValue("@pid", pid);
                    sqlOperation1.AddParameterWithValue("@date", DateTime.Now.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                    sqlOperation1.AddParameterWithValue("@end", reader["append"].ToString());
                    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                }
            }
            else
            {
                string transfercommand = "select max(appointment_accelerate.Date) as maxdate from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                string maxdate = sqlOperation1.ExecuteScalar(transfercommand);
                DateTime maxdatetime = Convert.ToDateTime(maxdate);

                int Interal = 0, Times = 0;
                string splitcommand = "select Interal,Times from splitway,childdesign where childdesign.Splitway_ID=splitway.ID and childdesign.ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(splitcommand);
                if (reader1.Read())
                {
                    Interal = int.Parse(reader1["Interal"].ToString());
                    Times = int.Parse(reader1["Times"].ToString());
                }
                reader1.Close();

                string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                string pid = sqlOperation1.ExecuteScalar(pidcommand);

                string maxdatetimes = "select count(*) from treatmentrecord,appointment_accelerate where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date=@today and treatmentrecord.ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                sqlOperation1.AddParameterWithValue("@today", maxdatetime.ToString("yyyy-MM-dd"));
                int todaycount = int.Parse(sqlOperation1.ExecuteScalar(maxdatetimes));
                if (todaycount >= Times)
                {
                    string emptycommand = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                    sqlOperation1.AddParameterWithValue("@date", maxdatetime.AddDays(1).ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                    string appointid = sqlOperation1.ExecuteScalar(emptycommand);
                    if (appointid == "")
                    {
                        string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@task", "加速器");
                        sqlOperation1.AddParameterWithValue("@pid", pid);
                        sqlOperation1.AddParameterWithValue("@date", maxdatetime.AddDays(1).ToString("yyyy-MM-dd"));
                        sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                        sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                        sqlOperation1.AddParameterWithValue("@end", reader["append"].ToString());
                        string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@appoint", insertid);
                        sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                    }
                    else
                    {
                        int beginpoint = int.Parse(reader["appbegin"].ToString());
                        Boolean flag = false;
                        while (!flag)
                        {
                            beginpoint = beginpoint + 10;
                            string emptycommand2 = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                            sqlOperation1.AddParameterWithValue("@date", maxdatetime.AddDays(1).ToString("yyyy-MM-dd"));
                            sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                            sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                            appointid = sqlOperation1.ExecuteScalar(emptycommand2);
                            if (appointid != "")
                            {
                                flag = true;
                                break;

                            }
                        }
                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@appoint", appointid);
                        sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);

                    }
                    continue;
                }
                string checkcommand = "select count(*) from treatmentrecord,appointment_accelerate where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date=@date and appointment_accelerate.Begin=@begin and appointment_accelerate.Equipment_ID=@equipid and (appointment_accelerate.Patient_ID<>@pid or treatmentrecord.ChildDesign_ID=@chid)";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                int thiscount = int.Parse(sqlOperation1.ExecuteScalar(checkcommand));
                if (thiscount > 0)
                {
                    int beginpoint = int.Parse(reader["appbegin"].ToString());
                    Boolean flag = false;
                    while (!flag)
                    {
                        beginpoint = beginpoint + 10;
                        string checkcommand2 = "select count(*) from treatmentrecord,appointment_accelerate where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date=@date and appointment_accelerate.Begin=@begin and appointment_accelerate.Equipment_ID=@equipid and (appointment_accelerate.Patient_ID<>@pid or treatmentrecord.ChildDesign_ID=@chid)";
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                        sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                        sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                        thiscount = int.Parse(sqlOperation1.ExecuteScalar(checkcommand2));
                        if (thiscount == 0)
                        {
                            flag = true;
                            break;
                        }

                    }
                    string emptycommand = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                    sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                    string appointid = sqlOperation1.ExecuteScalar(emptycommand);
                    if (appointid == "")
                    {
                        string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@task", "加速器");
                        sqlOperation1.AddParameterWithValue("@pid", pid);
                        sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                        sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                        sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                        sqlOperation1.AddParameterWithValue("@end", beginpoint + 10);
                        string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@appoint", insertid);
                        sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                    }
                    else
                    {
                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@appoint", appointid);
                        sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                    }
                }
                else
                {
                    string emptycommand = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                    sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                    string appointid = sqlOperation1.ExecuteScalar(emptycommand);
                    if (appointid == "")
                    {
                        string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@task", "加速器");
                        sqlOperation1.AddParameterWithValue("@pid", pid);
                        sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                        sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                        sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                        sqlOperation1.AddParameterWithValue("@end", reader["append"].ToString());
                        string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@appoint", insertid);
                        sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                    }
                    else
                    {
                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@appoint", appointid);
                        sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                    }
                }
            }


        }
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
    }
}