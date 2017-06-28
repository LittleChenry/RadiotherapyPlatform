<%@ WebHandler Language="C#" Class="GetApptiontment" %>

using System;
using System.Web;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Collections;

public class GetApptiontment : IHttpHandler {
    
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
        DataLayer sqlInreader = new DataLayer("sqlStr");
        string date = context.Request.QueryString["date"];
        string item = context.Request.QueryString["item"];
        
        //查询该项目所有设备
        LinkedList<string> equimentID = new LinkedList<string>();
        string sqlCommand = "SELECT ID FROM equipment WHERE TreatmentItem=@item";
        sqlOperation.AddParameterWithValue("@item", item);
        MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        int n = 0;        
        while (reader.Read())
        {
            equimentID.AddLast(reader["ID"].ToString());
            ++n;
        }
        reader.Close();
        if (n == 0)
        {
            return "{\"Equiment1\":[{\"Equipment\":\"false\"}]}";//该项目没有设备
        }

        int number = 1;//第几个设备
        StringBuilder backString = new StringBuilder("{");
        //所有设备查询是否有该天的预约表
        foreach(string s in equimentID){
            backString.Append("\"Equiment" + number.ToString() + "\":[");
            sqlCommand = "SELECT count(ID) FROM Appointment WHERE Date=@date AND Equipment_ID=@id";
            sqlOperation.AddParameterWithValue("@date", date);
            sqlOperation.AddParameterWithValue("@id", int.Parse(s));
            int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
            if (count == 0)//没有则生成
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
                        CreateAppointment(s, Oncetime, Ambeg, AmEnd, PMBeg, PMEnd, treatmentItem, date);
                    }
                    else
                    {
                        backString.Append("{\"Equipment\":\"false\"}]");
                        if (number < equimentID.Count)
                        {
                            backString.Append(",");
                        }
                        number++;
                        break;
                    }
                }
                reader.Close();
            }//if(count == 0)
            sqlCommand = "SELECT count(ID) From Appointment WHERE Date=@date AND Equipment_ID=@id";
            int times = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
            int currentTimes = 1;
            sqlCommand = "SELECT * FROM Appointment WHERE Date=@date AND Equipment_ID=@id";
            reader = sqlOperation.ExecuteReader(sqlCommand);
            while (reader.Read())
            {
                backString.Append("{\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\""
                    + reader["End"].ToString() + "\",\"EuqipmentID\":\"" + s + "\",\"ID\":\"" + reader["ID"].ToString() + "\",\"State\":\"" + reader["State"].ToString()
                 + "\",\"Euqipment\":\"");
                sqlCommand = "SELECT Name FROM equipment WHERE ID=@id";
                sqlInreader.AddParameterWithValue("@id", int.Parse(s));
                string name = sqlInreader.ExecuteScalar(sqlCommand);
                backString.Append(name + "\"}");
                if (currentTimes < times)
                {
                    backString.Append(",");
                }
                ++currentTimes;
            }
            reader.Close();
            backString.Append("]");
            if (number < equimentID.Count)
            {
                backString.Append(",");
            }
            ++number;
        }//foreach
        backString.Append("}");
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlInreader.Close();
        sqlInreader.Dispose();
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