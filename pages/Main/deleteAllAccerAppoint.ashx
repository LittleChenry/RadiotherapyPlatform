<%@ WebHandler Language="C#" Class="deleteAllAccerAppoint" %>
using System;
using System.Web;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class deleteAllAccerAppoint : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = deleteallapoint(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string deleteallapoint(HttpContext context)
    {

        string patientid = context.Request["patientid"];
        string equipid = context.Request["equipid"];
        string role = context.Request["role"];
        string command = "select equipmenttype.Type as equiptype from equipment,equipmenttype where equipment.ID=@equipid and equipment.EquipmentType=equipmenttype.ID";
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        string equiptype = sqlOperation.ExecuteScalar(command);
        string equipment = System.Text.RegularExpressions.Regex.Replace(equiptype, @"[^0-9]+", "");
        string childdeigncommand = "select DISTINCT(childdesign.ID) as chid from fieldinfomation,childdesign,treatment where equipment like '%" + equipment + "%' and childdesign.ID=fieldinfomation.ChildDesign_ID and childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(childdeigncommand);
        ArrayList childdesignlist = new ArrayList();
        while (reader.Read())
        {
            childdesignlist.Add(reader["chid"].ToString());
        }
        reader.Close();
        if (role == "医师")
        {
            for (int k = 0; k < childdesignlist.Count; k++)
            {
                string chid = childdesignlist[k].ToString();
                string selectcommand = "select treatmentrecord.Appointment_ID as appointid,treatmentrecord.ID as treatmentrecordid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and ChildDesign_ID=@chid and Treat_User_ID is NULL and isfirst=1 and Date>=@nowdate";
                sqlOperation.AddParameterWithValue("@chid", chid);
                sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                sqlOperation.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                reader = sqlOperation.ExecuteReader(selectcommand);
                ArrayList arrayforapp = new ArrayList();
                ArrayList arrayforapp2 = new ArrayList();
                ArrayList treatmentarray = new ArrayList();
                while (reader.Read())
                {
                    arrayforapp.Add(reader["appointid"].ToString());
                    treatmentarray.Add(reader["treatmentrecordid"].ToString());
                }
                reader.Close();
                for (int i = 0; i < arrayforapp.Count; i++)
                {
                    string isexists = "select count(*) from treatmentrecord where ChildDesign_ID<>@chid and Appointment_ID=@appoint";
                    sqlOperation.AddParameterWithValue("@chid", chid);
                    sqlOperation.AddParameterWithValue("@appoint", arrayforapp[i]);
                    int count = int.Parse(sqlOperation.ExecuteScalar(isexists));
                    if (count == 0)
                    {
                        arrayforapp2.Add(arrayforapp[i]);
                    }
                }
                for (int i = 0; i < arrayforapp2.Count; i++)
                {
                    string deletecommand = "delete from appointment_accelerate where ID=@appoint";
                    sqlOperation.AddParameterWithValue("@appoint", arrayforapp2[i]);
                    sqlOperation.ExecuteNonQuery(deletecommand);
                }
                for (int i = 0; i < treatmentarray.Count; i++)
                {
                    string deletecommand2 = "delete from treatmentrecord where ID=@tretmentid";
                    sqlOperation.AddParameterWithValue("@tretmentid", treatmentarray[i]);
                    sqlOperation.ExecuteNonQuery(deletecommand2);
                }
            }
            return "success";
        }else
        {
            for (int k = 0; k < childdesignlist.Count; k++)
            {
                string chid = childdesignlist[k].ToString();
                string selectcommand = "select treatmentrecord.Appointment_ID as appointid,treatmentrecord.ID as treatmentrecordid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and ChildDesign_ID=@chid and Treat_User_ID is NULL and isfirst<>1 and Date>=@nowdate";
                sqlOperation.AddParameterWithValue("@chid", chid);
                sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                sqlOperation.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                reader = sqlOperation.ExecuteReader(selectcommand);
                ArrayList arrayforapp = new ArrayList();
                ArrayList arrayforapp2 = new ArrayList();
                ArrayList treatmentarray = new ArrayList();
                while (reader.Read())
                {
                    arrayforapp.Add(reader["appointid"].ToString());
                    treatmentarray.Add(reader["treatmentrecordid"].ToString());
                }
                reader.Close();
                for (int i = 0; i < arrayforapp.Count; i++)
                {
                    string isexists = "select count(*) from treatmentrecord where ChildDesign_ID<>@chid and Appointment_ID=@appoint";
                    sqlOperation.AddParameterWithValue("@chid", chid);
                    sqlOperation.AddParameterWithValue("@appoint", arrayforapp[i]);
                    int count = int.Parse(sqlOperation.ExecuteScalar(isexists));
                    if (count == 0)
                    {
                        arrayforapp2.Add(arrayforapp[i]);
                    }
                }
                for (int i = 0; i < arrayforapp2.Count; i++)
                {
                    string deletecommand = "delete from appointment_accelerate where ID=@appoint";
                    sqlOperation.AddParameterWithValue("@appoint", arrayforapp2[i]);
                    sqlOperation.ExecuteNonQuery(deletecommand);
                }
                for (int i = 0; i < treatmentarray.Count; i++)
                {
                    string deletecommand2 = "delete from treatmentrecord where ID=@tretmentid";
                    sqlOperation.AddParameterWithValue("@tretmentid", treatmentarray[i]);
                    sqlOperation.ExecuteNonQuery(deletecommand2);
                }
            }
            return "success";
        }
    
    
    
    }
    

}