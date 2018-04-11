<%@ WebHandler Language="C#" Class="InsertAllappointment" %>

using System;
using System.Web;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class InsertAllappointment : IHttpHandler {
    //appointarray,treatmentrecordarray用来存储操作记录便于回退
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    ArrayList appointarray = new ArrayList();
    ArrayList treatmentrecordarray = new ArrayList();
    static Object locker = new Object();
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = inesertallapoint(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string inesertallapoint(HttpContext context)
    {
        lock (locker)
        {
            string type = context.Request["type"];
            //type=0表示技师预约
            if (type == "0")
            {
                string getstring = context.Request["data"];
                //string getstring = "{\"begindate\": \"2018-1-29\",\"patientid\": \"44\",\"chidgroup\": [1,2,3],\"userid\": \"9\",\"equipmentid\": \"18\",\"appointrange\": [{\"begin\": \"360\",\"end\": \"370\"}, {\"begin\": \"1440\",\"end\": \"1450\"}]}";
                JObject getarray = JObject.Parse(getstring);
                string begindate = getarray["begindate"].ToString();
                string patientid = getarray["patientid"].ToString();
                string userid = getarray["userid"].ToString();
                string equipmentid = getarray["equipmentid"].ToString();
                JArray chidarray = (JArray)JsonConvert.DeserializeObject(getarray["chidgroup"].ToString());
                
                //查询出所有此病人的在执行子计划
                string designcommand = "select childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state=3";
                sqlOperation.AddParameterWithValue("@pid", patientid);
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(designcommand);
                while (reader.Read())
                {
                    //如果此计划在前端技师选择范围里则执行预约，否则不执行预约
                    if (!Containschid(chidarray, reader["chid"].ToString()))
                    {
                        continue;
                    }
                    //开始从数据库中调取每条子计划的预约时间信息，例如时间间隔Interal，每天次数Times，剩余预约次数rest
                    int Interal = 0, Times = 0, rest = 0;
                    string splitcommand = "select Ways,Interal,Times from splitway where ID=@split";
                    sqlOperation1.AddParameterWithValue("@split", reader["splitway"].ToString());
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(splitcommand);
                    if (reader1.Read())
                    {
                        Interal = int.Parse(reader1["Interal"].ToString());
                        Times = int.Parse(reader1["Times"].ToString());
                    }
                    reader1.Close();
                    int count = 0;
                    int appointid = 0;
                    string maxdate = "无";
                    string date = "";
                    string begin = "";
                    
                    //查询此条子计划在库中最靠后的预约时间maxdate
                    string sqlcommand2 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and Date>=@nowdate order by Date desc,Begin desc";
                    sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    sqlOperation1.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                    reader1 = sqlOperation1.ExecuteReader(sqlcommand2);
                    while (reader1.Read())
                    {
                        if (reader1["Treat_User_ID"].ToString() == "")
                        {
                            //appointid = int.Parse(reader1["Appointment_ID"].ToString());
                            if (maxdate == "无")
                            {
                                maxdate = reader1["Date"].ToString();
                            }

                        }
                        count++;
                    }
                    reader1.Close();
                    string sqlcommand = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and Date<@nowdate order by Date desc,Begin desc";
                    reader1 = sqlOperation1.ExecuteReader(sqlcommand);
                    while (reader1.Read())
                    {
                        if (reader1["Treat_User_ID"].ToString() != "")
                        {
                            appointid = int.Parse(reader1["Appointment_ID"].ToString());
                            date = reader1["Date"].ToString();
                            begin = reader1["Begin"].ToString();
                            break;
                        }
                    }
                    reader1.Close();
                    if (appointid != 0)
                    {
                        string sqlcommand1 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and (Date<@date or (Date=@date and Begin<=@begin)) order by Date,Begin asc";
                        sqlOperation1.AddParameterWithValue("@date", date);
                        sqlOperation1.AddParameterWithValue("@begin", begin);
                        reader1 = sqlOperation1.ExecuteReader(sqlcommand1);
                        while (reader1.Read())
                        {
                            if (reader1["Treat_User_ID"].ToString() != "")
                            {
                                count++;
                            }

                        }
                        reader1.Close();
                    }
                    rest = int.Parse(reader["total"].ToString()) - count;
                    string firstdaycommand = "select Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and IsFirst=1 order by Date desc,Begin desc";
                    sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                    reader1 = sqlOperation1.ExecuteReader(firstdaycommand);
                    string firstday="";
                    string firstbegin="";
                    if (reader1.Read())
                    {
                        firstday = reader1["Date"].ToString();
                        firstbegin = reader1["Begin"].ToString();
                    }
                    reader1.Close();
                    //开始执行此计划的预约
                    string result = begininsert(firstday,firstbegin,Interal,Times,rest,begindate,patientid,equipmentid,getarray,userid,reader["chid"].ToString());
                   //如果计划失败则回退之前的操作
                    if (result == "failure")
                    {
                        deleteallappoint(appointarray, treatmentrecordarray);
                        return "failure";
                    }

                }
                reader.Close();

                //构造刚刚预约的信息backinfo给前端显示，判断是否需要立即撤销
                StringBuilder backstring = new StringBuilder("{\"backinfo\":[");
                string str = string.Join(",", (string[])treatmentrecordarray.ToArray(typeof(string)));
                string str2 = string.Join(",", (string[])appointarray.ToArray(typeof(string)));
                if (str != "")
                {
                    string selectcomandforback = "select treatment.Treatmentdescribe as treat,childdesign.DesignName as designname,appointment_accelerate.Date as appointdate,appointment_accelerate.Begin as begintime,appointment_accelerate.End as endtime from treatmentrecord,appointment_accelerate,childdesign,treatment where childdesign.Treatment_ID=treatment.ID and treatmentrecord.ChildDesign_ID=childdesign.ID and treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ID in (" + str + ") ORDER BY Date asc,Begin asc";
                    reader = sqlOperation.ExecuteReader(selectcomandforback);
                    string tempdate = "";
                    string begintemp = "";
                    int kou = 0;
                    int ku = 0;
                    while (reader.Read())
                    {
                        if (tempdate != reader["appointdate"].ToString() || begintemp != reader["begintime"].ToString())
                        {
                            ku = 0;
                            if (kou == 0)
                            {
                                backstring.Append("{\"date\":\"" + reader["appointdate"].ToString() + "\",\"begin\":\"" + reader["begintime"].ToString() + "\",\"end\":\"" + reader["endtime"].ToString() + "\",\"chidinfogroup\":[");
                            }
                            else
                            {
                                backstring.Append("]},");
                                backstring.Append("{\"date\":\"" + reader["appointdate"].ToString() + "\",\"begin\":\"" + reader["begintime"].ToString() + "\",\"end\":\"" + reader["endtime"].ToString() + "\",\"chidinfogroup\":[");
                            }

                            backstring.Append("{\"designname\":\"" + reader["designname"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treat"].ToString() + "\"}");
                            ku++;
                        }
                        else
                        {
                            if (ku == 0)
                            {
                                backstring.Append("{\"designname\":\"" + reader["designname"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treat"].ToString() + "\"}");
                            }
                            else
                            {
                                backstring.Append(",");
                                backstring.Append("{\"designname\":\"" + reader["designname"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treat"].ToString() + "\"}");

                            }
                            ku++;
                        }
                        kou++;
                        tempdate = reader["appointdate"].ToString();
                        begintemp = reader["begintime"].ToString();
                    }
                    backstring.Append("]}],\"appointarray\":\"" + str2 + "\",\"treatmentrecordarray\":\"" + str + "\"}");
                    return backstring.ToString();
                }
                else
                {
                    backstring.Append("],\"appointarray\":\"" + str2 + "\",\"treatmentrecordarray\":\"" + str + "\"}");
                    return backstring.ToString();

                }

            }

            //医师预约type=1
            if (type == "1")
            {

                string chid = context.Request["chid"];
                string date = context.Request["date"];
                string begin = context.Request["begin"];
                string end = context.Request["end"];
                string patientID = context.Request["pid"];
                string equipid = context.Request["equip"];
                string userid = context.Request["userid"];
                
                //医师预约之前需要清除当前子计划的所有已有预约信息
                string selectcommand = "select treatmentrecord.Appointment_ID as appointid,treatmentrecord.ID as treatmentrecordid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and ChildDesign_ID=@chid and Treat_User_ID is NULL and Date>=@nowdate";
                sqlOperation.AddParameterWithValue("@chid", chid);
                sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectcommand);
                ArrayList arrayforapp = new ArrayList();
                ArrayList arrayforapp2 = new ArrayList();
                ArrayList treatmentarray = new ArrayList();
                while (reader.Read())
                {
                    arrayforapp.Add(reader["appointid"].ToString());
                    treatmentarray.Add(reader["treatmentrecordid"].ToString());
                }
                reader.Close();
                for (int i = 0; i < arrayforapp.Count; i++)
                {
                    string isexists = "select count(*) from treatmentrecord where ChildDesign_ID<>@chid and Appointment_ID=@appoint";
                    sqlOperation.AddParameterWithValue("@chid", chid);
                    sqlOperation.AddParameterWithValue("@appoint", arrayforapp[i]);
                    int count = int.Parse(sqlOperation.ExecuteScalar(isexists));
                    if (count == 0)
                    {
                        arrayforapp2.Add(arrayforapp[i]);
                    }
                }
                for (int i = 0; i < arrayforapp2.Count; i++)
                {
                    string deletecommand = "delete from appointment_accelerate where ID=@appoint";
                    sqlOperation.AddParameterWithValue("@appoint", arrayforapp2[i]);
                    sqlOperation.ExecuteNonQuery(deletecommand);
                }
                for (int i = 0; i < treatmentarray.Count; i++)
                {
                    string deletecommand2 = "delete from treatmentrecord where ID=@tretmentid";
                    sqlOperation.AddParameterWithValue("@tretmentid", treatmentarray[i]);
                    sqlOperation.ExecuteNonQuery(deletecommand2);
                }

                //预约时操作appointment_accelerate，treatmentrecord两张表
                string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                sqlOperation.AddParameterWithValue("@task", "加速器");
                sqlOperation.AddParameterWithValue("@pid", patientID);
                sqlOperation.AddParameterWithValue("@date", date);
                sqlOperation.AddParameterWithValue("@equipid", equipid);
                sqlOperation.AddParameterWithValue("@begin", begin);
                sqlOperation.AddParameterWithValue("@end", end);
                string insertid = sqlOperation.ExecuteScalar(insertappoint);

                string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,1,@chid);select @@IDENTITY";
                sqlOperation.AddParameterWithValue("@appoint", insertid);
                sqlOperation.AddParameterWithValue("@applyuser", userid);
                sqlOperation.AddParameterWithValue("@applytime", DateTime.Now);
                sqlOperation.AddParameterWithValue("@chid", chid);
                string treatmentrecordid = sqlOperation.ExecuteScalar(insertcommand);
                return "success";
            }
            
            //撤销刚刚的预约信息，type=3
            if (type == "3")
            {
                string appointarray = context.Request["appointarray"];
                string treatmentrecordarray = context.Request["treatmentrecordarray"];
                Array a=appointarray.Split(new char[]{','});
                Array b = treatmentrecordarray.Split(new char[] { ',' });
                ArrayList appoint = new ArrayList(a);
                ArrayList treament = new ArrayList(b);
                deleteallappoint(appoint, treament);
            }
            return "success";
        }


    }
    //函数begininsert用于每条子计划的预约，参数firstday子计划的最后预约一天，firstbegin子计划的最新预约时间，patientid病人id，equipmentid设备id，getarray提供预约的时间，chid预约子计划的id
    private string begininsert(string firstday, string firstbegin,int Interal,int Times,int rest,string begindate,string patientid,string equipmentid,JObject getarray,string userid,string chid)
    {
     
        //首先选取预约开始的时间，原则是比较提供的时间与此计划的最新预约时间，选较晚的一天   
        DateTime datefirst;
        if (rest == 0)
        {
            return "success";
        }
        if (firstday != "")
        {
            DateTime onedatefirst = Convert.ToDateTime(begindate);
            DateTime otherfirstday = Convert.ToDateTime(firstday);
            if (DateTime.Compare(onedatefirst, otherfirstday) == 1)
            {
                datefirst = onedatefirst;

            }
            else
            {
                datefirst = otherfirstday;
            }
        }
        else
        {
             datefirst = Convert.ToDateTime(begindate);
        }
        
        //解析前端传来的参考时间段
        JArray appointarrange = (JArray)JsonConvert.DeserializeObject(getarray["appointrange"].ToString());
        if (rest == 0)
        {
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
                                    //查看此字段是否在库中可用，是否存在已经被他人占有
                                    string judgePanduan = "select count(*) from appointment_accelerate where Date=@date and Equipment_ID=@equipid and  Begin=@begin and  End=@end";
                                    sqlOperation1.AddParameterWithValue("@date", datefirst);
                                    sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                    sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                                    sqlOperation1.AddParameterWithValue("@end", appointarrange[i]["end"].ToString());
                                    int countZhan = int.Parse(sqlOperation1.ExecuteScalar(judgePanduan));

                                    if (countZhan == 0)
                                    {
                                        string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@task", "加速器");
                                        sqlOperation1.AddParameterWithValue("@pid", patientid);
                                        sqlOperation1.AddParameterWithValue("@date", datefirst);
                                        sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                        sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                                        sqlOperation1.AddParameterWithValue("@end", appointarrange[i]["end"].ToString());
                                        string insertid = sqlOperation1.ExecuteScalar(insertappoint);
                                        appointarray.Add(insertid);

                                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                        sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                        sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                        sqlOperation1.AddParameterWithValue("@chid", chid);
                                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                        treatmentrecordarray.Add(treatmentrecordid);
                                        tempcount = tempcount + 1;

                                        //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                        if (tempcount >= rest)
                                        {
                                            return "success";
                                        }
                                        todaytimes++;
                                        
                                    } 
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
                                        treatmentrecordarray.Add(treatmentrecordid);
                                        tempcount = tempcount + 1;

                                        //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                        if (tempcount >= rest)
                                        {
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
                                        treatmentrecordarray.Add(treatmentrecordid);
                                        tempcount = tempcount + 1;

                                        //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                        if (tempcount >= rest)
                                        {
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
                                           
                                             //查看此字段是否在库中可用，是否存在已经被他人占有
                                            string judgePanduan = "select count(*) from appointment_accelerate where Date=@date and Equipment_ID=@equipid and  Begin=@begin and  End=@end";
                                            sqlOperation1.AddParameterWithValue("@date", datefirst);
                                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                            sqlOperation1.AddParameterWithValue("@begin", appointarrange[j]["begin"].ToString());
                                            sqlOperation1.AddParameterWithValue("@end", appointarrange[j]["end"].ToString());
                                            int countZhan = int.Parse(sqlOperation1.ExecuteScalar(judgePanduan));

                                            if (countZhan == 0)
                                            {
                                                string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                                                sqlOperation1.AddParameterWithValue("@task", "加速器");
                                                sqlOperation1.AddParameterWithValue("@pid", patientid);
                                                sqlOperation1.AddParameterWithValue("@date", datefirst);
                                                sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                                sqlOperation1.AddParameterWithValue("@begin", appointarrange[j]["begin"].ToString());
                                                sqlOperation1.AddParameterWithValue("@end", appointarrange[j]["end"].ToString());
                                                string insertid = sqlOperation1.ExecuteScalar(insertappoint);
                                                appointarray.Add(insertid);

                                                string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                                sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                                sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                                sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                                sqlOperation1.AddParameterWithValue("@chid", chid);
                                                string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                                treatmentrecordarray.Add(treatmentrecordid);
                                                tempcount = tempcount + 1;
                                                //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                                if (tempcount >= rest)
                                                {
                                                    return "success";
                                                }
                                                todaytimes++;
                                                k++;
                                            }
                                           
                                                
                                        }
                                        
                                        //如果今天的次数已经到达上限则可以结束预约
                                        if (k >= Times - appointidlist.Count)
                                        {
                                            break;
                                        }
                                            
                                    }
                     
                                   }
                                    
                                    
                                }
                                
                            }else
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
                                    //查看此字段是否在库中可用，是否存在已经被他人占有
                                    string judgePanduan = "select count(*) from appointment_accelerate where Date=@date and Equipment_ID=@equipid and  Begin=@begin and  End=@end";
                                    sqlOperation1.AddParameterWithValue("@date", datefirst);
                                    sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                    sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                                    sqlOperation1.AddParameterWithValue("@end", appointarrange[i]["end"].ToString());
                                    int countZhan = int.Parse(sqlOperation1.ExecuteScalar(judgePanduan));

                                    if (countZhan == 0)
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
                                            appointarray.Add(insertid);

                                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                            sqlOperation1.AddParameterWithValue("@appoint", insertid);
                                            sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now);
                                            sqlOperation1.AddParameterWithValue("@chid", chid);
                                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                            treatmentrecordarray.Add(treatmentrecordid);
                                            tempcount = tempcount + 1;

                                            //如果这一次预约成功后，总次数已经满足，则可以返回成功
                                            if (tempcount >= rest)
                                            {
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
                                }
                               todaytimes = Times; 

                          }

                    }

                    //如果今天的次数还不够上限则可以告诉前台此次预约不成功
                    if(todaytimes<Times)
                    {
                        return "failure";
                    }
                    
                    //预约成功加间隔
                    datefirst = datefirst.AddDays(Interal);
                    
                }
                else
                {
                    //if(Interal==1)
                    //{ 
                    //    datefirst = datefirst.AddDays(1);
                    //}else
                    //{
                    //     if (datefirst.DayOfWeek.ToString() == "Sunday")
                    //    {
                    //        datefirst = datefirst.AddDays(1);
                    //    }
                    //    else
                    //    {
                    //        datefirst = datefirst.AddDays(2);
                    //    }
                        datefirst = datefirst.AddDays(1);
                    
   
                }
                if (tempcount >= rest)
                {
                    break;
                }

            }
                   return "success";
        }
       
        return "failure";

    }
    
    //删除当前预约
    private void deleteallappoint(ArrayList appointarray, ArrayList treatmentrecordarray)
    {
        for (int i = appointarray.Count - 1; i >= 0; i--)
        {
            string deleteappoint = "delete from appointment_accelerate where ID=@aid";
            sqlOperation1.AddParameterWithValue("@aid", appointarray[i]);
            sqlOperation1.ExecuteNonQuery(deleteappoint);
        }
        for (int i = treatmentrecordarray.Count - 1; i >= 0; i--)
        {
            string deleteappoint = "delete from treatmentrecord where ID=@tid";
            sqlOperation1.AddParameterWithValue("@tid", treatmentrecordarray[i]);
            sqlOperation1.ExecuteNonQuery(deleteappoint);
        }
      
    }    
    
    //判断数组是否包含某元素 
    private Boolean Containschid(JArray chidarray, string chid)
    {
        foreach (int id in chidarray)
        {
            if (id.ToString() == chid)
            {
                return true;
            }

        }
        return false;
    }

}