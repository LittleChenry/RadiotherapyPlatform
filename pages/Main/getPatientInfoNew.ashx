﻿<%@ WebHandler Language="C#" Class="getPatientInfoNew" %>

using System;
using System.Web;
using System.Text;
using System.Collections;

public class getPatientInfoNew : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
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
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
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
        string command = "select equipmenttype.Type as equiptype from equipment,equipmenttype where equipment.ID=@equipid and equipment.EquipmentType=equipmenttype.ID";
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        string equiptype = sqlOperation.ExecuteScalar(command);
        string equipment = System.Text.RegularExpressions.Regex.Replace(equiptype, @"[^0-9]+", "");


        string patientcommand = "select Distinct(treatment.Patient_ID) as patientid from fieldinfomation,childdesign,treatment where fieldinfomation.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID and childdesign.state=3 and fieldinfomation.equipment like '%" + equipment+"%'";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(patientcommand);
        ArrayList patientList = new ArrayList();
        while (reader.Read())
        {
            string selectcommand = "select Distinct(treatment.ID) as treatid from fieldinfomation,childdesign,treatment where fieldinfomation.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID and childdesign.state=3 and fieldinfomation.equipment like'%" + equipment+"%' and treatment.Patient_ID=@pid";
            sqlOperation1.AddParameterWithValue("@pid", reader["patientid"].ToString());
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(selectcommand);
            ArrayList treatmentidlist = new ArrayList();
            while (reader1.Read())
            {
                treatmentidlist.Add(reader1["treatid"].ToString());
            }
            reader1.Close();
            string str = string.Join(",", (string[])treatmentidlist.ToArray(typeof(string)));
            if (str == "")
            {
                continue;
            }
            Boolean flag = false;
            string designcommand = "select childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and childdesign.state=3 and treatment.ID in (" + str+")";
            sqlOperation1.AddParameterWithValue("@pid", reader["patientid"].ToString());
            reader1 = sqlOperation1.ExecuteReader(designcommand);
            while (reader1.Read())
            {
                int count = 0;
                int appointid = 0;
                string maxdate = "无";
                string date = "";
                string begin = "";
                string sqlcommand2 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date>@nowdate) or((Date=@nowdate)and Begin>@nowbegin)) order by Date desc,Begin desc";
                sqlOperation2.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                sqlOperation2.AddParameterWithValue("@chid", reader1["chid"].ToString());
                sqlOperation2.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation2.ExecuteReader(sqlcommand2);
                while (reader2.Read())
                {
                    if (reader2["Treat_User_ID"].ToString() == "")
                    {
                        appointid = int.Parse(reader2["Appointment_ID"].ToString());
                        if (maxdate == "无")
                        {
                            maxdate = reader2["Date"].ToString();
                        }

                    }
                    count++;
                }
                reader2.Close();
                string sqlcommand = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date<@nowdate) or((Date=@nowdate)and Begin<@nowbegin)) order by Date desc,Begin desc";
                reader2 = sqlOperation2.ExecuteReader(sqlcommand);
                while (reader2.Read())
                {
                    if (reader2["Treat_User_ID"].ToString() != "")
                    {
                        appointid = int.Parse(reader2["Appointment_ID"].ToString());
                        date = reader2["Date"].ToString();
                        begin = reader2["Begin"].ToString();
                        break;
                    }
                }
                reader2.Close();

                if (appointid != 0)
                {
                    string sqlcommand1 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and (Date<@date or (Date=@date and Begin<=@begin)) order by Date,Begin asc";
                    sqlOperation2.AddParameterWithValue("@date", date);
                    sqlOperation2.AddParameterWithValue("@begin", begin);
                    reader2= sqlOperation2.ExecuteReader(sqlcommand1);
                    while (reader2.Read())
                    {
                        if (reader2["Treat_User_ID"].ToString() != "")
                        {
                            count++;
                        }

                    }
                    reader2.Close();
                }
                int rest=int.Parse(reader1["total"].ToString()) - count;
                if (rest!= 0)
                {
                    flag = true;
                }
            }
            reader1.Close();
            if (flag == true)
            {
                patientList.Add(reader["patientid"].ToString());
            }

        }
        reader.Close();
        int temp = 1;
        StringBuilder info = new StringBuilder("{\"patientinfo\":[");
        foreach (string element in patientList)
        {
            string patientinfocommand = "select ID,Name,Gender,Age,Radiotherapy_ID from patient where ID=@pid";
            sqlOperation.AddParameterWithValue("@pid", element);
            reader = sqlOperation.ExecuteReader(patientinfocommand);
            if (reader.Read())
            {
                info.Append("{\"name\":\"" + reader["Name"].ToString() + "\",\"Gender\":\"" + sex(reader["Gender"].ToString()) + "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"patientid\":\"" + reader["ID"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() + "\",\"groupname\":\"");
                string groupcommand = "select user.Name as doctor,groups.groupName as groupname from groups,treatment,user,groups2user where groups2user.Group_ID=groups.ID and treatment.Group_ID=groups2user.ID and treatment.Patient_ID=@pid and treatment.Belongingdoctor=user.ID";
                sqlOperation1.AddParameterWithValue("@pid", element);
                MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(groupcommand);
                if (reader2.Read())
                {
                    info.Append(reader2["groupname"].ToString() + "\",\"doctor\":\"" + reader2["doctor"].ToString() + "\"}");
                }
                reader2.Close();
            
            }
            reader.Close();
            if (temp <= patientList.Count - 1)
            {
                info.Append(",");
                temp++;
            }
        }
        info.Append("],\"doctortime\":[");
        string countnum = "select count(*) FROM firstacctime";
        int number=int.Parse(sqlOperation.ExecuteScalar(countnum));
        int tempcoun=1;
        string sqlCommand = "SELECT begintime,endtime FROM firstacctime";
        reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            info.Append("{\"begin\":\""+reader["begintime"].ToString()+"\",\"end\":\""+reader["endtime"].ToString()+"\"}");
            if (tempcoun < number)
            {
                info.Append(",");
            }
            tempcoun++;
            
        }
        reader.Close();
        info.Append("],\"basicinfo\":");
        string basic= "SELECT * FROM equipment WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", equipid);
        reader = sqlOperation.ExecuteReader(basic);
        if (reader.Read())
        {
            info.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"Timelength\":\"" + reader["Timelength"].ToString() + "\",\"BeginTimeAM\":\"" + reader["BeginTimeAM"].ToString() + "\",\"EndTimeAM\":\"" + reader["EndTimeAM"].ToString() + "\",\"BegTimePM\":\"" + reader["BegTimePM"].ToString() + "\",\"EndTimeTPM\":\"" + reader["EndTimeTPM"].ToString() + "\"}");
        }
        else
        {
            info.Append("\"\"");
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