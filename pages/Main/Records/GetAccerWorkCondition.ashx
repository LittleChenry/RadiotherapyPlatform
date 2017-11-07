<%@ WebHandler Language="C#" Class="GetAccerWorkCondition" %>

using System;
using System.Web;
using System.Text;


public class GetAccerWorkCondition : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getInformation(context);
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getInformation(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        string treatmentid = context.Request["treatid"];
        string alltotal = context.Request["times"];
        string equipmentID = "";
        string dateorigin = "";
        StringBuilder backString = new StringBuilder("{\"appointinfo\":[");
        string firstequip = "SELECT equipment.ID as equipid,equipment.Name as equipmentname,appointment_accelerate.Date as begindate,equipment.Timelength as timelength,equipment.BeginTimeAM as ambegin,equipment.State as equipmentstate FROM treatmentrecord,equipment,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Equipment_ID=equipment.ID and treatmentrecord.Treatment_ID=@treat order by appointment_accelerate.Date,appointment_accelerate.Begin asc";
        sqlOperation.AddParameterWithValue("@treat", treatmentid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(firstequip);
        if (reader.Read())
        {
            equipmentID = reader["equipid"].ToString();
            dateorigin = reader["begindate"].ToString();
        }
        else
        {
            backString.Append("]}");
            return backString.ToString();
        }
        reader.Close();
        int alltotalnumber = int.Parse(alltotal);
        DateTime datefirst = Convert.ToDateTime(dateorigin);
        string date = "";
        for (int k = 0; k < alltotalnumber; k++)
        {
            date = datefirst.AddDays(k).ToShortDateString();
            string todaycount = "select count(*) from appointment_accelerate where Date=@date and Equipment_ID=@id";
            sqlOperation.AddParameterWithValue("@date", date);
            sqlOperation.AddParameterWithValue("@id", equipmentID);
            int todaynumber = int.Parse(sqlOperation.ExecuteScalar(todaycount));
            if (k > 0 && todaynumber > 0)
            {
                backString.Append(",");
            }
            string sqlCommand = "SELECT Patient_ID,Begin,End,Treatment_ID,IsDouble FROM appointment_accelerate WHERE Date=@date AND Equipment_ID=@id";
          reader = sqlOperation.ExecuteReader(sqlCommand);
            int i = 0;
            while (reader.Read())
            {
                string patientname = "select Name from patient where ID=@patientID";
                sqlOperation2.AddParameterWithValue("@patientID", reader["Patient_ID"].ToString());
                string name = sqlOperation2.ExecuteScalar(patientname);
                string treatmentdescribe = "select Treatmentdescribe from treatment where ID=@treatid";
                sqlOperation2.AddParameterWithValue("@treatid", reader["Treatment_ID"].ToString());
                string treatdescribe = sqlOperation2.ExecuteScalar(treatmentdescribe);
                string iscondition="";
                if (reader["Treatment_ID"].ToString() == "treatmentid")
                {
                    iscondition = "1";
                }
                else
                {
                    iscondition = "0";
                }
                backString.Append("{\"Date\":\"" + date + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"isdouble\":\"" + reader["IsDouble"].ToString() + "\",\"name\":\"" + name + "\",\"ispatient\":\"" + iscondition + "\",\"treatdescribe\":\"" + treatdescribe + "\"}");
                if (i < todaynumber - 1)
                {
                    backString.Append(",");
                }
                i++;

            }
           
            reader.Close();
        }
        backString.Append("]}");
        sqlOperation.Close();
        sqlOperation = null;
        sqlOperation2.Close();
        sqlOperation2 = null;
        return backString.ToString();
    }
}