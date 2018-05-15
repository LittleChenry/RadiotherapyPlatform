<%@ WebHandler Language="C#" Class="patientInfoForZLJS" %>

using System;
using System.Web;
using System.Text;
public class patientInfoForZLJS : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = gettreatrecord(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string gettreatrecord(HttpContext context)
    {
        String equipmentid = context.Request.QueryString["equipmentid"];
        int equipmentID = Convert.ToInt32(equipmentid);
        String date1 = context.Request.QueryString["date1"];
        String date2 = context.Request.QueryString["date2"];
        String type = context.Request.QueryString["type"];

        if (type == "1")
        {

            string sqlCommand = "SELECT count(*) from appointment_accelerate where Equipment_ID=@Equipment and Date >= @date1 and Date <= @date2 ";
            sqlOperation.AddParameterWithValue("@Equipment", equipmentID);
            sqlOperation.AddParameterWithValue("@date1", date1);
            sqlOperation.AddParameterWithValue("@date2", date2);
            int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
            if (count == 0)
            {
                return "{\"PatientInfo\":false}";
            }
            StringBuilder info = new StringBuilder("{\"PatientInfo\":[");
            string achievecommand = "select DISTINCT(appointment_accelerate.ID) as appid,appointment_accelerate.Patient_ID as Patient_ID,Begin,End,Date,treatmentrecord.TreatTime as treattime from appointment_accelerate,treatmentrecord where appointment_accelerate.ID=treatmentrecord.Appointment_ID and Date>=@date1 and Date<=@date2 and Equipment_ID=@Equipment GROUP BY appointment_accelerate.ID order by treatmentrecord.TreatTime";
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(achievecommand);
            int temp = 1;
            while (reader.Read())
            {
                string treatmentID = "";
                string treatidcommand = "select ID from treatment where Patient_ID=@pid and Progress not LIKE '%14%' and Progress like '%12%'";
                sqlOperation1.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(treatidcommand);
                if (reader1.Read())
                {
                    treatmentID = reader1["ID"].ToString();
                }
                reader1.Close();
                string patientinfocommand = "select ID,Name,Gender,Age,Radiotherapy_ID,Ishospital from patient where ID=@pid";
                sqlOperation1.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
                reader1 = sqlOperation1.ExecuteReader(patientinfocommand);
                if (reader1.Read())
                {
                    string coutcommand = "select count(*) from treatmentrecord where Appointment_ID=@app and Treat_User_ID  is null";
                    sqlOperation2.AddParameterWithValue("@app", reader["appid"].ToString());
                    int countthis = int.Parse(sqlOperation2.ExecuteScalar(coutcommand));
                    string completed = "";
                    if (countthis > 0)
                    {
                        completed = "0";
                    }
                    else
                    {
                        completed = "1";
                    }

                    if (completed == "1")
                    {

                        info.Append("{\"name\":\"" + reader1["Name"].ToString() + "\",\"Gender\":\"" + sex(reader1["Gender"].ToString()) + "\",\"Radiotherapy_ID\":\"" + reader1["Radiotherapy_ID"].ToString() + "\",\"patientid\":\"" + reader1["ID"].ToString() + "\",\"Ishospital\":\"" + reader1["Ishospital"].ToString() + "\",\"Age\":\"" + reader1["Age"].ToString() + "\",\"groupname\":\"");
                        string progresscommand = "select Progress from treatment where ID=@treat";
                        sqlOperation2.AddParameterWithValue("@treat", treatmentID);
                        string progress = sqlOperation2.ExecuteScalar(progresscommand);
                        string statecommand = "select State from treatment where ID=@treat";
                        sqlOperation2.AddParameterWithValue("@treat", treatmentID);
                        string state = sqlOperation2.ExecuteScalar(statecommand);
                        string groupcommand = "select user.Name as doctor,groups.groupName as groupname from groups,treatment,user,groups2user where groups2user.Group_ID=groups.ID and treatment.Group_ID=groups2user.ID and treatment.Patient_ID=@pid and treatment.Belongingdoctor=user.ID and treatment.ID=@treat";
                        sqlOperation2.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
                        sqlOperation2.AddParameterWithValue("@treat", treatmentID);
                        MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation2.ExecuteReader(groupcommand);
                        if (reader2.Read())
                        {
                            info.Append(reader2["groupname"].ToString() + "\",\"doctor\":\"" + reader2["doctor"].ToString() + "\",\"treatID\":\"" + treatmentID + "\",\"appointid\":\"" + reader["appid"].ToString() + "\",\"Progress\":\"" + progress + "\",\"state\":\"" + state + "\"");
                        }
                        else
                        {
                            info.Append("\",\"doctor\":\"" + "\",\"treatID\":\"" + treatmentID + "\",\"appointid\":\"" + reader["appid"].ToString() + "\",\"Progress\":\"" + progress + "\",\"state\":\"" + state + "\"");
                        }
                        reader2.Close();


                        info.Append(",\"begin\":\"" + reader["Begin"].ToString() + "\",\"end\":\"" + reader["End"].ToString() + "\",\"treattime\":\"" + reader["treattime"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Completed\":\"" + completed + "\"}");
                        if (temp < count)
                        {
                            info.Append(",");
                        }
                        temp++;

                    }
                    else
                    {
                        count--;
                    }
                   
                }
                else
                {
                    count--;
                }
                reader1.Close();

            }
            info.Append("]}");

            reader.Close();
            return info.ToString();
        }
        else
        {
            string sqlCommand = "SELECT count(*) from appointment_accelerate where Equipment_ID=@Equipment and Date >= @date1 and Date <= @date2 ";
            sqlOperation.AddParameterWithValue("@Equipment", equipmentID);
            sqlOperation.AddParameterWithValue("@date1", date1);
            sqlOperation.AddParameterWithValue("@date2", date2);
            int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
            if (count == 0)
            {
                return "{\"PatientInfo\":false}";
            }
            StringBuilder info = new StringBuilder("{\"PatientInfo\":[");
            string achievecommand = "select Patient_ID,ID,Begin,End,Date from appointment_accelerate where Date>=@date1 and Date<=@date2 and Equipment_ID=@Equipment order by Date asc,Begin asc";
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(achievecommand);
            int temp = 1;
            while (reader.Read())
            {
                string treatmentID = "";
                string treatidcommand = "select ID from treatment where Patient_ID=@pid and Progress not LIKE '%14%' and Progress like '%12%' and State=0";
                sqlOperation1.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(treatidcommand);
                if (reader1.Read())
                {
                    treatmentID = reader1["ID"].ToString();
                }
                reader1.Close();
                string patientinfocommand = "select ID,Name,Gender,Age,Radiotherapy_ID,Ishospital from patient where ID=@pid";
                sqlOperation1.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
                reader1 = sqlOperation1.ExecuteReader(patientinfocommand);
                if (reader1.Read())
                {
                    string coutcommand = "select count(*) from treatmentrecord where Appointment_ID=@app and Treat_User_ID  is null";
                    sqlOperation2.AddParameterWithValue("@app", reader["ID"].ToString());
                    int countthis = int.Parse(sqlOperation2.ExecuteScalar(coutcommand));
                    string completed = "";
                    if (countthis > 0)
                    {
                        completed = "0";
                    }
                    else
                    {
                        completed = "1";
                    }

                    if (completed == "0")
                    {

                        info.Append("{\"name\":\"" + reader1["Name"].ToString() + "\",\"Gender\":\"" + sex(reader1["Gender"].ToString()) + "\",\"Radiotherapy_ID\":\"" + reader1["Radiotherapy_ID"].ToString() + "\",\"patientid\":\"" + reader1["ID"].ToString() + "\",\"Ishospital\":\"" + reader1["Ishospital"].ToString() + "\",\"Age\":\"" + reader1["Age"].ToString() + "\",\"groupname\":\"");
                        string progresscommand = "select Progress from treatment where ID=@treat";
                        sqlOperation2.AddParameterWithValue("@treat", treatmentID);
                        string progress = sqlOperation2.ExecuteScalar(progresscommand);
                        string statecommand = "select State from treatment where ID=@treat";
                        sqlOperation2.AddParameterWithValue("@treat", treatmentID);
                        string state = sqlOperation2.ExecuteScalar(statecommand);
                        string groupcommand = "select user.Name as doctor,groups.groupName as groupname from groups,treatment,user,groups2user where groups2user.Group_ID=groups.ID and treatment.Group_ID=groups2user.ID and treatment.Patient_ID=@pid and treatment.Belongingdoctor=user.ID and treatment.ID=@treat";
                        sqlOperation2.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
                        sqlOperation2.AddParameterWithValue("@treat", treatmentID);
                        MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation2.ExecuteReader(groupcommand);
                        if (reader2.Read())
                        {
                            info.Append(reader2["groupname"].ToString() + "\",\"doctor\":\"" + reader2["doctor"].ToString() + "\",\"treatID\":\"" + treatmentID + "\",\"appointid\":\"" + reader["ID"].ToString() + "\",\"Progress\":\"" + progress + "\",\"state\":\"" + state + "\"");
                        }
                        else
                        {
                            info.Append("\",\"doctor\":\"" + "\",\"treatID\":\"" + treatmentID + "\",\"appointid\":\"" + reader["ID"].ToString() + "\",\"Progress\":\"" + progress + "\",\"state\":\"" + state + "\"");
                        }
                        reader2.Close();


                        info.Append(",\"begin\":\"" + reader["Begin"].ToString() + "\",\"end\":\"" + reader["End"].ToString() + "\",\"treattime\":\"" + "" + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Completed\":\"" + completed + "\"}");
                        if (temp < count)
                        {
                            info.Append(",");
                        }
                        temp++;

                    }
                    else
                    {
                        count--;
                    }

                }
                else
                {
                    count--;
                }
                reader1.Close();


            }
            info.Append("]}");

            reader.Close();
            return info.ToString();

        }
    }
    public string sex(string gen)
    {

        if (gen == "F")
        {
            return "女";
        }
        else
        {
            return "男";
        }
    }

}