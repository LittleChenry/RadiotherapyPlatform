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
                        sqlOperation2.clearParameter();
                        string checkcommand = "select count(*) from appointment_accelerate where Equipment_ID=@equipid and Begin=@begin and End=@end and Date=@date and state is NULL";
                        sqlOperation2.AddParameterWithValue("@equipid", equipmentID);
                        sqlOperation2.AddParameterWithValue("@begin", begin);
                        sqlOperation2.AddParameterWithValue("@end", end);
                        sqlOperation2.AddParameterWithValue("@date", date);
                        int count = int.Parse(sqlOperation2.ExecuteScalar(checkcommand));
                        if (count == 0)
                        {
                            backString.Append("{\"Begin\":\"" + begin + "\",\"End\":\"" + end + "\",\"state\":\"0\"}");
                        }
                        else
                        {
                            backString.Append("{\"Begin\":\"" + begin + "\",\"End\":\"" + end + "\",\"state\":\"1\"}");
                        }
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
                        sqlOperation2.clearParameter();
                        string checkcommand = "select count(*) from appointment_accelerate where Equipment_ID=@equipid and Begin=@begin and End=@end and Date=@date and state is NULL";
                        sqlOperation2.AddParameterWithValue("@equipid", equipmentID);
                        sqlOperation2.AddParameterWithValue("@begin", Pbegin);
                        sqlOperation2.AddParameterWithValue("@end", PEnd);
                        sqlOperation2.AddParameterWithValue("@date", date);
                        int count = int.Parse(sqlOperation2.ExecuteScalar(checkcommand));
                        if (count == 0)
                        {
                            backString.Append("{\"Begin\":\"" + Pbegin + "\",\"End\":\"" + PEnd + "\",\"state\":\"0\"}");
                        }
                        else
                        {
                            backString.Append("{\"Begin\":\"" + Pbegin + "\",\"End\":\"" + PEnd + "\",\"state\":\"1\"}");
                        }
                        if (k < PMFrequency - 1)
                        {
                            backString.Append(",");
                        }
                    }
                    
                }
                backString.Append("]}");
                reader.Close();
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