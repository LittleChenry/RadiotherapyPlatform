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
        string firstequip = "SELECT equipment.Name as equipmentname,appointment_accelerate.Date as begindate,equipment.Timelength as timelength,equipment.BeginTimeAM as ambegin,equipment.State as equipmentstate FROM treatmentrecord,equipment,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Equipment_ID=equipment.ID and treatmentrecord.Treatment_ID=@treat order by appointment_accelerate.Date,appointment_accelerate.Begin asc";
        reader = sqlOperation.ExecuteReader(firstequip);
        if (reader.Read())
        {
            backText.Append(",\"equipmentname\":\"" + reader["equipmentname"].ToString() + "\",\"begindate\":\"" + reader["begindate"].ToString() + "\",\"timelength\":\"" + reader["timelength"].ToString() + "\",\"ambegin\":\"" + reader["ambegin"].ToString() + "\",\"equipmentstate\":\"" + reader["equipmentstate"].ToString()+"\"");
          
        }
        reader.Close();
        int count = 0;
        int appointid = 0;
        string date = "";
        string begin = "";
        string sqlcommand = "select Treat_User_ID,Appointment_ID,Date,Begin from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID order by Date desc,Begin desc";
         reader = sqlOperation.ExecuteReader(sqlcommand);
        while (reader.Read())
        {
            if (reader["Treat_User_ID"].ToString() == "")
            {
                count++;
            }
            else
            {
                appointid = int.Parse(reader["Appointment_ID"].ToString());
                date = reader["Date"].ToString();
                begin = reader["Begin"].ToString();
                break;
            }
        }
        reader.Close();
        if (appointid != 0)
        {
            string sqlcommand1 = "select Treat_User_ID from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and (Date<@date or (Date=@date and Begin<=@begin)) order by Date,Begin asc";
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
        if (total != "")
        {

            backText.Append(",\"total\":\"" + total + "\",\"appointnumber\":\"" + count + "\"}");
 
        }
        return backText.ToString();
    }


}