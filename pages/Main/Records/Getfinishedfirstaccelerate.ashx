﻿<%@ WebHandler Language="C#" Class="Getfinishedfirstaccelerate" %>

using System;
using System.Web;
using System.Text;

public class Getfinishedfirstaccelerate : IHttpHandler {
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = patientfixInformation(context);
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string patientfixInformation(HttpContext context)
    {
        string treatid = context.Request["treatmentID"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select Begin,End,Date,equipment.Name as equipname from treatmentrecord,appointment,equipment where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment.ID and appointment.Equipment_ID=equipment.ID";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backText.Append("{\"Begin\":\"" + reader["Begin"].ToString() +"\",\"End\":\"" + reader["End"].ToString() +
                 "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() +"\"}");
            backText.Append(",");
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backText.ToString();

    }

}