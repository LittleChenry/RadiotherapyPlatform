﻿<%@ WebHandler Language="C#" Class="getconfirminfomation" %>

using System;
using System.Web;
 using System.Text;

public class getconfirminfomation : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = treatrecord(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
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
    private string treatrecord(HttpContext context)
    {

        int treatid = Convert.ToInt32(context.Request.QueryString["treatID"]);
        int appointid = Convert.ToInt32(context.Request.QueryString["appoint"]);
 
        string sqlcommand1 = "select IlluminatedNumber,MachineNumbe,DosagePriority from design,treatment where design.ID=treatment.Design_ID and treatment.ID=@treat";
        sqlOperation.AddParameterWithValue("treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand1);
        string IlluminatedNumber = "";
        string MachineNumbe = "";
        int DosagePriority = 0;
        if (reader.Read())
        {
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] { '&' })[0];
            string[] dosage = Priority.Split(new char[1] { ';' });
            int k = 0;
            int finaldos = 0;
            for (k = 0; k <= dosage.Length - 2; k++)
            {
                if (Convert.ToInt32(dosage[k].Split(new char[1] { ',' })[3]) >= finaldos)
                {
                    finaldos = Convert.ToInt32(dosage[k].Split(new char[1] { ',' })[3]);
                }
            }
            IlluminatedNumber = reader["IlluminatedNumber"].ToString();
            MachineNumbe = reader["MachineNumbe"].ToString();
            DosagePriority = finaldos;
        }
        reader.Close();
        string sqlcommand2 = "select count(*) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL";
        int finishedtimes = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        backText.Append("{\"finishedtimes\":\"" + finishedtimes.ToString() + "\",\"IlluminatedNumber\":\"" + IlluminatedNumber + "\",\"MachineNumbe\":\"" + MachineNumbe + "\",\"DosagePriority\":\"" + DosagePriority.ToString() + "\"}");
        backText.Append("]}");
        return backText.ToString(); 
        }
    }