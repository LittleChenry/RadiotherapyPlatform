<%@ WebHandler Language="C#" Class="InsertAllAppoint" %>

using System;
using System.Web;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class InsertAllAppoint : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = insertappoit(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string insertappoit(HttpContext context)
    {
        //string s = context.Request["appointgroup"];
        string treatmentID = context.Request["treatid"];
        string isdouble = context.Request["isdouble"];
        string user = context.Request["userID"];
        string s = context.Request["appointdata"];
        string equipid = "";
        string task="";
        string firstequip = "SELECT equipment.ID as equipid,equipment.TreatmentItem as task FROM treatmentrecord,equipment,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Equipment_ID=equipment.ID and treatmentrecord.Treatment_ID=@treat order by appointment_accelerate.Date,appointment_accelerate.Begin asc";
        sqlOperation.AddParameterWithValue("@treat", treatmentID);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(firstequip);
        if (reader.Read())
        {
            equipid = reader["equipid"].ToString();
            task = reader["task"].ToString();  
        }
        reader.Close();
        string patientidcommand= "select Patient_ID from treatment where ID=@treat";
        string patientid = sqlOperation.ExecuteScalar(patientidcommand);
        
        JArray ja = (JArray)JsonConvert.DeserializeObject(s);
        //string locktablecommand = "LOCK TABLE appointment_accelerate WRITE";
        //sqlOperation.ExecuteNonQuery(locktablecommand);
        int k = 0;
        for (k = 0; k <ja.Count; k++)
        {
            string date = ja[k]["Date"].ToString();
            string begin = ja[k]["Begin"].ToString();
            string end = ja[k]["End"].ToString();
            string selectcommand = "select count(*) from appointment_accelerate where Equipment_ID=@equip and Date=@date and ((Begin<=@begin and End>=@begin) or (Begin<=@end and End>=@end))";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@date", date);
            sqlOperation.AddParameterWithValue("@begin", begin);
            sqlOperation.AddParameterWithValue("@end", end);
            sqlOperation.AddParameterWithValue("@equip", equipid);
            int recount=int.Parse(sqlOperation.ExecuteScalar(selectcommand));
            if (recount != 0)
            {
                int i = 0;
                for (i = k - 1; i >= 0; i--)
                {
                    string selectidcommand = "select ID from appointment_accelerate where Equipment_ID=@equip and Date=@date and Begin=@begin and End=@end";
                    sqlOperation.clearParameter();
                    sqlOperation.AddParameterWithValue("@date", date);
                    sqlOperation.AddParameterWithValue("@begin", begin);
                    sqlOperation.AddParameterWithValue("@end", end);
                    sqlOperation.AddParameterWithValue("@equip", equipid);
                    string hasid = sqlOperation.ExecuteScalar(selectidcommand);
                    string deletecommand = "delete from treatmentrecord where Appointment_ID=@appoint";
                    sqlOperation.AddParameterWithValue("@appoint", hasid);
                    sqlOperation.ExecuteNonQuery(deletecommand);
                    string deletecommand2 = "delete from appointment_accelerate where ID=@appoint";
                    sqlOperation.ExecuteNonQuery(deletecommand2);

                }
                //string unlocktablecommand = "UNLOCK TABLES";
                //sqlOperation.ExecuteNonQuery(unlocktablecommand);
                return "busy";

            }
            else
            {
                string strcommand1 = "insert into appointment_accelerate(Equipment_ID,Date,Begin,End,Treatment_ID,State,Completed,isdouble) values(@equip,@date,@begin,@end,@Treatment_ID,0,0,@isdouble);SELECT @@IDENTITY ";
                sqlOperation.AddParameterWithValue("@Treatment_ID", treatmentID);
                sqlOperation.AddParameterWithValue("@isdouble", int.Parse(isdouble));
                string appointid = sqlOperation.ExecuteScalar(strcommand1);
                string finishappoint = "update appointment_accelerate set Patient_ID=@Patient,Treatment_ID=@treat,Task=@task where ID=@appointid";
                sqlOperation.AddParameterWithValue("@Patient", patientid);
                sqlOperation.AddParameterWithValue("@appointid", appointid);
                sqlOperation.AddParameterWithValue("@treat", treatmentID);
                sqlOperation.AddParameterWithValue("@task", task);
                sqlOperation.ExecuteNonQuery(finishappoint);

                string strSqlCommand = "INSERT INTO treatmentrecord(Treatment_ID,Appointment_ID,ApplyUser,ApplyTime) " +
                                                "VALUES(@Treatment_ID,@appointid,@ApplyUser,@ApplyTime)";
                sqlOperation.AddParameterWithValue("@ApplyTime", DateTime.Now);
                sqlOperation.AddParameterWithValue("@ApplyUser",user);
                sqlOperation.ExecuteNonQuery(strSqlCommand);
                
            }
            
        }
        //string unlocktablecommand2 = "UNLOCK TABLES";
        //sqlOperation.ExecuteNonQuery(unlocktablecommand2);
        return "success";

    }
}