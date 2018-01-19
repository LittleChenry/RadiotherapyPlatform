<%@ WebHandler Language="C#" Class="GetEquipmentAppointment" %>

using System;
using System.Web;
using System.Text;

public class GetEquipmentAppointment : IHttpHandler {
    static Object locker = new object();
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getInformation(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");

        string date = context.Request.QueryString["date"];
        string equipmentID = context.Request.QueryString["equipmentID"];

        string sqlCommand = "SELECT COUNT(ID) FROM Appointment WHERE Date=@date AND Equipment_ID=@id";
        sqlOperation.AddParameterWithValue("@date", date);
        sqlOperation.AddParameterWithValue("@id", equipmentID);


        StringBuilder backString = new StringBuilder("[");
        MySql.Data.MySqlClient.MySqlDataReader reader = null;
        //保证先查询后操作的原子性
        lock (locker)
        {
            int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
           
            if (count == 0)//没有先生成
            {
                sqlCommand = "SELECT * FROM equipment WHERE ID=@id";
                reader = sqlOperation.ExecuteReader(sqlCommand);
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
                        CreateAppointment(equipmentID, Oncetime, Ambeg, AmEnd, PMBeg, PMEnd, treatmentItem, date);
                    }
                    else
                    {
                        backString.Append("{\"Equipment\":\"false\"}]");
                        return backString.ToString();//生成不了
                    }
                }
                reader.Close();
            }
        }
        
        sqlCommand = "SELECT count(ID) From Appointment WHERE Date=@date AND Equipment_ID=@id";
        int times = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        int currentTimes = 1;
        sqlCommand = "SELECT * FROM Appointment WHERE Date=@date AND Equipment_ID=@id";
        reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            int time=int.Parse(reader["Begin"].ToString());
            int hour=time/60;
            int minute=time-(time/60)*60;
            string date1 = date;
            if (hour>=24)
            {
                hour = hour - 24;
                DateTime datenew = Convert.ToDateTime(date);
                date1 = datenew.AddDays(1).ToShortDateString();
            }
            DateTime dt1 = Convert.ToDateTime(date1 + " " + hour + ":" + minute + ":" + "00");
            DateTime dt2 = DateTime.Now;
           if (DateTime.Compare(dt1, dt2) > 0)
            {
                backString.Append("{\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\""
                        + reader["End"].ToString() + "\",\"EuqipmentID\":\"" + equipmentID + "\",\"ID\":\"" + reader["ID"].ToString() + "\",\"State\":\"" + reader["State"].ToString()
                     + "\",\"Euqipment\":\"");
               
            DataLayer sqlOperation2 = new DataLayer("sqlStr");
            string sqlCommand2 = "SELECT Name FROM equipment WHERE ID=@id";
            sqlOperation2.AddParameterWithValue("@id", equipmentID);
            string name = sqlOperation2.ExecuteScalar(sqlCommand2);
            sqlOperation2.Close();
            backString.Append(name + "\"}");
            if (currentTimes < times)
            {
                backString.Append(",");
            }
            } 
            ++currentTimes;
        }
        reader.Close();
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose();
        return backString.ToString();
    }

    private void CreateAppointment(string id, string OnceTime, string AMbeg, string AMEnd, string PMBeg, string PMEnd, string treatmentItem, string date)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        sqlOperation.clearParameter();

        int intAMBeg = int.Parse(AMbeg);
        int intAMEnd = int.Parse(AMEnd);
        int intPMBeg = int.Parse(PMBeg);
        int intPMEnd = int.Parse(PMEnd);

        int AMTime = intAMEnd - intAMBeg;
        int PMTime = intPMEnd - intPMBeg;

        int AMFrequency = AMTime / int.Parse(OnceTime);
        int PMFrequency = PMTime / int.Parse(OnceTime);

        string sqlCommand = "INSERT INTO appointment(Task,Date,Equipment_ID,Begin,End,State) VALUES(@task,@date,@id,@begin,@end,0)";
        sqlOperation.AddParameterWithValue("@task", treatmentItem);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.AddParameterWithValue("@date", date);
        for (int j = 0; j < AMFrequency; j++)
        {
            int begin = intAMBeg + (j * int.Parse(OnceTime));
            int end = begin + int.Parse(OnceTime);
            sqlOperation.AddParameterWithValue("@begin", begin);
            sqlOperation.AddParameterWithValue("@end", end);
            sqlOperation.ExecuteNonQuery(sqlCommand);
        }

        for (int k = 0; k < PMFrequency; k++)
        {
            int Pbegin = intPMBeg + (k * int.Parse(OnceTime));
            int PEnd = Pbegin + int.Parse(OnceTime);
            sqlOperation.AddParameterWithValue("@begin", Pbegin);
            sqlOperation.AddParameterWithValue("@end", PEnd);
            sqlOperation.ExecuteNonQuery(sqlCommand);
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}