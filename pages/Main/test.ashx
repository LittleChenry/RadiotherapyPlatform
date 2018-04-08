<%@ WebHandler Language="C#" Class="test" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Timers;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


public class test : IHttpHandler {
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        transferappoint();
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public static void transferappoint()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        //遍历昨天一天的预约的执行情况，选取那些没有完成的预约记录
        string checkcommmand = "select treatmentrecord.ID as treatid,appointment_accelerate.Begin as appbegin,appointment_accelerate.End as append,appointment_accelerate.ID as appointid,treatmentrecord.isfirst as isfirst,treatmentrecord.ChildDesign_ID as chid,appointment_accelerate.Equipment_ID as equipid,treatmentrecord.ApplyUser as userid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.Treat_User_ID is null and appointment_accelerate.Date=@nowdate";
        sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(checkcommmand);
        while (reader.Read())
        {
            //如果那条预约是首次预约
            if (reader["isfirst"].ToString() == "1")
            {
                //看看今天同时间段可以不可以用
                string checkisfirstcommand = "SELECT count(*) from appointment_accelerate where Equipment_ID=@equip and Begin=@begin and Date=@date";
                sqlOperation1.AddParameterWithValue("@date", DateTime.Now.ToString("yyyy-MM-dd"));
                sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                int count = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommand));
                //已经被别人占用了
                if (count > 0)
                {
                    DateTime temp = DateTime.Now;

                    //取库中看看首次预约的合法时间段
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

                    //从库中取得此设备的划片时间
                    string equipLong = "select Timelength from equipment where ID=@equip";
                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                    int equiplen = int.Parse(sqlOperation1.ExecuteScalar(equipLong));

                    //开始从今天这个时段开始往下依次查合适的时间约上去
                    while (true)
                    {
                        //判断这一天是否是节假日
                        string dayIsOkCom = "select count(*) from worktimetable where Date=@date and IsUsed=1";
                        sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                        int dayIsOk = int.Parse(sqlOperation1.ExecuteScalar(dayIsOkCom));

                        if (dayIsOk == 0)
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
                                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                    int counttemp = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommandtemp));
                                    //依次向下逐步查询，直到合适的时间段
                                    if (counttemp > 0)
                                    {
                                        begintime = begintime + equiplen;
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
                        }

                        //如果今天不行就到明天呗
                        if (BeginFinal != 0)
                        {
                            break;
                        }
                        else
                        {
                            temp = temp.AddDays(1);
                        }
                    }

                    //找到了就可以插进去了
                    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                    sqlOperation1.AddParameterWithValue("@task", "加速器");
                    sqlOperation1.AddParameterWithValue("@pid", pid);
                    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    sqlOperation1.AddParameterWithValue("@begin", BeginFinal);
                    sqlOperation1.AddParameterWithValue("@end", BeginFinal + equiplen);
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
                    //如果这个时间段可以用那就可以用
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
                //此分支处理一般预约，查询此计划的最大预约时间
                string transfercommand = "select max(appointment_accelerate.Date) as maxdate from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                string maxdate = sqlOperation1.ExecuteScalar(transfercommand);
                DateTime maxdatetime = Convert.ToDateTime(maxdate);
                DateTime yesterDateTime = Convert.ToDateTime(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                //如果最大时间是小于等于昨天的话，那就将最大时间的时间轴向后移动到第一个非节假日
                Boolean BigFlag = true;
                if (DateTime.Compare(maxdatetime, yesterDateTime) != 1)
                {
                    maxdatetime = yesterDateTime;
                    while (BigFlag)
                    {
                        maxdatetime = maxdatetime.AddDays(1);
                        string checkHoliday = "select count(*) from worktimetable where Date=@date and IsUsed=1";
                        sqlOperation1.AddParameterWithValue("@date", maxdatetime);
                        int result = int.Parse(sqlOperation1.ExecuteScalar(checkHoliday));
                        if (result == 0)
                        {
                            BigFlag = false;
                        }
                    }
                }

                //查看子计划的相关信息例如时间间隔，每天预约次数
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

                //查看此计划的所属病人id
                string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                string pid = sqlOperation1.ExecuteScalar(pidcommand);

                //查看最后一天此病人此计划是否有预约
                string maxdatetimes = "select count(*) from treatmentrecord,appointment_accelerate where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date=@today and treatmentrecord.ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                sqlOperation1.AddParameterWithValue("@today", maxdatetime.ToString("yyyy-MM-dd"));
                int todaycount = int.Parse(sqlOperation1.ExecuteScalar(maxdatetimes));
                if (todaycount >= Times)
                {
                    //如果那天此子计划的预约次数已经到上限，查看那天的后面每一天是否有空插入此病人
                    DateTime temp = maxdatetime.AddDays(Interal);
                    int BeginFinal = 0;
                    //开始从今天这个时段开始往下依次查合适的时间约上去
                    while (true)
                    {
                        //判断这一天是否是节假日
                        string dayIsOkCom = "select count(*) from worktimetable where Date=@date and IsUsed=1";
                        sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                        int dayIsOk = int.Parse(sqlOperation1.ExecuteScalar(dayIsOkCom));

                        if (dayIsOk == 0)
                        {
                            //首先看看那天的其他时间有没有这个病人的其他预约
                            string otherApointFortheP = "select appointment_accelerate.ID as appointid from appointment_accelerate where Date=@date and Equipment_ID=@equip and Patient_ID=@pid";
                            sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                            sqlOperation1.AddParameterWithValue("@pid", pid);
                            sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                            reader1 = sqlOperation1.ExecuteReader(otherApointFortheP);
                            Boolean flagsucc = false;
                            if (reader1.Read())
                            {
                                string checkfirst = "select count(*) from treatmentrecord  where Appointment_ID=@appoint and isfirst=1";
                                sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                int isfirstCount = int.Parse(sqlOperation2.ExecuteScalar(checkfirst));

                                //找到一条就够了，复用
                                if (isfirstCount == 0)
                                {
                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                }
                                else
                                {
                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,2,@chid);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                }
                                flagsucc = true;
                                BeginFinal = 1;
                            }
                            reader1.Close();

                            if (flagsucc == false)
                            {
                                //发现很遗憾，那天这人没有预约，优先看看那个原来时间段能不能用
                                string emptycommand = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                                sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                string appointid = sqlOperation1.ExecuteScalar(emptycommand);

                                //发现运气不错，那个没有人预约，那就用吧
                                if (appointid == "")
                                {
                                    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@task", "加速器");
                                    sqlOperation1.AddParameterWithValue("@pid", pid);
                                    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
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

                                    BeginFinal = 1;
                                }
                                else
                                {
                                    //那个时间段不能用，那我就从早上开始往下找一个合适的空时间段插入

                                    //查找划片长度
                                    string equipLong = "select Timelength from equipment where ID=@equip";
                                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                    int equiplen = int.Parse(sqlOperation1.ExecuteScalar(equipLong));

                                    //查找每天最大预约时间
                                    string maxdateEveryDay = "select EndTimeTPM from equipment where ID=@equip";
                                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                    int todayMax = int.Parse(sqlOperation1.ExecuteScalar(maxdateEveryDay));

                                    //查找每天最小预约时间
                                    string mindateEveryDay = "select EndTimeTPM from equipment where ID=@equip";
                                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                    int todayMin = int.Parse(sqlOperation1.ExecuteScalar(mindateEveryDay));

                                    //从每天的最小时间开始
                                    int beginpoint = todayMin;
                                    Boolean flag = false;
                                    while (!flag)
                                    {

                                        //只要没有超过最晚时间
                                        if (beginpoint < todayMax)
                                        {
                                            string emptycommand2 = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                                            sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                            sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                            sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                            appointid = sqlOperation1.ExecuteScalar(emptycommand2);
                                            if (appointid == "")
                                            {
                                                string isinfirstAcc = "select count(*) from firstacctime where begintime<=@begin and endtime>@begin";
                                                sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                                int isinfirstAccNum = int.Parse(sqlOperation1.ExecuteScalar(isinfirstAcc));

                                                if (isinfirstAccNum == 0)
                                                {
                                                    flag = true;
                                                    break;

                                                }
                                            }
                                        }
                                        else
                                        {
                                            break;
                                        }
                                        //每次加一个时间片
                                        beginpoint = beginpoint + equiplen;

                                    }

                                    //找到一个
                                    if (flag == true)
                                    {
                                        //找到了就可以插人了
                                        string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@task", "加速器");
                                        sqlOperation1.AddParameterWithValue("@pid", pid);
                                        sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                        sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                                        sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                        sqlOperation1.AddParameterWithValue("@end", beginpoint + equiplen);
                                        string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                        sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                        BeginFinal = 1;
                                    }
                                }
                            }
                        }
                        //如果约好了，就跳出循环
                        if (BeginFinal == 1)
                        {
                            break;
                        }
                        else
                        {
                            //否则继续下一天
                            temp = temp.AddDays(1);
                        }
                    }
                    continue;
                }


                //之后表示此子计划在今天还没有约满不用延后，可以直接插在今天

                //首先我们看看最后一天有没有这个病人的预约
                string todayPatientCommand = "select appointment_accelerate.ID as appointid from appointment_accelerate where Date=@date and Equipment_ID=@equip and Patient_ID=@pid";
                sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                sqlOperation1.AddParameterWithValue("@pid", pid);
                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                reader1 = sqlOperation1.ExecuteReader(todayPatientCommand);
                Boolean flagsucc2 = false;
                while (reader1.Read())
                {
                    //先看看这条记录是否包含了此计划
                    string checkChild = "select count(*) from treatmentrecord where Appointment_ID=@appoint and ChildDesign_ID=@chid";
                    sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                    sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                    int isThisChild = int.Parse(sqlOperation2.ExecuteScalar(checkChild));

                    //不包含此计划那很ok，就可以使用了
                    if (isThisChild == 0)
                    {
                        //发现此子计划是不是包含首次
                        string checkfirst = "select count(*) from treatmentrecord  where Appointment_ID=@appoint and isfirst=1";
                        sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                        int isfirstCount = int.Parse(sqlOperation2.ExecuteScalar(checkfirst));
                        if (isfirstCount == 0)
                        {
                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                            sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                        }
                        else
                        {
                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,2,@chid);select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                            sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                        }
                        flagsucc2 = true;
                        break;

                    }

                }
                reader1.Close();

                //发现没有找到该病人的合适时间复用

                if (flagsucc2 == false)
                {
                    //先查看那天这个时间段能不能用
                    string checkcommand = "select count(*) from treatmentrecord,appointment_accelerate where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date=@date and appointment_accelerate.Begin=@begin and appointment_accelerate.Equipment_ID=@equipid and (appointment_accelerate.Patient_ID<>@pid or treatmentrecord.ChildDesign_ID=@chid)";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    int thiscount = int.Parse(sqlOperation1.ExecuteScalar(checkcommand));
                    if (thiscount == 0)
                    {
                        //取出那个时间段的id
                        string emptycommand = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                        sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                        sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                        sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                        string appointid = sqlOperation1.ExecuteScalar(emptycommand);

                        //插入此计划
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
                        //说明这个时间段不能用，从那天开始到之后的每天进行遍历，直到找到合适的时间段插入为止
                        //那个时间段不能用，那我就从早上开始往下找一个合适的空时间段插入

                        //查找划片长度
                        string equipLong = "select Timelength from equipment where ID=@equip";
                        sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                        int equiplen = int.Parse(sqlOperation1.ExecuteScalar(equipLong));

                        //查找每天最大预约时间
                        string maxdateEveryDay = "select EndTimeTPM from equipment where ID=@equip";
                        sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                        int todayMax = int.Parse(sqlOperation1.ExecuteScalar(maxdateEveryDay));

                        //查找每天最小预约时间
                        string mindateEveryDay = "select EndTimeTPM from equipment where ID=@equip";
                        sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                        int todayMin = int.Parse(sqlOperation1.ExecuteScalar(mindateEveryDay));

                        //从每天的最小时间开始
                        int beginpoint = todayMin;
                        Boolean flag = false;
                        string appointid = "";
                        while (!flag)
                        {


                            //只要没有超过最晚时间
                            if (beginpoint < todayMax)
                            {
                                //如果发现一个没有被占用的格子就可以了
                                string emptycommand2 = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                                sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                                sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                appointid = sqlOperation1.ExecuteScalar(emptycommand2);
                                if (appointid == "")
                                {
                                    string isinfirstAcc = "select count(*) from firstacctime where begintime<=@begin and endtime>@begin";
                                    sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                    int isinfirstAccNum = int.Parse(sqlOperation1.ExecuteScalar(isinfirstAcc));

                                    if (isinfirstAccNum == 0)
                                    {
                                        flag = true;
                                        break;

                                    }
                                }
                            }
                            else
                            {
                                break;
                            }

                            //每次加一个时间片
                            beginpoint = beginpoint + equiplen;

                        }

                        //如果在那一天找到了合适的时间,就直接插入

                        if (flag == true)
                        {
                            //找到了就可以插人了
                            string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@task", "加速器");
                            sqlOperation1.AddParameterWithValue("@pid", pid);
                            sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                            sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                            sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                            sqlOperation1.AddParameterWithValue("@end", beginpoint + equiplen);
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
                            //最坏情况，那天没找到，只能往后推了
                            //先加个最大间隔做起始天
                            DateTime temp = maxdatetime.AddDays(Interal);
                            //开始从今天这个时段开始往下依次查合适的时间约上去
                            while (true)
                            {
                                //判断这一天是否是节假日
                                string dayIsOkCom = "select count(*) from worktimetable where Date=@date and IsUsed=1";
                                sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                int dayIsOk = int.Parse(sqlOperation1.ExecuteScalar(dayIsOkCom));

                                if (dayIsOk == 0)
                                {
                                    //首先看看那天的其他时间有没有这个病人的其他预约
                                    string otherApointFortheP = "select appointment_accelerate.ID as appointid from appointment_accelerate where Date=@date and Equipment_ID=@equip and Patient_ID=@pid";
                                    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                    sqlOperation1.AddParameterWithValue("@pid", pid);
                                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                    reader1 = sqlOperation1.ExecuteReader(otherApointFortheP);
                                    Boolean flagsucc = false;
                                    if (reader1.Read())
                                    {
                                        string checkfirst = "select count(*) from treatmentrecord  where Appointment_ID=@appoint and isfirst=1";
                                        sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                        int isfirstCount = int.Parse(sqlOperation2.ExecuteScalar(checkfirst));

                                        //找到一条就够了，复用
                                        if (isfirstCount == 0)
                                        {
                                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                            sqlOperation1.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                            sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                        }
                                        else
                                        {
                                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,2,@chid);select @@IDENTITY";
                                            sqlOperation1.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                            sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                        }
                                        flagsucc = true;
                                        flag = true;
                                    }
                                    reader1.Close();

                                    //发现很遗憾，那天这人没有预约，优先看看那个原来时间段能不能用
                                    string emptycommand = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                                    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                    sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                    appointid = sqlOperation1.ExecuteScalar(emptycommand);

                                    //发现运气不错，那个没有人预约，那就用吧
                                    if (appointid == "")
                                    {
                                        string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@task", "加速器");
                                        sqlOperation1.AddParameterWithValue("@pid", pid);
                                        sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
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

                                        flag = true;
                                    }
                                    else
                                    {
                                        //那个时间段不能用，那我就从早上开始往下找一个合适的空时间段插入
                                        beginpoint = todayMin;
                                        while (!flag)
                                        {


                                            //只要没有超过最晚时间
                                            if (beginpoint < todayMax)
                                            {
                                                string emptycommand2 = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                                                sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                                sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                                appointid = sqlOperation1.ExecuteScalar(emptycommand2);
                                                if (appointid == "")
                                                {
                                                    string isinfirstAcc = "select count(*) from firstacctime where begintime<=@begin and endtime>@begin";
                                                    sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                                    int isinfirstAccNum = int.Parse(sqlOperation1.ExecuteScalar(isinfirstAcc));

                                                    if (isinfirstAccNum == 0)
                                                    {
                                                        flag = true;
                                                        break;

                                                    }
                                                }
                                            }
                                            else
                                            {
                                                break;
                                            }
                                            //每次加一个时间片
                                            beginpoint = beginpoint + equiplen;

                                        }

                                        //找到一个
                                        if (flag == true)
                                        {
                                            //找到了就可以插人了
                                            string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                            sqlOperation1.AddParameterWithValue("@task", "加速器");
                                            sqlOperation1.AddParameterWithValue("@pid", pid);
                                            sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                            sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                                            sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                            sqlOperation1.AddParameterWithValue("@end", beginpoint + equiplen);
                                            string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                            sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                            sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                        }
                                    }
                                }
                                if (flag == true)
                                {
                                    break;
                                }
                                else
                                {
                                    temp = temp.AddDays(1);
                                }
                            }

                        }
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
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
    }

 
}