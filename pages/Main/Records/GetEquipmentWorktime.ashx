<%@ WebHandler Language="C#" Class="GetEquipmentWorktime" %>

using System;
using System.Web;
using System.Text;

public class GetEquipmentWorktime : IHttpHandler {

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
        string date = context.Request.QueryString["date"];
        string equipmentID = context.Request.QueryString["equipmentID"];
        StringBuilder backString = new StringBuilder("{\"Equipment\":[");
        string  sqlCommand = "SELECT * FROM equipment WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", equipmentID);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        string Oncetime, Ambeg, AmEnd, PMBeg, PMEnd, treatmentItem;
        if (reader.Read())
        {
            if (reader["State"].ToString() == "1")
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
                    string date1 = date;
                    if (hour >= 24)
                    {
                        hour = hour - 24;
                        DateTime datenew = Convert.ToDateTime(date);
                        date1 = datenew.AddDays(1).ToShortDateString();
                    }
                    DateTime dt1 = Convert.ToDateTime(date1 + " " + hour + ":" + minute + ":" + "00");
                    DateTime dt2 = DateTime.Now;
                    if (DateTime.Compare(dt1, dt2) > 0)
                    {
                        backString.Append("{\"Begin\":\"" + begin + "\",\"End\":\"" + end + "\",\"state\":\"0\"}");
                        if (j < AMFrequency - 1)
                        {
                            backString.Append(",");
                        }
                        if (j == AMFrequency - 1 && PMFrequency > 0)
                        { 
                            backString.Append(",");
                        }
                    }
                   
                }
                for (int k = 0; k < PMFrequency; k++)
                {
                    int Pbegin = intPMBeg + (k * int.Parse(Oncetime));
                    int PEnd = Pbegin + int.Parse(Oncetime);
                    int time = int.Parse(Pbegin.ToString());
                    int hour = time / 60;
                    int minute = time - (time / 60) * 60;
                    string date1 = date;
                    if (hour >= 24)
                    {
                        hour = hour - 24;
                        DateTime datenew = Convert.ToDateTime(date);
                        date1 = datenew.AddDays(1).ToShortDateString();
                    }
                    DateTime dt1 = Convert.ToDateTime(date1 + " " + hour + ":" + minute + ":" + "00");
                    DateTime dt2 = DateTime.Now;
                    if (DateTime.Compare(dt1, dt2) > 0)
                    {
                        backString.Append("{\"Begin\":\"" + Pbegin + "\",\"End\":\"" + PEnd + "\",\"state\":\"0\"}");
                        if (k < PMFrequency - 1)
                        {
                            backString.Append(",");
                        }
                    }
                    
                } 
                
                reader.Close();
                backString.Append("],\"appointinfo\":[");
                string countcommand = "select count(*) from appointment_accelerate where Date=@date and Equipment_ID=@equipid";
                sqlOperation.AddParameterWithValue("@date", date);
                sqlOperation.AddParameterWithValue("@equipid", equipmentID);
                int counttemp = int.Parse(sqlOperation.ExecuteScalar(countcommand));
                
                string patientcommand = "select Begin,End from appointment_accelerate where Date=@date and Equipment_ID=@equipid";
                reader = sqlOperation.ExecuteReader(patientcommand);
                int c = 0;
                while (reader.Read())
                {
                    backString.Append("{\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\"}");
                    if (c < counttemp - 1)
                    {
                        backString.Append(",");
                    }
                    c++;
                    
                }
                backString.Append("]}");
                sqlOperation.Close();
                sqlOperation = null;
                sqlOperation2.Close();
                sqlOperation2 = null;
                return backString.ToString();

            }
            else
            {
                reader.Close();
                sqlOperation.Close();
                sqlOperation = null;
                return "{\"Equipment\":[]}";
            }

        }
        else
        {
            return "{\"Equipment\":[]}";
        }
      
    }

   
}