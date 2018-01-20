<%@ WebHandler Language="C#" Class="getPatientInfoNew" %>

using System;
using System.Web;
using System.Text;
using System.Collections;

public class getPatientInfoNew : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getpatientinfo(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getpatientinfo(HttpContext context)
    {
        string equipid = context.Request["equipid"];
        string command = "select Name from equipment where ID=@equipid";
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        string name = sqlOperation.ExecuteScalar(command);
        string equipment = "";
        if (name == "Precise加速器")
        {
            equipment = "2964";
        }
        else
        {
            equipment = "1650";
        }

        string patientcommand = "select Distinct(treatment.Patient_ID) as patientid from fieldinfomation,childdesign,treatment where fieldinfomation.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID and (childdesign.state=2 or childdesign.state=3) and fieldinfomation.equipment=@equip";
        sqlOperation.AddParameterWithValue("@equip", equipment);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(patientcommand);
        ArrayList patientList = new ArrayList();
        while (reader.Read())
        {
            patientList.Add(reader["patientid"].ToString());

        }
        reader.Close();
        int temp = 1;
        StringBuilder info = new StringBuilder("{\"patientinfo\":[");
        MySql.Data.MySqlClient.MySqlDataReader reader1 = null;
        foreach (string element in patientList)
        {
            string patientinfocommand = "select Name,Gender,Age from patient where ID=@pid";
            sqlOperation.AddParameterWithValue("@pid", element);
            reader1 = sqlOperation.ExecuteReader(patientinfocommand);
            if (reader1.Read())
            {
                info.Append("{\"name\":\"" + reader1["Name"].ToString() + "\",\"Gender\":\"" + sex(reader1["Gender"].ToString()) + "\",\"Age\":\"" + reader1["Age"].ToString() + "\",\"groupname\":\"");
                string groupcommand = "select user.Name as doctor,groups.groupName as groupname from groups,treatment,user,groups2user where groups2user.Group_ID=groups.ID and treatment.Group_ID=groups2user.ID and treatment.Patient_ID=@pid and treatment.Belongingdoctor=user.ID";
                sqlOperation1.AddParameterWithValue("@pid", element);
                MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(groupcommand);
                if (reader2.Read())
                {
                    info.Append(reader2["groupname"].ToString() + "\",\"doctor\":\"" + reader2["doctor"].ToString() + "\"}");
                }
                reader2.Close();
            
            }
            reader1.Close();
            if (temp <= patientList.Count - 1)
            {
                info.Append(",");
                temp++;
            }
        }
        info.Append("],\"machineinfo\":[");
        string sqlCommand = "SELECT * FROM equipment WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", equipid);
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
                    info.Append("{\"Begin\":\"" + begin + "\",\"End\":\"" + end + "\"}");
                    if (j < AMFrequency - 1)
                    {
                        info.Append(",");
                    }
                    if (j == AMFrequency - 1 && PMFrequency > 0)
                    {
                        info.Append(",");
                    }

                }
                for (int k = 0; k < PMFrequency; k++)
                {
                    int Pbegin = intPMBeg + (k * int.Parse(Oncetime));
                    int PEnd = Pbegin + int.Parse(Oncetime);
                    int time = int.Parse(Pbegin.ToString());
                    int hour = time / 60;
                    int minute = time - (time / 60) * 60;
                    info.Append("{\"Begin\":\"" + Pbegin + "\",\"End\":\"" + PEnd + "\"}");
                    if (k < PMFrequency - 1)
                    {
                        info.Append(",");
                    }
                }

            }
            reader.Close();
        }
        info.Append("],\"basicinfo\":");
        string basic= "SELECT * FROM equipment WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", equipid);
        reader = sqlOperation.ExecuteReader(basic);
        if (reader.Read())
        {
            info.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"Timelength\":\"" + reader["Timelength"].ToString() + "\",\"BeginTimeAM\":\"" + reader["BeginTimeAM"].ToString() + "\",\"EndTimeAM\":\"" + reader["EndTimeAM"].ToString() + "\",\"BegTimePM\":\"" + reader["BegTimePM"].ToString() + "\",\"EndTimeTPM\":\"" + reader["EndTimeTPM"].ToString() + "\"}");
        }
        info.Append("}");
        return info.ToString();
        
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