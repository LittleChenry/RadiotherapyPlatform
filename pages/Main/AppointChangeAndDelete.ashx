﻿<%@ WebHandler Language="C#" Class="AppointChangeAndDelete" %>

using System;
using System.Web;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class AppointChangeAndDelete : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = deleteandchange(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string deleteandchange(HttpContext context)
    {
        string oldappoint = context.Request["oldappoint"];
        string newappoint = context.Request["newappoint"];
        string way = context.Request["operateway"];
        JArray ja = (JArray)JsonConvert.DeserializeObject(oldappoint);
        JArray jb = (JArray)JsonConvert.DeserializeObject(newappoint);
        if (way == "0")
        {
            int i = 0;
            for(i = 0; i < ja.Count; i++)
            {
                string deletecommand = "delete from appointment_accelerate where ID=@appointid";
                sqlOperation.AddParameterWithValue("@appointid", ja[i]["appointid"]);
                sqlOperation.ExecuteNonQuery(deletecommand);
                string deletecommand2= "delete from treatmentrecord where Appointment_ID=@appointid";
                int success=sqlOperation.ExecuteNonQuery(deletecommand2);
                if (success == 0)
                {
                    return "failure";
                }
                
            }
            return "success";
              
        }
        if (way == "1")
        {
            int i = 0;
            for (i = 0; i < ja.Count; i++)
            {
                string selectcommand = "select Task,Patient_ID,Date,Equipment_ID,Begin,End,Treatment_ID,IsDouble from appointment_accelerate where ID=@appointid";
                sqlOperation.AddParameterWithValue("@appointid", ja[i]["appointid"]);
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectcommand);
                string task = "";
                string pid = "";
                string date = "";
                string equipid = "";
                string begin = "";
                string end = "";
                string treatid = "";
                string isdouble = "";
                string applyuser = "";
                string applytime = "";
                if (reader.Read())
                {
                    task = reader["Task"].ToString();
                    pid = reader["Patient_ID"].ToString();
                    date = reader["Date"].ToString();
                    equipid = reader["Equipment_ID"].ToString();
                    begin = reader["Begin"].ToString();
                    end = reader["End"].ToString();
                    treatid = reader["Treatment_ID"].ToString();
                    isdouble = reader["IsDouble"].ToString();
                }
                reader.Close();
                string selectuserandtime = "select ApplyUser,ApplyTime from treatmentrecord where Appointment_ID=@appointid";
                sqlOperation.AddParameterWithValue("@appointid", ja[i]["appointid"]);
                reader = sqlOperation.ExecuteReader(selectuserandtime);
                if (reader.Read())
                {
                    applyuser = reader["ApplyUser"].ToString();
                    applytime = reader["ApplyTime"].ToString();

                }
                string deletecommand = "delete from appointment_accelerate where ID=@appointid";
                sqlOperation.ExecuteNonQuery(deletecommand);
                string deletecommand2 = "delete from treatmentrecord where Appointment_ID=@appointid";
                sqlOperation.ExecuteNonQuery(deletecommand2);
                string strcommand1 = "insert into appointment_accelerate(Equipment_ID,Date,Begin,End,Treatment_ID,State,Completed,isdouble) values(@equip,@date,@begin,@end,@Treatment_ID,0,0,@isdouble);SELECT @@IDENTITY ";
                sqlOperation.AddParameterWithValue("@Treatment_ID", treatid);
                sqlOperation.AddParameterWithValue("@isdouble", int.Parse(isdouble));
                sqlOperation.AddParameterWithValue("@equip", equipid);
                sqlOperation.AddParameterWithValue("@date", jb[i]["date"]);
                sqlOperation.AddParameterWithValue("@begin", jb[i]["begin"]);
                sqlOperation.AddParameterWithValue("@end", jb[i]["end"]);
                string appointid = sqlOperation.ExecuteScalar(strcommand1);
                string strSqlCommand = "INSERT INTO treatmentrecord(Treatment_ID,Appointment_ID,ApplyUser,ApplyTime) " +
                                               "VALUES(@Treatment_ID,@appointid,@ApplyUser,@ApplyTime)";
                sqlOperation.AddParameterWithValue("@ApplyTime", applytime);
                sqlOperation.AddParameterWithValue("@ApplyUser", applyuser);
                int success = sqlOperation.ExecuteNonQuery(strSqlCommand);
                if (success == 0)
                {
                    return "failure";
                }
            
            }
            return "success";
        }
        return "failure";
    }

}