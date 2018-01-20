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
        string equipmentid = context.Request["equipid"];
        int temp = 1;
        string countcommand = "select count(*) from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state>1";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        int number = int.Parse(sqlOperation.ExecuteScalar(countcommand));
        StringBuilder info = new StringBuilder("{\"patientinfo\":[");
        string designcommand = "select childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state>1";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(designcommand);
        while (reader.Read())
        {
            info.Append("{\"chid\":\"" + reader["chid"].ToString() + "\",\"DesignName\":\"" + reader["DesignName"].ToString() + "\",\"Totalnumber\":\"" + reader["total"].ToString() + "\",\"childstate\":\"" + reader["childstate"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"treatid\":\"" + reader["treatid"].ToString() + "\"");
            string splitcommand = "select Ways,Interal,Times from splitway where ID=@split";
            sqlOperation1.AddParameterWithValue("@split", reader["splitway"].ToString());
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(splitcommand);
            if (reader1.Read())
            {
                info.Append(",\"Ways\":\"" + reader1["Ways"].ToString() + "\",\"Interal\":\"" + reader1["Interal"].ToString() + "\",\"Times\":\"" + reader1["Times"].ToString() + "\"");
                
            }
            reader1.Close();
            int count = 0;
            int appointid = 0;
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
            info.Append(",\"rest\":\""+(int.Parse(reader["total"].ToString())-count)+"\"}");
            if (temp <= number - 1)
            {
                info.Append(",");
            }
            temp++;
        }
        reader.Close();
        info.Append("],\"appointinfo\":[");
        string countcommand2 = "select count(*) from appointment_accelerate where Equipment_ID=@equipid and Date>=@date";
        sqlOperation.AddParameterWithValue("@date", DateTime.Now.ToShortDateString());
        sqlOperation.AddParameterWithValue("@equipid", equipmentid);
        int count2 = int.Parse(sqlOperation.ExecuteScalar(countcommand2));
        int i = 1;
        string appointinfocommand = "select ID,Task,Patient_ID,Date,Begin,End,Completed,IsDouble from appointment_accelerate where Equipment_ID=@equipid and Date>=@date order by Begin,Date asc";
        reader = sqlOperation.ExecuteReader(appointinfocommand);
        while (reader.Read())
        {
            string pnamecommand = "select Name from patient where ID=@pid";
            sqlOperation1.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
            string pname = sqlOperation1.ExecuteScalar(pnamecommand);
            string begin = reader["Begin"].ToString();
            info.Append("{\"appointid\":\"" + reader["ID"].ToString() + "\",\"Task\":\"" + reader["Task"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + begin + "\",\"End\":\"" + reader["End"].ToString() + "\"");
            info.Append(",\"Completed\":\"" + reader["Completed"].ToString() + "\",\"patientname\":\"" + pname +"\",\"IsDouble\":\"" + reader["IsDouble"].ToString() + "\"}");
            if (i < count2)
            {
                info.Append(",");
            }
            i++;
        }
        info.Append("]}");
        return info.ToString();
        
    }

}