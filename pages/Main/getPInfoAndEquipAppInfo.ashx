<%@ WebHandler Language="C#" Class="getPInfoAndEquipAppInfo" %>

using System;
using System.Web;
using System.Collections;
using System.Text;

public class getPInfoAndEquipAppInfo : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getpaeinfo(context);
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
    private string getpaeinfo(HttpContext context)
    {
        string patientid = context.Request["patientid"];
        string equipid=context.Request["equipid"];
        string command = "select equipmenttype.Type as equiptype from equipment,equipmenttype where equipment.ID=@equipid and equipment.EquipmentType=equipmenttype.ID";
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        string equiptype = sqlOperation.ExecuteScalar(command);
        string equipment = System.Text.RegularExpressions.Regex.Replace(equiptype, @"[^0-9]+", "");
        int temp = 1;
         string selectcommand = "select Distinct(treatment.ID) as treatid from fieldinfomation,childdesign,treatment where fieldinfomation.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID and childdesign.state=3 and fieldinfomation.equipment like '%" + equipment+"%' and treatment.Patient_ID=@pid";
         sqlOperation.AddParameterWithValue("@pid", patientid);
         MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectcommand);
         ArrayList treatmentidlist = new ArrayList();
        while (reader.Read())
        {
            treatmentidlist.Add(reader["treatid"].ToString());
        }
        reader.Close();
        string str = string.Join(",", (string[])treatmentidlist.ToArray(typeof(string)));
        StringBuilder info = new StringBuilder("{\"patientinfo\":[");
        if (str == "")
        {
            info.Append("],\"timeduan\":[]}");
            return info.ToString();
        }
        string countcommand = "select count(*) from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state=3 and treatment.ID in ("+str+")";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        int number = int.Parse(sqlOperation.ExecuteScalar(countcommand));

        string designcommand = "select childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state=3  and treatment.ID in (" + str + ")";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        reader = sqlOperation.ExecuteReader(designcommand);
        while (reader.Read())
        {
            
            info.Append("{\"chid\":\"" + reader["chid"].ToString() + "\",\"DesignName\":\"" + reader["DesignName"].ToString() + "\",\"Totalnumber\":\"" + reader["total"].ToString() + "\",\"childstate\":\"" + reader["childstate"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"treatid\":\"" + reader["treatid"].ToString() + "\"");
            string splitcommand = "select Ways,Interal,Times,TimeInteral from splitway where ID=@split";
            sqlOperation1.AddParameterWithValue("@split", reader["splitway"].ToString());
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(splitcommand);
            if (reader1.Read())
            {
                info.Append(",\"Ways\":\"" + reader1["Ways"].ToString() + "\",\"Interal\":\"" + reader1["Interal"].ToString() + "\",\"TimeInteral\":\"" + reader1["TimeInteral"].ToString() + "\",\"Times\":\"" + reader1["Times"].ToString() + "\"");
                
            }
            reader1.Close();
            int count = 0;
            int appointid = 0;
            string maxdate = "无";
            string date = "";
            string begin = "";
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
            info.Append(",\"rest\":\""+(int.Parse(reader["total"].ToString())-count)+"\",\"maxdate\":\""+maxdate+"\",\"firstday\":\"");
            string chid = reader["chid"].ToString();
            string firstdaycommand = "select Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and IsFirst=1 and Date>=@nowdate order by Date desc,Begin desc";
            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
            sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.ToString("yyyy-MM-dd"));
            reader1 = sqlOperation1.ExecuteReader(firstdaycommand);
            if (reader1.Read())
            {
                info.Append(reader1["Date"].ToString().Split(new char[]{' '})[0] + "\",\"firstbegin\":\""+reader1["Begin"].ToString()+"\",\"firstend\":\""+reader1["End"].ToString()+"\"}");
            }    
            else
            {
                info.Append("\"}");
            }            
            reader1.Close();
            if (temp <= number - 1)
            {
                info.Append(",");
            }
            temp++;
        }
        reader.Close();
       string datecommand = "select DISTINCT(count(*)) as count from appointment_accelerate where Patient_ID=@pid and Equipment_ID=@equipid and Date>=@todaydate GROUP BY Date ORDER BY count desc";
       sqlOperation.AddParameterWithValue("@pid", patientid);
       sqlOperation.AddParameterWithValue("@equipid", equipid);
       sqlOperation.AddParameterWithValue("@todaydate", DateTime.Now.ToString("yyyy-MM-dd"));
       reader = sqlOperation.ExecuteReader(datecommand);
       info.Append("],\"timeduan\":[");
       while (reader.Read())
       {
           string timeduancommand = "select Begin,End FROM appointment_accelerate where Date in (select Date from (select count(*) as number,treatmentrecord.ChildDesign_ID,Date from appointment_accelerate,treatmentrecord where treatmentrecord.Appointment_ID=appointment_accelerate.ID and Date in (select Date  from (select Date,count(*) as count from appointment_accelerate where Patient_ID=@pid and Equipment_ID=@equipid and Date>=@todaydate GROUP BY Date) as a where count=@count) and IsFirst!=1 GROUP BY treatmentrecord.ChildDesign_ID,Date) as b where number=@count) GROUP BY Begin";
           sqlOperation1.AddParameterWithValue("@pid", patientid);
           sqlOperation1.AddParameterWithValue("@equipid", equipid);
           sqlOperation1.AddParameterWithValue("@todaydate", DateTime.Now.ToString("yyyy-MM-dd"));
           sqlOperation1.AddParameterWithValue("@count", reader["count"].ToString());
           MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(timeduancommand);
           int k = 0;
           while (reader1.Read())
           {
               if (k == 0)
               {
                   info.Append("{\"begin\":\"" + reader1["Begin"].ToString() + "\",\"end\":\"" + reader1["End"].ToString() + "\"}");
               }
               else
               {
                   info.Append(",");
                   info.Append("{\"begin\":\"" + reader1["Begin"].ToString() + "\",\"end\":\"" + reader1["End"].ToString() + "\"}");
               }
               k++;
               
           }
           if (k != 0)
           {
                break;
           }
        

       }
       reader.Close();
        info.Append("]}");
        return info.ToString();
        
    }

}