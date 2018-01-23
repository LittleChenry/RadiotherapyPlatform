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
        string getstring = context.Request["data"];
        JArray getarray = (JArray)JsonConvert.DeserializeObject(getstring);
        string begindate = getarray["begindate"].ToString();
        string patientid = getarray["patientid"].ToString();
        string userid = getarray["userid"].ToString();
        string equipmentid = getarray["equipmentid"].ToString();
        lock (locker)
        {
            string designcommand = "select childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state>1";
            sqlOperation.AddParameterWithValue("@pid", patientid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(designcommand);
            while (reader.Read())
            {
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
                    deleteallappoint(appointarray, treatmentrecordarray);
                    return "failure";
                }

            } 
            reader.Close();
        }
        return "success";
       
    }
    private string begininsert(int Interal, int Times, int rest, string begindate, string patientid, string equipmentid, JArray getarray,string userid,string chid)
    {
        DateTime datefirst = Convert.ToDateTime(begindate);
        JArray appointarrange=(JArray)getarray["appointrange"];
        if (rest == 0)
        {
            return "success";
        }
        if (Interal == 1)
        {
            int tempcount = 0;
            while (true)
            {
                if (datefirst.DayOfWeek.ToString() != "0" && datefirst.DayOfWeek.ToString() != "6")
                {
                     ArrayList templist=new ArrayList();
                     ArrayList beginlist=new ArrayList();
                     for(int i=0;i<appointarrange.Count;i++)
                     {
                         string busycommand="select count(*) from appointment_accelerate where Date=@date and Patient_ID=@pid and Begin=@begin and Equipment_ID=@equipid";
                         sqlOperation1.AddParameterWithValue("@date",datefirst.ToShortDateString().Split(new char[]{' '}[0]));
                          sqlOperation1.AddParameterWithValue("@begin",appointarrange[i]["begin"]);
                            sqlOperation1.AddParameterWithValue("@pid", patientid);
                            sqlOperation1.AddParameterWithValue("@equipid", equipmentid);
                         int result=int.Parse(sqlOperation1.ExecuteScalar(busycommand));
                         if(result==0)
                         {
                             return "failure";
                         }
                     }
                    string checkcommand = "select ID,Begin from appointment_accelerate where Date=@date and ((Date>@nowdate) or((Date=@nowdate)and Begin>@nowbegin)) and Equipment_ID=@equipid and Patient_ID=@pid";
                    sqlOperation1.AddParameterWithValue("@date",datefirst.ToShortDateString().Split(new char[]{' '}[0]));
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
                        for (int l = 0; l < Times; l++)
                        {
                            string insertcommand = "insert into treatmentrecord(Appointment_ID,ApplyUser,ApplyTime,IsFirst,ChildDesign_ID) values(@appoint,@applyuser,@applytime,0,@chid) select @@IDENTITY";
                            sqlOperation1.AddParameterWithValue("@appoint", templist[l]);
                            sqlOperation1.AddParameterWithValue("@applyuser", userid);
                            sqlOperation1.AddParameterWithValue("@applytime", DateTime.Now.Date.ToString());
                            sqlOperation1.AddParameterWithValue("@chid", chid);
                            int treatmentrecordid=sqlOperation1.ExecuteNonQuery(insertcommand);
                            treatmentrecordarray.Add(treatmentrecordid);
                        }
                     }
                    else
                    {
                        for(int i=0;
                        
                        
                    } 
                        
                    }
                    
                    
                    
                    
                    
                    }
                    datefirst = datefirst.AddDays(1);
                    tempcount = tempcount + Times;
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
            return tempcount;

        }
        if (Interal > 1 && Times == 1)
        {
            int tempcount = 0;
            while (true)
            {
                if (datefirst.DayOfWeek.ToString() != "0" && datefirst.DayOfWeek.ToString() != "6")
                {
                    datefirst = datefirst.AddDays(Interal);
                    tempcount = tempcount + 1;
                }
                else
                {
                    if (datefirst.DayOfWeek.ToString() == "0")
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
            return tempcount;

        }
        
        
        
        
        

    }
    private void deleteallappoint(ArrayList appointarray, ArrayList treatmentrecordarray)
    {
       
        
        
    }


}