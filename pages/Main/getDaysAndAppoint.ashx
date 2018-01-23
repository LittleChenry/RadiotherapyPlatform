<%@ WebHandler Language="C#" Class="getDaysAndAppoint" %>

using System;
using System.Web;
using System.Collections;
using System.Text;

public class getDaysAndAppoint : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getdaysandappoint(context);
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
    private string getdaysandappoint(HttpContext context)
    {
        string patientid = context.Request["patientid"];
        string equipmentid = context.Request["equipid"];
        string inputdate = context.Request["date"];
        ArrayList days = new ArrayList();
        ArrayList beginlist = new ArrayList();
        string designcommand = "select childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state>1";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(designcommand);
        while (reader.Read())
        {
            int Interal=0, Times=0, rest=0;
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
            int needdays = computedays(Interal, Times, rest,inputdate);
            days.Add(needdays);
        }
        reader.Close();
        int maxday=0;
        if (days.Count != 0)
        {
            maxday = (int)days[0];
        }
        for(int j=1;j<days.Count;j++)
        {
            int tempday = (int)days[j];
            if (tempday> maxday)
            {
                maxday=tempday;
            }
        }
        DateTime datefirst = Convert.ToDateTime(inputdate);
        string begindate = datefirst.ToShortDateString();
        string enddate = datefirst.AddDays(maxday - 1).ToShortDateString();
        StringBuilder backstring = new StringBuilder("{\"timeinfo\":{\"begin\":\"" + begindate + "\",\"end\":\"" + enddate + "\"},\"appointinfo\":[");
        string sqlCommand = "SELECT * FROM equipment WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", equipmentid);
        reader = sqlOperation.ExecuteReader(sqlCommand);
        string Oncetime, Ambeg, AmEnd, PMBeg, PMEnd, treatmentItem;
        if (reader.Read())
        {
                Oncetime = reader["Timelength"].ToString();
                Ambeg = reader["BeginTimeAM"].ToString();
                AmEnd = reader["EndTimeAM"].ToString();
                PMBeg = reader["BegTimePM"].ToString();
                PMEnd = reader["EndTimeTPM"].ToString();
                treatmentItem = reader["TreatmentItem"].ToString();
                int intAMBeg = int.Parse(Ambeg);
                int intAMEnd = int.Parse(AmEnd);
                int intPMBeg = int.Parse(PMBeg);
                int intPMEnd = int.Parse(PMEnd);
                int AMTime = intAMEnd - intAMBeg;
                int PMTime = intPMEnd - intPMBeg;
                int AMFrequency = AMTime / int.Parse(Oncetime);
                int PMFrequency = PMTime / int.Parse(Oncetime);
                for (int j = 0; j < AMFrequency; j++)
                {
                    int begin = intAMBeg + (j * int.Parse(Oncetime));
                    int end = begin + int.Parse(Oncetime);
                    int time = int.Parse(begin.ToString());
                    int hour = time / 60;
                    int minute = time - (time / 60) * 60;
                    beginlist.Add(begin);

                }
                for (int k = 0; k < PMFrequency; k++)
                {
                    int Pbegin = intPMBeg + (k * int.Parse(Oncetime));
                    int PEnd = Pbegin + int.Parse(Oncetime);
                    int time = int.Parse(Pbegin.ToString());
                    int hour = time / 60;
                    int minute = time - (time / 60) * 60;
                    beginlist.Add(Pbegin);
                }
           
        }
         reader.Close();

         for (int k = 0; k < beginlist.Count; k++)
         {   
             backstring.Append("[");
             ArrayList plist = new ArrayList();
             string commandpatient = "select Distinct(Patient_ID) from appointment_accelerate where Date>=@begindate and Date<=@enddate and begin=@begin";
             sqlOperation.AddParameterWithValue("@begindate", begindate);
             sqlOperation.AddParameterWithValue("@enddate", enddate);
             sqlOperation.AddParameterWithValue("@begin", beginlist[k]);
             reader = sqlOperation.ExecuteReader(commandpatient);
             while (reader.Read())
             {
                 plist.Add(reader["Patient_ID"].ToString());
             }
             reader.Close();
             for(int m=0;m<plist.Count;m++)
             {
                 string pstate="0";
                 if(plist[m]==patientid)
                 {
                     pstate="1";
                 }
                 string commandstring = "select max(Date) as maxdate,min(Date) as mindate from appointment_accelerate where Date>=@begindate and Date<=@enddate and begin=@begin and Patient_ID=@pid";
                 sqlOperation1.AddParameterWithValue("@pid", plist[m]);
                 sqlOperation1.AddParameterWithValue("@begindate", begindate);
                 sqlOperation1.AddParameterWithValue("@enddate", enddate);
                 sqlOperation1.AddParameterWithValue("@begin", beginlist[k]);
                 MySql.Data.MySqlClient.MySqlDataReader reader1= sqlOperation1.ExecuteReader(commandstring);
                 while(reader1.Read())
                 {
                     backstring.Append("{\"pbegin\":\"" + reader1["mindate"].ToString() + "\",\"pend\":" + reader1["maxdate"].ToString() + "\",\"begintime\":" + beginlist[k] + "\",\"ispatient\":\"" + pstate + "\"}");
                 }
                 if (m <= plist.Count - 2)
                 {
                     backstring.Append(",");
                 }
                 reader1.Close();
           
             }
             backstring.Append("]");
             if (k <= beginlist.Count-2)
             {
                 backstring.Append(",");
             }
             
         }
         backstring.Append("]}");
         return backstring.ToString();
          
    }

    private int computedays(int Interal, int Times, int rest, string inputdate)
    {
        DateTime datefirst = Convert.ToDateTime(inputdate);
        if (rest == 0)
        {
            return 0;
        }
        if (Interal == 1)
        {
            int tempcount = 0;
            while (true)
            {
                if (datefirst.DayOfWeek.ToString() != "0" && datefirst.DayOfWeek.ToString() != "6")
                {
                    datefirst = datefirst.AddDays(1);
                    tempcount=tempcount + Times;
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
        if (Interal>1 && Times == 1)
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
        return 0;  
    }
    
    
    
    
    
    

}