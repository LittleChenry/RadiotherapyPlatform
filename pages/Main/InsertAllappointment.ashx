<%@ WebHandler Language="C#" Class="InsertAllappointment" %>

using System;
using System.Web;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class InsertAllappointment : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    ArrayList appointarray = new ArrayList();
    ArrayList treatmentrecordarray = new ArrayList();
    ArrayList resetappointarray = new ArrayList();
    ArrayList resetbeginarray = new ArrayList();
    ArrayList resetendarray = new ArrayList();
    ArrayList resetpidarray = new ArrayList();
    ArrayList resettreatmentIDarray = new ArrayList();
    ArrayList resettreatmentAPParray = new ArrayList();
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
        //string getstring = context.Request["data"];
        string getstring = "{\"begindate\": \"2018-1-29\",\"patientid\": \"44\",\"chidgroup\": [1,2,3],\"userid\": \"9\",\"equipmentid\": \"24\",\"appointrange\": [{\"begin\": \"360\",\"end\": \"370\"}, {\"begin\": \"1440\",\"end\": \"1450\"}]}";
        JObject getarray = JObject.Parse(getstring);
        string begindate = getarray["begindate"].ToString();
        string patientid = getarray["patientid"].ToString();
        string userid = getarray["userid"].ToString();
        string equipmentid = getarray["equipmentid"].ToString();
        JArray chidarray= (JArray)JsonConvert.DeserializeObject(getarray["chidgroup"].ToString());
        lock (locker)
        {
            string designcommand = "select childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state=3";
            sqlOperation.AddParameterWithValue("@pid", patientid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(designcommand);
            while (reader.Read())
            {
                if (!Containschid(chidarray,reader["chid"].ToString()))
               {
                   continue;
               }
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
                string sqlcommand2 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date>@nowdate) or((Date=@nowdate)and Begin>@nowbegin)) order by Date desc,Begin desc";
                sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
                sqlOperation1.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                reader1 = sqlOperation1.ExecuteReader(sqlcommand2);
                while (reader1.Read())
                {
                    if (reader1["Treat_User_ID"].ToString() == "")
                    {
                        appointid = int.Parse(reader1["Appointment_ID"].ToString());
                        if (maxdate == "无")
                        {
                            maxdate = reader1["Date"].ToString();
                        }

                    }
                    count++;
                }
                reader1.Close();
                string sqlcommand = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date<@nowdate) or((Date=@nowdate)and Begin<@nowbegin)) order by Date desc,Begin desc";
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
                string result = begininsert(Interal, Times, rest, begindate, patientid, equipmentid, getarray, userid, reader["chid"].ToString());
                if (result == "failure")
                {
                    deleteallappoint(appointarray, treatmentrecordarray, resetappointarray, resetbeginarray, resetendarray, resettreatmentIDarray, resettreatmentAPParray);
                    return "failure";
                }

            } 
            reader.Close();
        }
        return "success";
       
    }
    private string begininsert(int Interal, int Times, int rest, string begindate, string patientid, string equipmentid, JObject getarray,string userid,string chid)
    {
        DateTime datefirst = Convert.ToDateTime(begindate);
        JArray appointarrange = (JArray)JsonConvert.DeserializeObject(getarray["appointrange"].ToString());
        if (rest == 0)
        {
            return "success";
        }
        
        if (Interal == 1)
        {
            int tempcount = 0;
            while (true)
            {
                if (datefirst.DayOfWeek.ToString() != "Sunday" && datefirst.DayOfWeek.ToString() != "Saturday")
                {
                     ArrayList templist=new ArrayList();
                     ArrayList beginlist=new ArrayList();

                    string checkcommand = "select ID,Begin from appointment_accelerate where Date=@date and ((Date>@nowdate) or((Date=@nowdate)and Begin>@nowbegin)) and Equipment_ID=@equipid and Patient_ID=@pid";
                    sqlOperation1.AddParameterWithValue("@date",datefirst);
                    sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                    sqlOperation1.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                    sqlOperation1.AddParameterWithValue("@pid", patientid);
                    sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(checkcommand);
                    while (reader1.Read())
                    {
                        templist.Add(reader1["ID"].ToString());
                        beginlist.Add(reader1["Begin"].ToString());
                    }
                    reader1.Close();
                    if (templist.Count >= Times)
                    {
                        ArrayList unusechidlist = new ArrayList();
                        for (int i = 0; i < templist.Count; i++)
                        {
                            string childdesigncount = "select count(*) from treatmentrecord where Treat_User_ID is NULL and Appointment_ID=@aid and ChildDesign_ID=@chid";
                            sqlOperation1.AddParameterWithValue("@aid", templist[i]);
                            sqlOperation1.AddParameterWithValue("@chid", chid);
                            int has = int.Parse(sqlOperation1.ExecuteScalar(childdesigncount));
                            if (has == 0)
                            {
                                unusechidlist.Add(templist[i]);
                            }
                        }
                        if (templist.Count - unusechidlist.Count >= Times)
                        {
                            continue;
                        }
                        for (int l = 0; l < Times - templist.Count + unusechidlist.Count;l++)
                        {
                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@appoint", unusechidlist[l]);
                            sqlOperation1.AddParameterWithValue("@applyuser", userid);
                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now.Date.ToString());
                            sqlOperation1.AddParameterWithValue("@chid", chid);
                            string treatmentrecordid=sqlOperation1.ExecuteScalar(insertcommand);
                            treatmentrecordarray.Add(treatmentrecordid);
                            tempcount = tempcount + 1;
                            if (tempcount >= rest)
                            {
                                return "success";
                            }
                        }
                     }
                    else
                    {
                        int countfortimes=0;
                        ArrayList useappoint = new ArrayList();
                        for (int i = 0; i < appointarrange.Count; i++)
                        {
                            string busycommand = "select count(*) from appointment_accelerate where Date=@date and (Patient_ID<>@pid and Patient_ID is not null) and Begin=@begin and Equipment_ID=@equipid";
                            sqlOperation1.AddParameterWithValue("@date", datefirst);
                            sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                            sqlOperation1.AddParameterWithValue("@pid", patientid);
                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                            int result = int.Parse(sqlOperation1.ExecuteScalar(busycommand));
                            if (result == 0)
                            {
                                string chiddesigncommand = "select count(*) from appointment_accelerate,treatmentrecord where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=@chid and Date=@date and Begin=@begin and Equipment_ID=@equipid";
                                sqlOperation1.AddParameterWithValue("@date", datefirst);
                                sqlOperation1.AddParameterWithValue("@chid", chid);
                                sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                                sqlOperation1.AddParameterWithValue("@pid", patientid);
                                sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                int result2 = int.Parse(sqlOperation1.ExecuteScalar(chiddesigncommand));
                                if (result2 == 0)
                                {
                                    useappoint.Add(appointarrange[i]["begin"].ToString());
                                }
                                
                            }
                        }
                        if (useappoint.Count < Times)
                        {
                            return "failure";
                        }
                        for (int i = 0; i < templist.Count; i++)
                        {
                            string selectcommand = "select Begin,End,ID,Patient_ID from appointment_accelerate where ID=@id";
                            sqlOperation1.AddParameterWithValue("@id", templist[i]);
                            reader1 = sqlOperation1.ExecuteReader(selectcommand);
                            while (reader1.Read())
                            {
                                resetappointarray.Add(reader1["ID"].ToString());
                                resetbeginarray.Add(reader1["Begin"].ToString());
                                resetendarray.Add(reader1["End"].ToString());
                                resetpidarray.Add(reader1["Patient_ID"].ToString());
                            }
                            reader1.Close();
                            string childdesigncount = "select count(*) from treatmentrecord where treat_user_id is null and appointment_id=@aid and childdesign_id=@chid";
                            sqlOperation1.AddParameterWithValue("@aid", templist[i]);
                            sqlOperation1.AddParameterWithValue("@chid", chid);
                            int has = int.Parse(sqlOperation1.ExecuteScalar(childdesigncount));
                            if (has != 0)
                            {
                                string isexist = "select ID from appointment_accelerate where Date=@date and Begin=@begin and Equipment_ID=@equipid";
                                sqlOperation1.AddParameterWithValue("@date", datefirst);
                                sqlOperation1.AddParameterWithValue("@begin", useappoint[i].ToString());
                                sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                string result = sqlOperation1.ExecuteScalar(isexist);
                                if (result == "")
                                {
                                    string updatecommand = "update appointment_accelerate set Begin=@begin,End=@end where ID=@id";
                                    sqlOperation1.AddParameterWithValue("@begin", useappoint[i].ToString());
                                    sqlOperation1.AddParameterWithValue("@end", int.Parse(useappoint[i].ToString()) + 10);
                                    sqlOperation1.AddParameterWithValue("@id", templist[i]);
                                    sqlOperation1.ExecuteNonQuery(updatecommand);
                                    countfortimes++;

                                }
                                else
                                {
                                    string muchcommand = "select ID,Appointment_ID from treatmentreord where Appointment_ID=@oldappoint";
                                    sqlOperation1.AddParameterWithValue("@oldappoint", templist[i]);
                                    reader1 = sqlOperation1.ExecuteReader(muchcommand);
                                    while (reader1.Read())
                                    {
                                        resettreatmentIDarray.Add(reader1["ID"].ToString());
                                        resettreatmentAPParray.Add(reader1["Appointment_ID"].ToString());
                                    }
                                    reader1.Read();

                                    string updatecommand = "update treatmentreord set Appointment_ID=@appoint where Appointment_ID=@oldappoint";
                                    sqlOperation1.AddParameterWithValue("@oldappoint", templist[i]);
                                    sqlOperation1.AddParameterWithValue("@appoint", result);
                                    sqlOperation1.ExecuteNonQuery(updatecommand);

                                    string selectpatientid = "select Patient_ID from appointment_accelerate where ID=@appoint";
                                    sqlOperation1.AddParameterWithValue("@appoint", result);
                                    string patientID = sqlOperation1.ExecuteScalar(selectpatientid);
                                    
                                    string updatecommand2 = "update appointment_accelerate set Patient_ID=NULL where ID=@oldappoint";
                                    sqlOperation1.AddParameterWithValue("@oldappoint", templist[i]);
                                    sqlOperation1.ExecuteNonQuery(updatecommand2);
                                    
                       
                                    string updatecommand3 = "update appointment_accelerate set Patient_ID=@pid where ID=@appoint";
                                    sqlOperation1.AddParameterWithValue("@appoint", result);
                                    sqlOperation1.AddParameterWithValue("@pid", patientid);
                                    sqlOperation1.ExecuteNonQuery(updatecommand3);
                                    resetappointarray.Add(result);
                                    resetbeginarray.Add(useappoint[i].ToString());
                                    resetendarray.Add(int.Parse(useappoint[i].ToString())+10);
                                    if (patientID == "")
                                    {
                                        resetpidarray.Add(null);
                                    }
                                    else
                                    {
                                        resetpidarray.Add(patientID);
                                    }
                                   
                                    countfortimes++;
                                }


                            }
                            else
                            {
                                string isexist = "select ID from appointment_accelerate where Date=@date and Begin=@begin and Equipment_ID=@equipid";
                                sqlOperation1.AddParameterWithValue("@date", datefirst);
                                sqlOperation1.AddParameterWithValue("@begin", useappoint[i].ToString());
                                sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                                string result = sqlOperation1.ExecuteScalar(isexist);
                                if (result == "")
                                {
                                    string updatecommand = "update appointment_accelerate set Begin=@begin,End=@end where ID=@id";
                                    sqlOperation1.AddParameterWithValue("@begin", useappoint[i].ToString());
                                    sqlOperation1.AddParameterWithValue("@end", int.Parse(useappoint[i].ToString()) + 10);
                                    sqlOperation1.AddParameterWithValue("@id", templist[i]);
                                    sqlOperation1.ExecuteNonQuery(updatecommand);

                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@appoint", templist[i]);
                                    sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now.Date.ToString());
                                    sqlOperation1.AddParameterWithValue("@chid", chid);
                                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                    treatmentrecordarray.Add(treatmentrecordid);
                                    countfortimes++;
                                    tempcount = tempcount + 1;
                                    if (tempcount >= rest)
                                    {
                                        return "success";
                                    }

                                }
                                else
                                {
                                    string muchcommand = "select ID,Appointment_ID from treatmentrecord where Appointment_ID=@oldappoint";
                                    sqlOperation1.AddParameterWithValue("@oldappoint", templist[i]);
                                    reader1 = sqlOperation1.ExecuteReader(muchcommand);
                                    while (reader1.Read())
                                    {
                                        resettreatmentIDarray.Add(reader1["ID"].ToString());
                                        resettreatmentAPParray.Add(reader1["Appointment_ID"].ToString());
                                    }
                                    reader1.Close();

                                    string updatecommand = "update treatmentrecord set Appointment_ID=@appoint where Appointment_ID=@oldappoint";
                                    sqlOperation1.AddParameterWithValue("@oldappoint", templist[i]);
                                    sqlOperation1.AddParameterWithValue("@appoint", result);
                                    sqlOperation1.ExecuteNonQuery(updatecommand);

                                    string updatecommand2 = "update appointment_accelerate set Patient_ID=NULL where ID=@oldappoint";
                                    sqlOperation1.AddParameterWithValue("@oldappoint", templist[i]);
                                    sqlOperation1.ExecuteNonQuery(updatecommand2);
                                    
                                    string selectpatientid = "select Patient_ID from appointment_accelerate where ID=@appoint";
                                    sqlOperation1.AddParameterWithValue("@appoint", result);
                                    string patientID = sqlOperation1.ExecuteScalar(selectpatientid);
                                    string updatecommand3 = "update appointment_accelerate set Patient_ID=@pid where ID=@appoint";
                                    sqlOperation1.AddParameterWithValue("@appoint", result);
                                    sqlOperation1.AddParameterWithValue("@pid", patientid);
                                    sqlOperation1.ExecuteNonQuery(updatecommand3);
                                    resetappointarray.Add(result);
                                    resetbeginarray.Add(useappoint[i].ToString());
                                    resetendarray.Add(int.Parse(useappoint[i].ToString()) + 10);
                                    if (patientID == "")
                                    {
                                        resetpidarray.Add(null);
                                    }
                                    else
                                    {
                                        resetpidarray.Add(patientID);
                                    }


                                    countfortimes++;

                                    string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                                    sqlOperation1.AddParameterWithValue("@appoint", templist[i]);
                                    sqlOperation1.AddParameterWithValue("@applyuser", userid);
                                    sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now.Date.ToString());
                                    sqlOperation1.AddParameterWithValue("@chid", chid);
                                    string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                    treatmentrecordarray.Add(treatmentrecordid);
                                    tempcount = tempcount + 1;
                                    if (tempcount >= rest)
                                    {
                                        return "success";
                                    }
                                    
                                }
                                
                                
                            }

                        }
                        for (int i = countfortimes; i < Times; i++)
                        {

                            string insertappoint = "insert into appointment_accelerate(Task,Patient_ID,Date,Equipment_ID,Begin,End,State,Completed) values(@task,@pid,@date,@equipid,@begin,@end,0,0);select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@task", "加速器");
                            sqlOperation1.AddParameterWithValue("@pid", patientid);
                            sqlOperation1.AddParameterWithValue("@date", datefirst);
                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                            sqlOperation1.AddParameterWithValue("@begin",useappoint[i].ToString());
                            sqlOperation1.AddParameterWithValue("@end", int.Parse(useappoint[i].ToString())+10);
                            string insertid = sqlOperation1.ExecuteScalar(insertappoint);
                            appointarray.Add(insertid);

                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@appoint", insertid);
                            sqlOperation1.AddParameterWithValue("@applyuser", userid);
                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now.Date.ToString());
                            sqlOperation1.AddParameterWithValue("@chid", chid);
                            string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                            treatmentrecordarray.Add(treatmentrecordid);
                            countfortimes++;
                            tempcount = tempcount + 1;
                            if (tempcount >= rest)
                            {
                                return "success";
                            }
 
                        }
                        if (countfortimes < Times)
                        {
                            return "failure";
                        }  
                   }
                    datefirst = datefirst.AddDays(1);
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
            return "success";
        
        }
        if (Interal > 1 && Times == 1)
        {
            int tempcount = 0;
            while (true)
            {
                if (datefirst.DayOfWeek.ToString() != "Sunday" && datefirst.DayOfWeek.ToString() != "Saturday")
                {
                    ArrayList templist = new ArrayList();
                    string checkcommand2 = "select count(*) from appointment_accelerate,treatmentrecord where Date>=@date1 and Date<=@date2 and treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=@chid";
                    sqlOperation1.AddParameterWithValue("@date1", datefirst.AddDays(1-Interal));
                    sqlOperation1.AddParameterWithValue("@date2", datefirst.AddDays(Interal-1));
                    sqlOperation1.AddParameterWithValue("@chid", chid);
                    int result = int.Parse(sqlOperation1.ExecuteScalar(checkcommand2));
                    if(result!=0)
                    {
                        return "failure";
                    }
                    

                    string checkcommand = "select ID,Begin from appointment_accelerate where Date=@date and ((Date>@nowdate) or((Date=@nowdate)and Begin>@nowbegin)) and Equipment_ID=@equipid and Patient_ID=@pid";
                    sqlOperation1.AddParameterWithValue("@date", datefirst);
                    sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                    sqlOperation1.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                    sqlOperation1.AddParameterWithValue("@pid", patientid);
                    sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(checkcommand);
                    while (reader1.Read())
                    {
                        templist.Add(reader1["ID"].ToString());
                    }
                    reader1.Close();
                    if (templist.Count > 0)
                    {
                        
                        string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid);select @@IDENTITY";
                        sqlOperation1.AddParameterWithValue("@appoint", templist[0]);
                        sqlOperation1.AddParameterWithValue("@applyuser", userid);
                        sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now.Date.ToString());
                        sqlOperation1.AddParameterWithValue("@chid", chid);
                        string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                        treatmentrecordarray.Add(treatmentrecordid);
                        tempcount = tempcount + 1;
                        if (tempcount >= rest)
                        {
                            return "success";
                        }
                         

                    }
                    else
                    {
                        Boolean flag = false;
                        for (int i = 0; i < appointarrange.Count; i++)
                        {

                            string busycommand = "select count(*) from appointment_accelerate where Date=@date and Patient_ID<>@pid and Begin=@begin and Equipment_ID=@equipid";
                            sqlOperation1.AddParameterWithValue("@date", datefirst);
                            sqlOperation1.AddParameterWithValue("@begin", appointarrange[i]["begin"].ToString());
                            sqlOperation1.AddParameterWithValue("@pid", patientid);
                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                            int result1 = int.Parse(sqlOperation1.ExecuteScalar(busycommand));
                            if (result1 == 1)
                            {
                                continue;
                            }
                            else
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
                                sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now.Date.ToString());
                                sqlOperation1.AddParameterWithValue("@chid", chid);
                                string treatmentrecordid = sqlOperation1.ExecuteScalar(insertcommand);
                                treatmentrecordarray.Add(treatmentrecordid);
                                tempcount = tempcount + 1;
                                if (tempcount >= rest)
                                {
                                    return "success";
                                }

                                flag = true;
                                break;
                            }
                        }
                            if (flag == false)
                            {
                                return "failure";
                            }
                        
                    }

                    datefirst = datefirst.AddDays(Interal);
                }
                else
                {
                    if (datefirst.DayOfWeek.ToString() == "Sunday")
                    {
                        datefirst = datefirst.AddDays(1);
                    }
                    else
                    {
                        datefirst = datefirst.AddDays(2);
                    }
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
    private void deleteallappoint(ArrayList appointarray, ArrayList treatmentrecordarray, ArrayList resetappointarray, ArrayList resetbeginarray, ArrayList resetendarray, ArrayList resettreatmentIDarray, ArrayList resettreatmentAPParray)
    {
        for (int i = appointarray.Count-1; i>=0; i--)
        {
            string deleteappoint = "delete from appointment_accelerate where ID=@aid";
            sqlOperation1.AddParameterWithValue("@aid", appointarray[i]);
            sqlOperation1.ExecuteNonQuery(deleteappoint);
        }
        for (int i = treatmentrecordarray.Count-1; i >= 0; i--)
        {
            string deleteappoint = "delete from treatmentrecord where ID=@tid";
            sqlOperation1.AddParameterWithValue("@tid", treatmentrecordarray[i]);
            sqlOperation1.ExecuteNonQuery(deleteappoint);
        }
        for (int i = resetappointarray.Count-1; i >= 0; i--)
        {
            string updateappoint = "update appointment_accelerate set Begin=@begin,End=@end where ID=@appointid";
            sqlOperation1.AddParameterWithValue("@appointid", resetappointarray[i]);
            sqlOperation1.AddParameterWithValue("@begin", resetbeginarray[i]);
            sqlOperation1.AddParameterWithValue("@end", resetendarray[i]);
            sqlOperation1.ExecuteNonQuery(updateappoint);
        }

        for (int i = resettreatmentIDarray.Count - 1; i >= 0; i--)
        {
            string updateappoint = "update treatmentrecord set Appointment_ID=@appoint where ID=@treatid ";
            sqlOperation1.AddParameterWithValue("@treatid", resettreatmentIDarray[i]);
            sqlOperation1.AddParameterWithValue("@appoint", resettreatmentAPParray[i]);
            sqlOperation1.ExecuteNonQuery(updateappoint);
        }
        
    }
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