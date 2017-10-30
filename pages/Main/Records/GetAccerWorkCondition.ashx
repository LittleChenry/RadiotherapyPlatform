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
        string dateorigin = context.Request["date"];
        string equipmentID = context.Request["equipmentID"];
        string alltotal = context.Request["times"];
        int alltotalnumber = int.Parse(alltotal);
        DateTime datefirst = Convert.ToDateTime(dateorigin);
        string date = "";
        StringBuilder backString = new StringBuilder("{\"appointinfo\":[");
        for (int k = 0; k < alltotalnumber; k++)
        {
            date = datefirst.AddDays(k).ToShortDateString();
            string todaycount = "select count(*) from appointment_accelerate where Date=@date and Equipment_ID=@id";
            sqlOperation.AddParameterWithValue("@date", date);
            sqlOperation.AddParameterWithValue("@id", equipmentID);
            int todaynumber = int.Parse(sqlOperation.ExecuteScalar(todaycount));
            if (k < alltotalnumber - 1 && k > 0 && todaynumber > 0)
            {
                backString.Append(",");
            }
            string sqlCommand = "SELECT Patient_ID,Begin,End,Treatment_ID FROM appointment_accelerate WHERE Date=@date AND Equipment_ID=@id";
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
            int i = 0;
            while (reader.Read())
            {
                string patientname = "select Name from patient where ID=@patientID";
                sqlOperation2.AddParameterWithValue("@patientID", reader["Patient_ID"].ToString());
                string name = sqlOperation2.ExecuteScalar(patientname);
                string treatmentdescribe = "select Treatmentdescribe from treatment where ID=@treatid";
                sqlOperation2.AddParameterWithValue("@treatid", reader["Treatment_ID"].ToString());
                string treatdescribe = sqlOperation2.ExecuteScalar(treatmentdescribe);
                backString.Append("{\"Date\":\"" + date + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"name\":\"" + name + "\",\"treatdescribe\":\"" + treatdescribe + "\"}");
                if (i < todaynumber - 1)
                {
                    backString.Append(",");
                }

            }
           
            reader.Close();
        }
        backString.Append("],\"equipmentinfo\":[");
        string equipcommand = "SELECT * FROM equipment WHERE ID=@id";
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(equipcommand);
        string Oncetime, Ambeg, AmEnd, PMBeg, PMEnd, treatmentItem;
        if (reader1.Read())
        {
            if (reader1["State"].ToString() == "1")
            {
                Oncetime = reader1["Timelength"].ToString();
                Ambeg = reader1["BeginTimeAM"].ToString();
                AmEnd = reader1["EndTimeAM"].ToString();
                PMBeg = reader1["BegTimePM"].ToString();
                PMEnd = reader1["EndTimeTPM"].ToString();
                treatmentItem = reader1["TreatmentItem"].ToString();
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
                    backString.Append("{\"Begin\":\"" + begin + "\",\"End\":\"" + end + "\"}");
                    if (j < AMFrequency - 1)
                    {
                        backString.Append(",");
                    }
                    if (j == AMFrequency - 1 && PMFrequency > 0)
                    {
                        backString.Append(",");
                    }
                }

                for (int k = 0; k < PMFrequency; k++)
                {
                    int Pbegin = intPMBeg + (k * int.Parse(Oncetime));
                    int PEnd = Pbegin + int.Parse(Oncetime);
                    backString.Append("{\"Begin\":\"" + Pbegin + "\",\"End\":\"" + PEnd + "\"}");
                    if (k < PMFrequency - 1)
                    {
                        backString.Append(",");
                    }
                }

            }
            backString.Append("]}");
        }
        else
        {
            backString.Append("]}");
        }
        reader1.Close();
        sqlOperation.Close();
        sqlOperation = null;
        sqlOperation2.Close();
        sqlOperation2 = null;
        return backString.ToString();
    }
}