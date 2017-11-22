<%@ WebHandler Language="C#" Class="GetBasicTableInfo" %>

using System;
using System.Web;
using System.Text;


public class GetBasicTableInfo : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getmodelItem(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getmodelItem(HttpContext context)
    {
        string treatid = context.Request["treatid"];
        StringBuilder backText = new StringBuilder("");
        MySql.Data.MySqlClient.MySqlDataReader reader=null;

        string sqlsplit = "SELECT Interal,Ways,Times,TimeInteral FROM splitway,treatment where treatment.SplitWay_ID=splitway.ID and treatment.ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        reader = sqlOperation.ExecuteReader(sqlsplit);
        if (reader.Read())
        {
            
            backText.Append("{\"Interal\":\""+reader["Interal"].ToString()+"\",\"Ways\":\""+reader["Ways"].ToString()+"\",\"Times\":\""+reader["Times"].ToString()+"\",\"TimeInteral\":\""+reader["TimeInteral"].ToString()+"\"");
        }
        reader.Close();
        string firstequip = "SELECT equipment.Name as equipmentname,appointment_accelerate.Date as begindate,appointment_accelerate.Begin as begin,appointment_accelerate.End as end,equipment.Timelength as timelength,equipment.EndTimeTPM as pmend,equipment.BeginTimeAM as ambegin,equipment.State as equipmentstate FROM treatmentrecord,equipment,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Equipment_ID=equipment.ID and treatmentrecord.Treatment_ID=@treat order by appointment_accelerate.Date,appointment_accelerate.Begin asc";
        reader = sqlOperation.ExecuteReader(firstequip);
        if (reader.Read())
        {
            backText.Append(",\"equipmentname\":\"" + reader["equipmentname"].ToString() + "\",\"timelength\":\"" + reader["timelength"].ToString() + "\",\"begindate\":\"" + reader["begindate"].ToString() + "\",\"begin\":\"" + reader["begin"].ToString() + "\",\"end\":\"" + reader["end"].ToString() + "\",\"ambegin\":\"" + reader["ambegin"].ToString() + "\",\"pmend\":\"" + reader["pmend"].ToString() + "\",\"equipmentstate\":\"" + reader["equipmentstate"].ToString() + "\"");
          
        }
        reader.Close();
        int count = 0;
        int appointid = 0;
        string date = "";
        string begin = "";
        string begindate = "";
        string beginbegin = "";
        string beginend = "";
        string sqlcommand2 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date>@nowdate) or((Date=@nowdate)and Begin>@nowbegin)) order by Date desc,Begin desc";
        sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
        sqlOperation.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
        reader = sqlOperation.ExecuteReader(sqlcommand2);
        while (reader.Read())
        {
            if (reader["Treat_User_ID"].ToString() == "")
            {
                if (begindate == "")
                {
                    begindate = reader["Date"].ToString();
                    beginbegin = reader["Begin"].ToString();
                    beginend = reader["End"].ToString();
                }
                
            }
            count++;
        }
        reader.Close();
        

        string sqlcommand = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date<@nowdate) or((Date=@nowdate)and Begin<@nowbegin)) order by Date desc,Begin desc";
        reader = sqlOperation.ExecuteReader(sqlcommand);
        while (reader.Read())
        {
            if (reader["Treat_User_ID"].ToString() != "")
            {
               appointid = int.Parse(reader["Appointment_ID"].ToString());
                date = reader["Date"].ToString();
                begin = reader["Begin"].ToString();
                if (begindate == "")
                {
                    begindate = reader["Date"].ToString();
                    beginbegin = reader["Begin"].ToString();
                    beginend = reader["End"].ToString();
                }
                break;
            }
        }
        reader.Close();
      
      if (appointid != 0)
        {
            string sqlcommand1 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and (Date<@date or (Date=@date and Begin<=@begin)) order by Date,Begin asc";
            sqlOperation.AddParameterWithValue("@date", date);
            sqlOperation.AddParameterWithValue("@begin", begin);
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlcommand1);
            while (reader1.Read())
            {
                if (reader1["Treat_User_ID"].ToString() != "")
                {
                    count++;
                }

            }
            reader1.Close();
        }
        string totalnumber = "select TotalNumber from treatment where ID=@treat";
        string total = sqlOperation.ExecuteScalar(totalnumber);
        if (begindate == "")
        {
            begindate = DateTime.Now.Date.ToString();
        }
        if (total != "")
        {

            backText.Append(",\"total\":\"" + total + "\",\"appointnumber\":\"" + count + "\",\"newbegindate\":\"" + begindate + "\",\"newbegin\":\"" + beginbegin + "\",\"newend\":\"" + beginend + "\"}");
 
        }
        return backText.ToString();
    }


}