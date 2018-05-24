using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Timers;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/// <summary>
/// AutoRun 的摘要说明
/// </summary>
public class AutoRun
{
    //自动触发类，IsOpen表示系统是否触发昨天个别案例预约续约，IsOpen1表示系统是否触发昨天整体续约
    public static bool IsOpen = false;
    public static bool IsOpen1 = false;
    public static DateTime LastOpenTime = DateTime.Now;
    public static DateTime LastOpenTime1 = DateTime.Now;

    //执行函数每隔60000毫秒执行objTimer_Elapsed函数
    public static void Execute()
    {
        Timer objTimer = new Timer();
        objTimer.Interval = 60000; 
        objTimer.Enabled = true;
        objTimer.Elapsed += new ElapsedEventHandler(objTimer_Elapsed);
    }

    //查看当前时间是否满足进行个别续约与整体续约
    public static void objTimer_Elapsed(object sender, ElapsedEventArgs e)
    {
        //DataLayer sqlOperation4 = new DataLayer("sqlStr");
        //string testinsert = "insert into test(content) values(@date)";
        //sqlOperation4.AddParameterWithValue("@date", DateTime.Now.Hour + ":" + DateTime.Now.Minute);
        //sqlOperation4.ExecuteNonQuery(testinsert);
        //sqlOperation4.Close();
        //sqlOperation4.Dispose();
        //sqlOperation4 = null;
        //如果现在时间是凌晨4点半到5点，则判断是否可以执行个体体续
        if (int.Parse(DateTime.Now.Hour.ToString()) >= 4 && int.Parse(DateTime.Now.Hour.ToString()) <= 5)
        {
            if (int.Parse(DateTime.Now.Minute.ToString()) >= 30)
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
                    IsOpen = true;
                    LastOpenTime = DateTime.Today;
                    transferappoint();
                  
                }
            }
        }

        //如果现在时间是凌晨5点到6点，则判断是否可以执行群体续约
        if (int.Parse(DateTime.Now.Hour.ToString()) >= 4 && int.Parse(DateTime.Now.Hour.ToString()) <= 5)
        {
            if (int.Parse(DateTime.Now.Minute.ToString()) >= 45)
            {
                //如果昨天工作时间表被人改变了，系统开始自动删除所有已有预约，并按新工作时间重新预约
                DataLayer sqlOperation3 = new DataLayer("sqlStr");
                string workchange = "select count(*) from worktimetable where ModifyTime=@modifytime";
                sqlOperation3.AddParameterWithValue("@modifytime", DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                int isChanged = int.Parse(sqlOperation3.ExecuteScalar(workchange));
                if (isChanged == 0)
                {
                    IsOpen1 = true;
                    LastOpenTime1 = DateTime.Today;
                }
                else
                {
                    //如果上一次执行时间为昨天，就设置IsOpen为false,说明今天还没有执行
                    if (DateTime.Today.AddDays(-1) == LastOpenTime1.Date)
                    {
                        IsOpen1 = false;
                    }
                    //如果今天还没执行，并且当前时间大于指定执行时间，就执行，
                    //执行完后，设置IsOpen为true,说明今天已执行过了。
                    if (!IsOpen1)
                    {
                        IsOpen1 = true;
                        LastOpenTime1 = DateTime.Today;
                        transferappointForAll();
                        
                    }
                }
                sqlOperation3.Close();
                sqlOperation3.Dispose();
                sqlOperation3 = null;
            }
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
            //如果那条预约是首次预约，什么都不做
            if (reader["isfirst"].ToString() == "1")
            {
                ////看看今天同时间段可以不可以用
                //string checkisfirstcommand = "SELECT count(*) from appointment_accelerate where Equipment_ID=@equip and Begin=@begin and Date=@date";
                //sqlOperation1.AddParameterWithValue("@date", DateTime.Now.ToString("yyyy-MM-dd"));
                //sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                //sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                //int count = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommand));
                ////已经被别人占用了
                //if (count > 0)
                //{
                //    DateTime temp = DateTime.Now;
                   
                //    //取库中看看首次预约的合法时间段
                //    string firsttimecommand = "select begintime,endtime from firstacctime";
                //    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(firsttimecommand);
                //    ArrayList beginarray = new ArrayList();
                //    ArrayList endarray = new ArrayList();
                //    while (reader1.Read())
                //    {
                //        beginarray.Add(reader1["begintime"].ToString());
                //        endarray.Add(reader1["endtime"].ToString());
                //    }
                //    reader1.Close();
                //    int BeginFinal = 0;

                //    //从库中取得此设备的划片时间
                //    string equipLong = "select Timelength from equipment where ID=@equip";
                //    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                //    int equiplen = int.Parse(sqlOperation1.ExecuteScalar(equipLong));

                //    //开始从今天这个时段开始往下依次查合适的时间约上去
                //    while (true)
                //    {
                //        //判断这一天是否是节假日
                //        string dayIsOkCom = "select count(*) from worktimetable where Date=@date and IsUsed=1";
                //        sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                //        int dayIsOk = int.Parse(sqlOperation1.ExecuteScalar(dayIsOkCom));

                //        if (dayIsOk == 0)
                //        {
                //            for (int i = 0; i < beginarray.Count; i++)
                //            {
                //                int begintime = int.Parse(beginarray[i].ToString());
                //                int endtime = int.Parse(endarray[i].ToString());
                //                while (begintime < endtime)
                //                {
                //                    string checkisfirstcommandtemp = "SELECT count(*) from appointment_accelerate where Equipment_ID=@equip and Begin=@begin and Date=@date";
                //                    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                //                    sqlOperation1.AddParameterWithValue("@begin", begintime);
                //                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                //                    int counttemp = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommandtemp));
                //                    //依次向下逐步查询，直到合适的时间段
                //                    if (counttemp > 0)
                //                    {
                //                        begintime = begintime + equiplen;
                //                    }
                //                    else
                //                    {
                //                        BeginFinal = begintime;
                //                        break;
                //                    }

                //                }
                //                if (BeginFinal != 0)
                //                {
                //                    break;
                //                }

                //            }
                //        }

                //        //如果今天不行就到明天呗
                //        if (BeginFinal != 0)
                //        {
                //            break;
                //        }
                //        else
                //        {
                //            temp = temp.AddDays(1);
                //        }
                //    }

                //    //找到了就可以插进去了
                //    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                //    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                //    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                //    sqlOperation1.AddParameterWithValue("@task", "加速器");
                //    sqlOperation1.AddParameterWithValue("@pid", pid);
                //    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                //    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                //    sqlOperation1.AddParameterWithValue("@begin", BeginFinal);
                //    sqlOperation1.AddParameterWithValue("@end", BeginFinal + equiplen);
                //    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                //    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                //    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                //    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                //    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                //    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                //}
                //else
                //{
                //    //如果这个时间段可以用那就可以用
                //    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                //    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                //    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                //    sqlOperation1.AddParameterWithValue("@task", "加速器");
                //    sqlOperation1.AddParameterWithValue("@pid", pid);
                //    sqlOperation1.AddParameterWithValue("@date", DateTime.Now.ToString("yyyy-MM-dd"));
                //    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                //    sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                //    sqlOperation1.AddParameterWithValue("@end", reader["append"].ToString());
                //    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                //    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                //    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                //    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                //    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                //    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                //}
            }
            else
            {
                //此分支处理一般预约，查询此计划的最大预约时间
                string transfercommand = "select max(appointment_accelerate.Date) as maxdate from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                string maxdate = sqlOperation1.ExecuteScalar(transfercommand);
                DateTime maxdatetime = Convert.ToDateTime(maxdate);
                DateTime yesterDateTime=Convert.ToDateTime(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd"));
                //如果最大时间是小于等于昨天的话，那就将最大时间的时间轴向后移动到第一个非节假日
                Boolean BigFlag=true;
                if(DateTime.Compare(maxdatetime,yesterDateTime)!=1)
                {
                     maxdatetime=yesterDateTime;
                     while(BigFlag)
                    {
                        maxdatetime=maxdatetime.AddDays(1);
                        string checkHoliday="select count(*) from worktimetable where Date=@date and IsUsed=1";
                        sqlOperation1.AddParameterWithValue("@date",maxdatetime);
                        int result=int.Parse(sqlOperation1.ExecuteScalar(checkHoliday));
                        if(result==0)
                        {
                            BigFlag=false;
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
                                string checkfirst="select count(*) from treatmentrecord  where Appointment_ID=@appoint and isfirst=1";
                                sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                int isfirstCount=int.Parse(sqlOperation2.ExecuteScalar(checkfirst));

                                //找到一条就够了，复用
                                if(isfirstCount==0)
                                {
                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                    sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                    sqlOperation2.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                    sqlOperation2.AddParameterWithValue("@applytime", DateTime.Now);
                                    sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                                    string treatmentrecordid = sqlOperation2.ExecuteScalar(insertcommand);
                                }else
                                {
                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,2,@chid);select @@IDENTITY";
                                    sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                    sqlOperation2.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                    sqlOperation2.AddParameterWithValue("@applytime", DateTime.Now);
                                    sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                                    string treatmentrecordid = sqlOperation2.ExecuteScalar(insertcommand);
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
                                    string mindateEveryDay = "select BeginTimeAM from equipment where ID=@equip";
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
                string todayPatientCommand= "select appointment_accelerate.ID as appointid from appointment_accelerate where Date=@date and Equipment_ID=@equip and Patient_ID=@pid";
                sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                sqlOperation1.AddParameterWithValue("@pid", pid);
                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                reader1 = sqlOperation1.ExecuteReader(todayPatientCommand);
                Boolean flagsucc2 = false;
                while(reader1.Read())
                {
                    //先看看这条记录是否包含了此计划
                    string checkChild="select count(*) from treatmentrecord where Appointment_ID=@appoint and ChildDesign_ID=@chid";
                     sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                     sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                    int isThisChild=int.Parse(sqlOperation2.ExecuteScalar(checkChild));
                    
                    //不包含此计划那很ok，就可以使用了
                    if(isThisChild==0)
                    {
                        //发现此子计划是不是包含首次
                        string checkfirst="select count(*) from treatmentrecord  where Appointment_ID=@appoint and isfirst=1";
                        sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                        int isfirstCount=int.Parse(sqlOperation2.ExecuteScalar(checkfirst));
                        if(isfirstCount==0)
                        {
                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                            sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                            sqlOperation2.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                            sqlOperation2.AddParameterWithValue("@applytime", DateTime.Now);
                            sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                            string treatmentrecordid = sqlOperation2.ExecuteScalar(insertcommand);
                        }else
                        {
                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,2,@chid);select @@IDENTITY";
                            sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                            sqlOperation2.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                            sqlOperation2.AddParameterWithValue("@applytime", DateTime.Now);
                            sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                            string treatmentrecordid = sqlOperation2.ExecuteScalar(insertcommand);
                        }
                        flagsucc2 = true;
                        break;

                    }

                }
                reader1.Close();
               
                //发现没有找到该病人的合适时间复用
                
                if( flagsucc2 ==false)
                {
                    //先查看那天这个时间段能不能用
                    string checkcommand = "select count(*) from treatmentrecord,appointment_accelerate where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date=@date and appointment_accelerate.Begin=@begin and appointment_accelerate.Equipment_ID=@equipid and (appointment_accelerate.Patient_ID<>@pid or treatmentrecord.ChildDesign_ID=@chid)";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begin", reader["appbegin"].ToString());
                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    int thiscount = int.Parse(sqlOperation1.ExecuteScalar(checkcommand));
                    if(thiscount==0)
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
                    }else
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
                        string mindateEveryDay = "select BeginTimeAM from equipment where ID=@equip";
                        sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                        int todayMin = int.Parse(sqlOperation1.ExecuteScalar(mindateEveryDay));

                        //从每天的最小时间开始
                        int beginpoint = todayMin;
                        Boolean flag = false;  
                        string appointid="";
                        while (!flag)
                        {
                            
                         
                            //只要没有超过最晚时间
                            if(beginpoint<todayMax)
                            {
                                //如果发现一个没有被占用的格子就可以了
                                string emptycommand2 = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                                sqlOperation1.AddParameterWithValue("@date", maxdatetime.ToString("yyyy-MM-dd"));
                                sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                appointid = sqlOperation1.ExecuteScalar(emptycommand2);
                                if (appointid == "")
                                {
                                    string isinfirstAcc="select count(*) from firstacctime where begintime<=@begin and endtime>@begin";
                                    sqlOperation1.AddParameterWithValue("@begin",beginpoint);
                                    int isinfirstAccNum=int.Parse(sqlOperation1.ExecuteScalar(isinfirstAcc));
                                               
                                    if(isinfirstAccNum==0)
                                    {
                                            flag = true;
                                            break;

                                    }
                                }
                            }else
                            {
                                break;
                            }

                            //每次加一个时间片
                            beginpoint = beginpoint + equiplen;

                        }

                        //如果在那一天找到了合适的时间,就直接插入
                
                        if(flag==true)
                        {
                            //找到了就可以插人了
                            string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@task", "加速器");
                            sqlOperation1.AddParameterWithValue("@pid", pid);
                            sqlOperation1.AddParameterWithValue("@date",maxdatetime.ToString("yyyy-MM-dd"));
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
                        }else
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
                                    string checkfirst="select count(*) from treatmentrecord  where Appointment_ID=@appoint and isfirst=1";
                                    sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                    int isfirstCount=int.Parse(sqlOperation2.ExecuteScalar(checkfirst));

                                    //找到一条就够了，复用
                                    if(isfirstCount==0)
                                    {
                                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                        sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                        sqlOperation2.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                        sqlOperation2.AddParameterWithValue("@applytime", DateTime.Now);
                                        sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                                        string treatmentrecordid = sqlOperation2.ExecuteScalar(insertcommand);
                                    }else
                                    {
                                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,2,@chid);select @@IDENTITY";
                                        sqlOperation2.AddParameterWithValue("@appoint", reader1["appointid"].ToString());
                                        sqlOperation2.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                                        sqlOperation2.AddParameterWithValue("@applytime", DateTime.Now);
                                        sqlOperation2.AddParameterWithValue("@chid", reader["chid"].ToString());
                                        string treatmentrecordid = sqlOperation2.ExecuteScalar(insertcommand);
                                    }
                                    flagsucc = true;
                                    flag=true;
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

                                   flag=true;
                               } else
                                 {
                                   //那个时间段不能用，那我就从早上开始往下找一个合适的空时间段插入
                                    beginpoint = todayMin;
                                    while (!flag)
                                    {
                                        

                                        //只要没有超过最晚时间
                                        if(beginpoint<todayMax)
                                        {
                                            string emptycommand2 = "select ID from appointment_accelerate where Date=@date and Equipment_ID=@equip and Begin=@begin";
                                            sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                                            sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                            sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                                            appointid = sqlOperation1.ExecuteScalar(emptycommand2);
                                            if (appointid == "")
                                            {
                                                string isinfirstAcc="select count(*) from firstacctime where begintime<=@begin and endtime>@begin";
                                                sqlOperation1.AddParameterWithValue("@begin",beginpoint);
                                                int isinfirstAccNum=int.Parse(sqlOperation1.ExecuteScalar(isinfirstAcc));
                                               
                                                if(isinfirstAccNum==0)
                                                {
                                                        flag = true;
                                                        break;

                                                }
                                            }
                                        }else
                                        {
                                            break;
                                        }
                                        //每次加一个时间片
                                        beginpoint = beginpoint + equiplen;

                                    }

                                    //找到一个
                                    if(flag==true)
                                    {
                                        //找到了就可以插人了
                                        string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@task", "加速器");
                                        sqlOperation1.AddParameterWithValue("@pid", pid);
                                        sqlOperation1.AddParameterWithValue("@date",temp.ToString("yyyy-MM-dd"));
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


    //由于昨天时间安排有变动，所以得删除今天开始往后的所有预约，进行重新约
    public static void transferappointForAll()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        //第一步，数据库转移备份
        //清理数据库
        string deleteAppointCopy = "delete from appointment_accelerate_copy";
        sqlOperation.ExecuteNonQuery(deleteAppointCopy);
        string deleteTreatmentCopy = "delete from treatmentrecord_copy";
        sqlOperation.ExecuteNonQuery(deleteTreatmentCopy);



        //迁移预约表
        string transderForAppoint = "insert into appointment_accelerate_copy select * from appointment_accelerate";
        sqlOperation.ExecuteNonQuery(transderForAppoint);

        //迁移治疗表
        string transderForTreat = "INSERT into treatmentrecord_copy select * from treatmentrecord";
        sqlOperation.ExecuteNonQuery(transderForTreat);

        //删除治疗表中明天之后的信息
        string deleteTreatment = "Delete from treatmentrecord WHERE Appointment_ID in (select ID from appointment_accelerate where Date>=@maxdate)";
        sqlOperation.AddParameterWithValue("@maxdate", DateTime.Now.ToString("yyyy-MM-dd"));
        sqlOperation.ExecuteNonQuery(deleteTreatment);

        //删除预约表的所有信息
        string deleteAppoint = "DELETE from appointment_accelerate where Date>=@maxdate";
        sqlOperation.AddParameterWithValue("@maxdate", DateTime.Now.ToString("yyyy-MM-dd"));
        sqlOperation.ExecuteNonQuery(deleteAppoint);

        //查询表中最大一天是哪一天
        string maxDateAppoint = "select max(Date) from appointment_accelerate_copy";
        string maxdate = sqlOperation.ExecuteScalar(maxDateAppoint);
        DateTime maxdatetime= Convert.ToDateTime(Convert.ToDateTime(maxdate).ToString("yyyy-MM-dd"));

        //定义遍历指针
        DateTime tempDateTime=Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));

        //开始遍历整张表，查询每天的所有预约记录
        while(DateTime.Compare(tempDateTime,maxdatetime)!=1)
        {

            //查询那天有哪些病人的子计划预约
            string childdesignCom = "select treatmentrecord_copy.ChildDesign_ID as chid,treatmentrecord_copy.isfirst as isfirst,appointment_accelerate_copy.Equipment_ID as equipid,treatmentrecord_copy.ApplyUser as userid,appointment_accelerate_copy.Begin as begin,appointment_accelerate_copy.End as end,treatmentrecord_copy.ApplyTime as applytime  from appointment_accelerate_copy,treatmentrecord_copy where treatmentrecord_copy.Appointment_ID=appointment_accelerate_copy.ID and appointment_accelerate_copy.Date=@today ORDER BY appointment_accelerate_copy.Begin";
            sqlOperation.AddParameterWithValue("@today", tempDateTime);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(childdesignCom);
            while (reader.Read())
            {
               //二次检测
                string checkdouble = "select count(*) from appointment_accelerate_copy,treatmentrecord_copy where treatmentrecord_copy.Appointment_ID=appointment_accelerate_copy.ID and appointment_accelerate_copy.Date=@date and treatmentrecord_copy.ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@date", tempDateTime);
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                int resultCheckFor = int.Parse(sqlOperation1.ExecuteScalar(checkdouble));
                if (resultCheckFor == 0)
                {
                    continue;
                }
                //如果这是一条友善的首次预约，那就不处理
                if (reader["isfirst"].ToString() == "1")
                {
                    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string pid = sqlOperation1.ExecuteScalar(pidcommand);
                    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                    sqlOperation1.AddParameterWithValue("@task", "加速器");
                    sqlOperation1.AddParameterWithValue("@pid", pid);
                    sqlOperation1.AddParameterWithValue("@date", tempDateTime.ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    sqlOperation1.AddParameterWithValue("@begin", reader["begin"].ToString());
                    sqlOperation1.AddParameterWithValue("@end", reader["end"].ToString());
                    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                    sqlOperation1.AddParameterWithValue("@applytime", reader["applytime"].ToString());
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);


                    ////从那天开始往后查到一个非节假日
                    //Boolean BigFlag = true;
                    //DateTime suitTime = tempDateTime;
                    //while (BigFlag)
                    //{
                    //    string checkHoliday = "select count(*) from worktimetable where Date=@date and IsUsed=1";
                    //    sqlOperation1.AddParameterWithValue("@date", maxdatetime);
                    //    int result = int.Parse(sqlOperation1.ExecuteScalar(checkHoliday));
                    //    if (result == 0)
                    //    {
                    //        BigFlag = false;
                    //        break;
                    //    }
                    //    suitTime = suitTime.AddDays(1);
                    //}

                    ////看看今天同时间段可以不可以用
                    //string checkisfirstcommand = "SELECT count(*) from appointment_accelerate where Equipment_ID=@equip and Begin=@begin and Date=@date";
                    //sqlOperation1.AddParameterWithValue("@date", suitTime.ToString("yyyy-MM-dd"));
                    //sqlOperation1.AddParameterWithValue("@begin", reader["begin"].ToString());
                    //sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                    //int count = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommand));

                    ////已经被别人占用了
                    //if (count > 0)
                    //{
                    //    DateTime temp = suitTime;

                    //    //取库中看看首次预约的合法时间段
                    //    string firsttimecommand = "select begintime,endtime from firstacctime";
                    //    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(firsttimecommand);
                    //    ArrayList beginarray = new ArrayList();
                    //    ArrayList endarray = new ArrayList();
                    //    while (reader1.Read())
                    //    {
                    //        beginarray.Add(reader1["begintime"].ToString());
                    //        endarray.Add(reader1["endtime"].ToString());
                    //    }
                    //    reader1.Close();
                    //    int BeginFinal = 0;

                    //    //从库中取得此设备的划片时间
                    //    string equipLong = "select Timelength from equipment where ID=@equip";
                    //    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                    //    int equiplen = int.Parse(sqlOperation1.ExecuteScalar(equipLong));

                    //    //开始从今天这个时段开始往下依次查合适的时间约上去
                    //    while (true)
                    //    {
                    //        //判断这一天是否是节假日
                    //        string dayIsOkCom = "select count(*) from worktimetable where Date=@date and IsUsed=1";
                    //        sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                    //        int dayIsOk = int.Parse(sqlOperation1.ExecuteScalar(dayIsOkCom));

                    //        if (dayIsOk == 0)
                    //        {
                    //            for (int i = 0; i < beginarray.Count; i++)
                    //            {
                    //                int begintime = int.Parse(beginarray[i].ToString());
                    //                int endtime = int.Parse(endarray[i].ToString());
                    //                while (begintime < endtime)
                    //                {
                    //                    string checkisfirstcommandtemp = "SELECT count(*) from appointment_accelerate where Equipment_ID=@equip and Begin=@begin and Date=@date";
                    //                    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                    //                    sqlOperation1.AddParameterWithValue("@begin", begintime);
                    //                    sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                    //                    int counttemp = int.Parse(sqlOperation1.ExecuteScalar(checkisfirstcommandtemp));
                    //                    //依次向下逐步查询，直到合适的时间段
                    //                    if (counttemp > 0)
                    //                    {
                    //                        begintime = begintime + equiplen;
                    //                    }
                    //                    else
                    //                    {
                    //                        BeginFinal = begintime;
                    //                        break;
                    //                    }

                    //                }
                    //                if (BeginFinal != 0)
                    //                {
                    //                    break;
                    //                }

                    //            }
                    //        }

                    //        //如果今天不行就到明天呗
                    //        if (BeginFinal != 0)
                    //        {
                    //            break;
                    //        }
                    //        else
                    //        {
                    //            temp = temp.AddDays(1);
                    //        }
                    //    }

                    //    //找到了就可以插进去了
                    //    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                    //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    //    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                    //    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                    //    sqlOperation1.AddParameterWithValue("@task", "加速器");
                    //    sqlOperation1.AddParameterWithValue("@pid", pid);
                    //    sqlOperation1.AddParameterWithValue("@date", temp.ToString("yyyy-MM-dd"));
                    //    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    //    sqlOperation1.AddParameterWithValue("@begin", BeginFinal);
                    //    sqlOperation1.AddParameterWithValue("@end", BeginFinal + equiplen);
                    //    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                    //    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                    //    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                    //    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                    //    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                    //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    //    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                    //}
                    //else
                    //{
                    //    //如果这个时间段可以用那就可以用
                    //    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                    //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    //    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                    //    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                    //    sqlOperation1.AddParameterWithValue("@task", "加速器");
                    //    sqlOperation1.AddParameterWithValue("@pid", pid);
                    //    sqlOperation1.AddParameterWithValue("@date", suitTime.ToString("yyyy-MM-dd"));
                    //    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    //    sqlOperation1.AddParameterWithValue("@begin", reader["begin"].ToString());
                    //    sqlOperation1.AddParameterWithValue("@end", reader["end"].ToString());
                    //    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                    //    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                    //    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                    //    sqlOperation1.AddParameterWithValue("@applyuser", reader["userid"].ToString());
                    //    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                    //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    //    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                    //}

                    ////医师预约之前需要清除当前子计划的所有已有预约信息
                    //string selectcommand = "select treatmentrecord_copy.Appointment_ID as appointid,treatmentrecord_copy.ID as treatmentrecordid from treatmentrecord_copy,appointment_accelerate_copy where treatmentrecord_copy.Appointment_ID=appointment_accelerate_copy.ID and treatmentrecord_copy.ChildDesign_ID=@chid and appointment_accelerate_copy.Date>=@nowdate";
                    //sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    //sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                    //MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(selectcommand);
                    //ArrayList arrayforapp = new ArrayList();
                    //ArrayList arrayforapp2 = new ArrayList();
                    //ArrayList treatmentarray = new ArrayList();
                    //while (reader2.Read())
                    //{
                    //    arrayforapp.Add(reader2["appointid"].ToString());
                    //    treatmentarray.Add(reader2["treatmentrecordid"].ToString());
                    //}
                    //reader2.Close();
                    //for (int i = 0; i < arrayforapp.Count; i++)
                    //{
                    //    string isexists = "select count(*) from treatmentrecord_copy where ChildDesign_ID<>@chid and Appointment_ID=@appoint";
                    //    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    //    sqlOperation1.AddParameterWithValue("@appoint", arrayforapp[i]);
                    //    int counttemp = int.Parse(sqlOperation1.ExecuteScalar(isexists));
                    //    if (counttemp == 0)
                    //    {
                    //        arrayforapp2.Add(arrayforapp[i]);
                    //    }
                    //}
                    //for (int i = 0; i < arrayforapp2.Count; i++)
                    //{
                    //    string deletecommand = "delete from appointment_accelerate_copy where ID=@appoint";
                    //    sqlOperation1.AddParameterWithValue("@appoint", arrayforapp2[i]);
                    //    sqlOperation1.ExecuteNonQuery(deletecommand);
                    //}
                    //for (int i = 0; i < treatmentarray.Count; i++)
                    //{
                    //    string deletecommand2 = "delete from treatmentrecord_copy where ID=@tretmentid";
                    //    sqlOperation1.AddParameterWithValue("@tretmentid", treatmentarray[i]);
                    //    sqlOperation1.ExecuteNonQuery(deletecommand2);
                    //}
                }
                else
                {
                    //很明显,如果这是个普通预约，那么就要考虑的比较复杂
                    //开始查询这个子计划的所有剩余预约次数、分割方式、经常预约时间段还有其他预约信息
                    string restCountCommand = "select count(*) from treatmentrecord_copy,appointment_accelerate_copy where appointment_accelerate_copy.ID=treatmentrecord_copy.Appointment_ID and treatmentrecord_copy.ChildDesign_ID=@chid and appointment_accelerate_copy.Date>=@date";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    sqlOperation1.AddParameterWithValue("@date", tempDateTime);
                    int restCount= int.Parse(sqlOperation1.ExecuteScalar(restCountCommand));

                    string splitCommand = "select Splitway_ID from childdesign where ID=@chid";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string splitID = sqlOperation1.ExecuteScalar(splitCommand);

                    int Interal = 0, Times = 0,TimeInteral=0;
                    string splitcommand = "select Ways,Interal,Times,TimeInteral from splitway where ID=@split";
                    sqlOperation1.AddParameterWithValue("@split", splitID);
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(splitcommand);
                    if (reader1.Read())
                    {
                        Interal = int.Parse(reader1["Interal"].ToString());
                        Times = int.Parse(reader1["Times"].ToString());
                        TimeInteral = int.Parse(reader1["TimeInteral"].ToString());
                    }
                    reader1.Close();

                    string pidcommand = "select treatment.Patient_ID as pid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and childdesign.ID=@chid";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    string pid = sqlOperation1.ExecuteScalar(pidcommand);

                    string datecommand = "select DISTINCT(count(*)) as count from appointment_accelerate_copy where Patient_ID=@pid and Equipment_ID=@equipid and Date>=@todaydate GROUP BY Date ORDER BY count desc";
                    sqlOperation1.AddParameterWithValue("@pid", pid);
                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                    sqlOperation1.AddParameterWithValue("@todaydate", tempDateTime.ToString("yyyy-MM-dd"));
                    reader1 = sqlOperation1.ExecuteReader(datecommand);


                    //首先根据之前约的情况选择一些推荐的时间
                    StringBuilder info = new StringBuilder("[");
                    while (reader1.Read())
                    {
                        string timeduancommand = "select Begin,End FROM appointment_accelerate_copy where Date in (select Date from (select count(*) as number,treatmentrecord_copy.ChildDesign_ID,Date from appointment_accelerate_copy,treatmentrecord_copy where treatmentrecord_copy.Appointment_ID=appointment_accelerate_copy.ID and Date in (select Date  from (select Date,count(*) as count from appointment_accelerate_copy where Patient_ID=@pid and Equipment_ID=@equipid and Date>=@todaydate GROUP BY Date) as a where count=@count) and IsFirst!=1 and appointment_accelerate_copy.Patient_ID=@pid and appointment_accelerate_copy.Equipment_ID=@equipid GROUP BY treatmentrecord_copy.ChildDesign_ID,Date) as b where number=@count) and appointment_accelerate_copy.Patient_ID=@pid and appointment_accelerate_copy.Equipment_ID=@equipid GROUP BY Begin";
                        sqlOperation2.AddParameterWithValue("@pid", pid);
                        sqlOperation2.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                        sqlOperation2.AddParameterWithValue("@todaydate", tempDateTime.ToString("yyyy-MM-dd"));
                        sqlOperation2.AddParameterWithValue("@count", reader1["count"].ToString());
                        MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation2.ExecuteReader(timeduancommand);
                        int k = 0;
                        while (reader2.Read())
                        {
                            if (k == 0)
                            {
                                info.Append("{\"begin\":\"" + reader2["Begin"].ToString() + "\",\"end\":\"" + reader2["End"].ToString() + "\"}");
                            }
                            else
                            {
                                info.Append(",");
                                info.Append("{\"begin\":\"" + reader2["Begin"].ToString() + "\",\"end\":\"" + reader2["End"].ToString() + "\"}");
                            }
                            k++;

                        }
                        reader2.Close();
                        if (k != 0)
                        {
                            break;
                        }

                    }
                    info.Append("]");
                    reader1.Close();
                    //开始探测这些时间段
                    JArray suitableAppointPre = (JArray)JsonConvert.DeserializeObject(info.ToString());
                    int computeCount=0;

                    //平均每个时间段至少满足多少次
                    int totalEvery = restCount / Times+1;
                    int tempi = 0;
                    DateTime FirstTempDateTime = tempDateTime;
                    JArray suitableAppoint = new JArray();

                    while (true)
                    {
                        suitableAppoint.RemoveAll();
                        //复制数组
                        foreach (JObject j in suitableAppointPre)
                        {
                            suitableAppoint.Add(j);
                        }

                        while (tempi < suitableAppoint.Count)
                        {
                            //从预约那一天开始
                            DateTime tempTime = FirstTempDateTime;
                            while (true)
                            {
                                //首先判断当前天是否是工作天
                                string isWorkTimeCommand = "select count(*) from worktimetable where Date=@firstday and IsUsed=1";
                                sqlOperation1.AddParameterWithValue("@firstday", tempTime);
                                int countWork = int.Parse(sqlOperation1.ExecuteScalar(isWorkTimeCommand));
                                if (countWork == 0)
                                {
                                    string isSuitAbleCommand = "select count(*) from appointment_accelerate,treatmentrecord where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Begin=@begin and appointment_accelerate.Date=@date and appointment_accelerate.Equipment_ID=@equipid and appointment_accelerate.Patient_ID <> @pid";
                                    sqlOperation1.AddParameterWithValue("@date", tempTime);
                                    sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                                    sqlOperation1.AddParameterWithValue("@pid", pid);
                                    sqlOperation1.AddParameterWithValue("@begin", suitableAppoint[tempi]["begin"].ToString());
                                    int countres = int.Parse(sqlOperation1.ExecuteScalar(isSuitAbleCommand));
                                    if (countres == 0)
                                    {
                                        computeCount++;
                                        if (computeCount >= totalEvery)
                                        {
                                            break;
                                        }

                                    }
                                    else
                                    {
                                        break;
                                    }
                                    tempTime=tempTime.AddDays(Interal);
                                }
                                else
                                {
                                    tempTime=tempTime.AddDays(1);

                                }
                            }
                            if (computeCount < totalEvery)
                            {
                                suitableAppoint.RemoveAt(tempi);
                            }
                            else
                            {
                                tempi++;
                            }
                            computeCount = 0;
                        }

                        //判断刚刚找的参考时间是否够子计划的每天次数
                        //如果次数太多，则删除部分次数
                        if (suitableAppoint.Count > Times)
                        {
                            int pointer = 0;
                            while (pointer < suitableAppoint.Count)
                            {
                                if (pointer >= Times)
                                {
                                    suitableAppoint.RemoveAt(pointer);
                                }
                                else
                                {
                                    pointer++;
                                }

                            }
                        }

                        //如果次数不够，则再从其他时间处凑

                        if (suitableAppoint.Count < Times)
                        {

                            //查找划片长度
                            string equipLong = "select Timelength from equipment where ID=@equip";
                            sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                            int equiplen = int.Parse(sqlOperation1.ExecuteScalar(equipLong));

                            //查找每天最大预约时间
                            string maxdateEveryDay = "select EndTimeTPM from equipment where ID=@equip";
                            sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                            int todayMax = int.Parse(sqlOperation1.ExecuteScalar(maxdateEveryDay));

                            //查找每天最小预约时间
                            string mindateEveryDay = "select BeginTimeAM from equipment where ID=@equip";
                            sqlOperation1.AddParameterWithValue("@equip", reader["equipid"].ToString());
                            int todayMin = int.Parse(sqlOperation1.ExecuteScalar(mindateEveryDay));

                            //从每天的最小时间开始

                            int beginpoint = todayMin;
                            while (true)
                            {

                                //只要没有超过最晚时间
                                if (beginpoint >= todayMax)
                                {
                                    break;
                                }


                                //如果发现占用首次时间
                                string isinfirstAcc = "select count(*) from firstacctime where begintime<=@begin and endtime>@begin";
                                sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                int isinfirstAccNum = int.Parse(sqlOperation1.ExecuteScalar(isinfirstAcc));

                                if (isinfirstAccNum == 1)
                                {
                                    continue;

                                }

                                //如果与已有suitableAppoint元素重复
                                Boolean watch = false;
                                for (int index = 0; index < suitableAppoint.Count; index++)
                                {
                                    if (Math.Abs(int.Parse(suitableAppoint[index]["begin"].ToString()) - beginpoint) < TimeInteral)
                                    {
                                        watch = true;
                                        break;
                                    }
                                }

                                if (watch)
                                {
                                    continue;
                                }

                                //最后查看这个时间段有没有用

                                //从预约那一天开始
                                DateTime tempTime = tempDateTime;
                                computeCount = 0;
                                while (true)
                                {
                                    //首先判断当前天是否是工作天
                                    string isWorkTimeCommand = "select count(*) from worktimetable where Date=@firstday and IsUsed=1";
                                    sqlOperation1.AddParameterWithValue("@firstday", tempTime);
                                    int countWork = int.Parse(sqlOperation1.ExecuteScalar(isWorkTimeCommand));
                                    if (countWork == 0)
                                    {
                                        string isSuitAbleCommand = "select count(*) from appointment_accelerate,treatmentrecord where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Begin=@begin and appointment_accelerate.Date=@date and appointment_accelerate.Equipment_ID=@equipid and appointment_accelerate.Patient_ID <> @pid";
                                        sqlOperation1.AddParameterWithValue("@date", tempTime);
                                        sqlOperation1.AddParameterWithValue("@equipid", reader["equipid"].ToString());
                                        sqlOperation1.AddParameterWithValue("@pid", pid);
                                        sqlOperation1.AddParameterWithValue("@begin", beginpoint);
                                        int countres = int.Parse(sqlOperation1.ExecuteScalar(isSuitAbleCommand));
                                        if (countres == 0)
                                        {
                                            computeCount++;
                                            if (computeCount >= totalEvery)
                                            {
                                                break;
                                            }

                                        }
                                        else
                                        {
                                            break;
                                        }
                                        tempTime=tempTime.AddDays(Interal);
                                    }
                                    else
                                    {
                                        tempTime=tempTime.AddDays(1);

                                    }
                                }
                                if (computeCount < totalEvery)
                                {
                                    //加时间片
                                    beginpoint = beginpoint + equiplen;
                                    continue;
                                }
                                else
                                {
                                    string tempString = "{\"begin\":\"" + beginpoint + "\",\"end\":\"" + (beginpoint + equiplen) + "\"}";
                                    JObject array = JObject.Parse(tempString);
                                    suitableAppoint.Add(array);
                                    if (suitableAppoint.Count >= Times)
                                    {
                                        break;
                                    }
                                    //要满足时间间隔
                                    beginpoint = beginpoint + TimeInteral;
                                }

                            }
                        }

                        //如果那一天所有时间不满足，就往后推一天，直至满足
                        if (suitableAppoint.Count != Times)
                        {

                            FirstTempDateTime = FirstTempDateTime.AddDays(1);
                        }
                        else
                        {
                            break;
                        }
                    }


                    //开始预约
                    string resultFinal = begininsert(FirstTempDateTime.ToString("yyyy-MM-dd"), Interal, Times, restCount, pid, reader["equipid"].ToString(), suitableAppoint, reader["userid"].ToString(), reader["chid"].ToString());

                    if (resultFinal == "success")
                    {
                        //成功重约后删除复制表中的信息
                        string selectcommand = "select treatmentrecord_copy.Appointment_ID as appointid,treatmentrecord_copy.ID as treatmentrecordid from treatmentrecord_copy,appointment_accelerate_copy where treatmentrecord_copy.Appointment_ID=appointment_accelerate_copy.ID and treatmentrecord_copy.ChildDesign_ID=@chid and appointment_accelerate_copy.Date>=@nowdate";
                        sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                        sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                        MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(selectcommand);
                        ArrayList arrayforapp = new ArrayList();
                        ArrayList arrayforapp2 = new ArrayList();
                        ArrayList treatmentarray = new ArrayList();
                        while (reader2.Read())
                        {
                            arrayforapp.Add(reader2["appointid"].ToString());
                            treatmentarray.Add(reader2["treatmentrecordid"].ToString());
                        }
                        reader2.Close();
                        for (int i = 0; i < arrayforapp.Count; i++)
                        {
                            string isexists = "select count(*) from treatmentrecord_copy where ChildDesign_ID<>@chid and Appointment_ID=@appoint";
                            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                            sqlOperation1.AddParameterWithValue("@appoint", arrayforapp[i]);
                            int counttemp = int.Parse(sqlOperation1.ExecuteScalar(isexists));
                            if (counttemp == 0)
                            {
                                arrayforapp2.Add(arrayforapp[i]);
                            }
                        }
                        for (int i = 0; i < arrayforapp2.Count; i++)
                        {
                            string deletecommand = "delete from appointment_accelerate_copy where ID=@appoint";
                            sqlOperation1.AddParameterWithValue("@appoint", arrayforapp2[i]);
                            sqlOperation1.ExecuteNonQuery(deletecommand);
                        }
                        for (int i = 0; i < treatmentarray.Count; i++)
                        {
                            string deletecommand2 = "delete from treatmentrecord_copy where ID=@tretmentid";
                            sqlOperation1.AddParameterWithValue("@tretmentid", treatmentarray[i]);
                            sqlOperation1.ExecuteNonQuery(deletecommand2);
                        }
                    }
                }

            }
            reader.Close();
            tempDateTime = tempDateTime.AddDays(1);

        }

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


    //函数begininsert用于预约每条子计划，参数firstday子计划的开始天，patientid病人id，equipmentid设备id，getarray提供预约的时间，chid预约子计划的id
    public static string begininsert(string firstday, int Interal, int Times, int rest, string patientid, string equipmentid, JArray getarray, string userid, string chid)
    {

        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        //首先选取预约开始的时间，原则是比较提供的时间与此计划的最新预约时间，选较晚的一天   
        DateTime datefirst;
        datefirst = Convert.ToDateTime(firstday);
        //解析前端传来的参考时间段
        JArray appointarrange = getarray;
        if (rest == 0)
        {
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            return "success";
        }

        //子计划的预约时间间隔不能小于1
        if (Interal >= 1)
        {
            //tempcount是计数器，计算当前已经成功预约多少次
            int tempcount = 0;

            while (true)
            {
                //首先判断当前天是否是工作天
                string isWorkTimeCommand = "select count(*) from worktimetable where Date=@firstday and IsUsed=1";
                sqlOperation1.AddParameterWithValue("@firstday", datefirst);
                int countWork = int.Parse(sqlOperation1.ExecuteScalar(isWorkTimeCommand));

                //如果是工作天
                if (countWork == 0)
                {
                    //todaytimes计算当前天的此计划预约次数
                    int todaytimes = 0;

                    //首先判断当前天的子计划预约的次数
                    string checkcommand = "select count(*) from appointment_accelerate,treatmentrecord where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=@chid and Date=@date and Equipment_ID=@equipid";
                    sqlOperation1.AddParameterWithValue("@chid", chid);
                    sqlOperation1.AddParameterWithValue("@date", datefirst);
                    sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                    int count = int.Parse(sqlOperation1.ExecuteScalar(checkcommand));
                    todaytimes = count;

                    //如果当前天此计划的预约次数还没有超过每天此计划的预约次数上限，那么还可以继续预约
                    if (todaytimes < Times)
                    {
                        //如果当前天此计划一次没有预约
                        if (todaytimes == 0)
                        {
                            //先查询当前天此病人有哪些预约（其他子计划）用以复用，appointidlist用以存储id，beginlist用以存储begin
                            ArrayList appointidlist = new ArrayList();
                            ArrayList beginlist = new ArrayList();
                            string patientcommand = "select ID,Begin from appointment_accelerate where Date=@date and Equipment_ID=@equipid and Patient_ID=@pid";
                            sqlOperation1.AddParameterWithValue("@date", datefirst);
                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                            sqlOperation1.AddParameterWithValue("@pid", patientid);
                            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(patientcommand);
                            while (reader1.Read())
                            {
                                appointidlist.Add(reader1["ID"].ToString());
                                beginlist.Add(reader1["Begin"].ToString());

                            }
                            reader1.Close();

                            //如果当前天此病人没有预约
                            if (appointidlist.Count == 0)
                            {
                                //全部采用提供的参考时间段进行预约
                                for (int i = 0; i < Times; i++)
                                {
                                    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@task", "加速器");
                                    sqlOperation1.AddParameterWithValue("@pid", patientid);
                                    sqlOperation1.AddParameterWithValue("@date", datefirst);
                                    sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                    sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                                    sqlOperation1.AddParameterWithValue("@end", appointarrange[i]["end"].ToString());
                                    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                    sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                    sqlOperation1.AddParameterWithValue("@chid", chid);
                                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);

                                    tempcount = tempcount + 1;

                                    //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                    if (tempcount >= rest)
                                    {
                                        sqlOperation.Close();
                                        sqlOperation.Dispose();
                                        sqlOperation = null;
                                        sqlOperation1.Close();
                                        sqlOperation1.Dispose();
                                        sqlOperation1 = null;
                                        sqlOperation2.Close();
                                        sqlOperation2.Dispose();
                                        sqlOperation2 = null;
                                        return "success";
                                    }
                                    todaytimes++;

                                }
                            }
                            else
                            {
                                //因为当前天此病人有预约信息，可以复用，开始遍历
                                for (int i = 0; i < appointidlist.Count; i++)
                                {
                                    //判断这个时间段是否首次预约
                                    string isfirstcommand = "select count(*) from treatmentrecord where Appointment_ID=@appointid and IsFirst=1";
                                    sqlOperation1.AddParameterWithValue("@appointid", appointidlist[i]);
                                    int num = int.Parse(sqlOperation1.ExecuteScalar(isfirstcommand));

                                    //如果不是，则IsFirst插为0
                                    if (num == 0)
                                    {
                                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@appoint", appointidlist[i]);
                                        sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                        sqlOperation1.AddParameterWithValue("@chid", chid);
                                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                        tempcount = tempcount + 1;

                                        //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                        if (tempcount >= rest)
                                        {
                                            sqlOperation.Close();
                                            sqlOperation.Dispose();
                                            sqlOperation = null;
                                            sqlOperation1.Close();
                                            sqlOperation1.Dispose();
                                            sqlOperation1 = null;
                                            sqlOperation2.Close();
                                            sqlOperation2.Dispose();
                                            sqlOperation2 = null;
                                            return "success";
                                        }
                                        todaytimes++;

                                        //如果这一次预约成功后，今天总次数已经满足，则当前天结束
                                        if (todaytimes >= Times)
                                        {
                                            break;
                                        }


                                    }
                                    else
                                    {
                                        //如果是，则IsFirst插为2，表示此子计划与首次合并完成
                                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,2,@chid);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@appoint", appointidlist[i]);
                                        sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                        sqlOperation1.AddParameterWithValue("@chid", chid);
                                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                        tempcount = tempcount + 1;

                                        //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                        if (tempcount >= rest)
                                        {
                                            sqlOperation.Close();
                                            sqlOperation.Dispose();
                                            sqlOperation = null;
                                            sqlOperation1.Close();
                                            sqlOperation1.Dispose();
                                            sqlOperation1 = null;
                                            sqlOperation2.Close();
                                            sqlOperation2.Dispose();
                                            sqlOperation2 = null;
                                            return "success";
                                        }
                                        todaytimes++;

                                        //如果这一次预约成功后，今天总次数已经满足，则当前天结束
                                        if (todaytimes >= Times)
                                        {
                                            break;
                                        }

                                    }

                                }

                                //如果当前天的病人预约次数不能够满足此计划的预约次数，即覆盖不了
                                if (appointidlist.Count < Times)
                                {
                                    int k = 0;

                                    //开始从提供的参考时间段开始选择，但是选的时间不能与病人今天其他的预约时间重叠
                                    for (int j = 0; j < appointarrange.Count; j++)
                                    {
                                        Boolean flag = false;
                                        for (int m = 0; m < appointidlist.Count; m++)
                                        {
                                            if (beginlist[m].ToString() == appointarrange[j]["begin"].ToString())
                                            {
                                                flag = true;
                                                break;
                                            }

                                        }

                                        //如果选到一个与所有其他预约时间不重叠的好时间则开始预约
                                        if (flag == false)
                                        {
                                            string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                            sqlOperation1.AddParameterWithValue("@task", "加速器");
                                            sqlOperation1.AddParameterWithValue("@pid", patientid);
                                            sqlOperation1.AddParameterWithValue("@date", datefirst);
                                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                            sqlOperation1.AddParameterWithValue("@begin", appointarrange[j]["begin"].ToString());
                                            sqlOperation1.AddParameterWithValue("@end", appointarrange[j]["end"].ToString());
                                            string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                            sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                            sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                            sqlOperation1.AddParameterWithValue("@chid", chid);
                                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                            tempcount = tempcount + 1;
                                            //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                            if (tempcount >= rest)
                                            {
                                                sqlOperation.Close();
                                                sqlOperation.Dispose();
                                                sqlOperation = null;
                                                sqlOperation1.Close();
                                                sqlOperation1.Dispose();
                                                sqlOperation1 = null;
                                                sqlOperation2.Close();
                                                sqlOperation2.Dispose();
                                                sqlOperation2 = null;
                                                return "success";
                                            }
                                            todaytimes++;
                                            k++;


                                        }

                                        //如果今天的次数已经到达上限则可以结束预约
                                        if (k >= Times - appointidlist.Count)
                                        {
                                            break;
                                        }

                                    }

                                }


                            }

                        }
                        else
                        {
                            //如果此子计划今天已有部分预约,则先计算今天此计划还能预约多少次，这种情况只会是今天只有首次预约
                            int resttimes = Times - todaytimes;

                            string firsbegincommand = "select Begin from appointment_accelerate,treatmentrecord where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.IsFirst=1 and treatmentrecord.ChildDesign_ID=@chid and Date=@date and Equipment_ID=@equipid";
                            sqlOperation1.AddParameterWithValue("@chid", chid);
                            sqlOperation1.AddParameterWithValue("@date", datefirst);
                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                            string firstbegintime = sqlOperation1.ExecuteScalar(firsbegincommand);

                            //预约剩余的当前天次数
                            for (int i = 0; i < appointarrange.Count; i++)
                            {

                                if (int.Parse(appointarrange[i]["begin"].ToString()) > int.Parse(firstbegintime))
                                {
                                    string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@task", "加速器");
                                    sqlOperation1.AddParameterWithValue("@pid", patientid);
                                    sqlOperation1.AddParameterWithValue("@date", datefirst);
                                    sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                    sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                                    sqlOperation1.AddParameterWithValue("@end", appointarrange[i]["end"].ToString());
                                    string insertid = sqlOperation1.ExecuteScalar(insertappoint);

                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                    sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                    sqlOperation1.AddParameterWithValue("@chid", chid);
                                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                    tempcount = tempcount + 1;

                                    //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                    if (tempcount >= rest)
                                    {
                                        sqlOperation.Close();
                                        sqlOperation.Dispose();
                                        sqlOperation = null;
                                        sqlOperation1.Close();
                                        sqlOperation1.Dispose();
                                        sqlOperation1 = null;
                                        sqlOperation2.Close();
                                        sqlOperation2.Dispose();
                                        sqlOperation2 = null;
                                        return "success";
                                    }
                                    todaytimes++;
                                    //如果今天的次数已经到达上限则可以结束预约
                                    if (todaytimes >= Times)
                                    {
                                        break;
                                    }
                                }
                            }
                            todaytimes = Times;

                        }

                    }

                    //如果今天的次数还不够上限则可以告诉前台此次预约不成功
                    if (todaytimes < Times)
                    {
                        sqlOperation.Close();
                        sqlOperation.Dispose();
                        sqlOperation = null;
                        sqlOperation1.Close();
                        sqlOperation1.Dispose();
                        sqlOperation1 = null;
                        sqlOperation2.Close();
                        sqlOperation2.Dispose();
                        sqlOperation2 = null;
                        return "failure";
                    }

                    //预约成功加间隔
                    datefirst = datefirst.AddDays(Interal);

                }
                else
                {
                 
                    datefirst = datefirst.AddDays(1);

                }
                if (tempcount >= rest)
                {
                    break;
                }

            }
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            return "success";
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        return "success";

    }
}