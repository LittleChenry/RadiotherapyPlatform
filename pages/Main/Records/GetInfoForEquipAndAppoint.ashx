<%@ WebHandler Language="C#" Class="GetInfoForEquipAndAppoint" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class GetInfoForEquipAndAppoint : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getInfo(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string getInfo(HttpContext context)
    {
        string equipid = context.Request["equipid"];
        string first = context.Request["firstday"];
        DateTime firstdate = Convert.ToDateTime(first);
        string last = firstdate.AddDays(6).ToString("yyyy-MM-dd");
        StringBuilder backString = new StringBuilder("{\"machineinfo\":");
        string equipinfocommand = "select Name,State,Timelength,BeginTimeAM from equipment where ID=@equipid";
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(equipinfocommand);
        if (reader.Read())
        {
            backString.Append("{\"equipname\":\"" + reader["Name"].ToString() + "\",\"equipstate\":\"" + reader["State"].ToString() + "\",\"Timelength\":\"" + reader["Timelength"].ToString() + "\",\"BeginTimeAM\":\"" + reader["BeginTimeAM"].ToString() + "\"}");


        }
        else
        {
            backString.Append("\"\"");
        }
        reader.Close();
        string countcommand="select count(*) from appointment_accelerate where Equipment_ID=@equipid and Date>=@date and Date<=@date1";
        sqlOperation.AddParameterWithValue("@date", first);
        sqlOperation.AddParameterWithValue("@date1", last);
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        int count=int.Parse(sqlOperation.ExecuteScalar(countcommand));
        int maxbegin = 0;
        backString.Append(",\"appointinfo\":[");
       
        int i=0;
        string appointinfocommand = "select ID,Task,Patient_ID,Date,Begin,End from appointment_accelerate where Equipment_ID=@equipid and Date>=@date and Date<=@date1 order by Begin,Date asc";
        reader = sqlOperation.ExecuteReader(appointinfocommand);
        MySql.Data.MySqlClient.MySqlDataReader reader1 = null;
        ArrayList todaylist = new ArrayList();
        while (reader.Read())
        {
            string pnamecommand="select Name from patient where ID=@pid";
            sqlOperation2.AddParameterWithValue("@pid",reader["Patient_ID"].ToString());
            string pname=sqlOperation2.ExecuteScalar(pnamecommand);
      
            string begin = reader["Begin"].ToString();
            if (int.Parse(begin) > maxbegin)
            {
                maxbegin = int.Parse(begin);
            }
            string checkcommand = "select count(*) from treatmentrecord where Appointment_ID=@appointid and Treat_User_ID is null";
            sqlOperation2.AddParameterWithValue("@appointid", reader["ID"].ToString());
            int count1 = int.Parse(sqlOperation2.ExecuteScalar(checkcommand));
            string completed = "";
            if (count1 > 0)
            {
                completed = "false";
            }
            else
            {
                completed = "true";
            }
            string firstcounrcommand = "select count(*) from treatmentrecord where Appointment_ID=@appoint and isfirst=1";
            sqlOperation2.AddParameterWithValue("@appoint", reader["ID"].ToString());
            int firstocc = int.Parse(sqlOperation2.ExecuteScalar(firstcounrcommand));
            string rank = "";
            string treatmentrecordid = "";
            if (firstocc != 0)
            {
                string treatmentrecoridcommand = "select ID from treatmentrecord where Appointment_ID=@appoint and isfirst=1";
                sqlOperation2.AddParameterWithValue("@appoint", reader["ID"].ToString());
                treatmentrecordid = sqlOperation2.ExecuteScalar(treatmentrecoridcommand);
            }
            int countrank = 0;
            if (treatmentrecordid != "")
            {
                countrank = 0;
                Boolean boolfax = false;
                for (int step = 0; step < todaylist.Count; step++)
                {
                    countrank++;
                    if (todaylist[step] == reader1["treatid"].ToString())
                    {
                        boolfax = true;
                        break;
                    }

                }
                if (boolfax == false)
                {
                    countrank = 0;
                    todaylist.Clear();
                    if (int.Parse(reader["Begin"].ToString()) < 720)
                    {

                        string askforall = "select treatmentrecord.ID as treatid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Date=@date and appointment_accelerate.Equipment_ID=@equipid and appointment_accelerate.Begin<720 and treatmentrecord.isfirst=1 order by treatmentrecord.ApplyTime";
                        sqlOperation2.AddParameterWithValue("@date", reader["Date"].ToString());
                        sqlOperation2.AddParameterWithValue("@equipid", equipid);
                        reader1 = sqlOperation2.ExecuteReader(askforall);
                        while (reader1.Read())
                        {
                            countrank++;
                            if (treatmentrecordid == reader1["treatid"].ToString())
                            {
                                break;
                            }
                        }
                        reader1.Close();

                    }
                    else
                    {
                        countrank = 0;
                        string askforall = "select treatmentrecord.ID as treatid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Date=@date and appointment_accelerate.Equipment_ID=@equipid and appointment_accelerate.Begin>720 and treatmentrecord.isfirst=1 order by treatmentrecord.ApplyTime";
                        sqlOperation2.AddParameterWithValue("@date", reader["Date"].ToString());
                        sqlOperation2.AddParameterWithValue("@equipid", equipid);
                        reader1 = sqlOperation2.ExecuteReader(askforall);
                        while (reader1.Read())
                        {
                            countrank++;
                            if (treatmentrecordid == reader1["treatid"].ToString())
                            {
                                break;
                            }
                        }
                        reader1.Close();

                    }
                }

            }
            rank=countrank==0?"":(countrank+"");  
            backString.Append("{\"appointid\":\"" + reader["ID"].ToString() + "\",\"Task\":\"" + reader["Task"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + begin + "\",\"End\":\"" + reader["End"].ToString() + "\",\"rank\":\"" + rank + "\"");
            backString.Append(",\"Completed\":\"" + completed + "\",\"patientid\":\"" + reader["Patient_ID"].ToString() + "\",\"patientname\":\"" + pname + "\"}");
            if (i < count - 1)
            {
                backString.Append(",");
            }
            i++;
        }
        backString.Append("],\"maxbegin\":\"" + maxbegin + "\"}");
        return backString.ToString();
      
    }

}