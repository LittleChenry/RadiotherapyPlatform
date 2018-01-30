<%@ WebHandler Language="C#" Class="achievealldesign" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class achievealldesign : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getalldesign(context);
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
    private string getalldesign(HttpContext context)
    {
        string patientid = context.Request["patientid"];
        string chid = context.Request["chid"];
        string treatid = context.Request["treatmentid"];
        string equipid = "";
        MySql.Data.MySqlClient.MySqlDataReader reader = null;
        if (treatid == "")
        {
            string equipidcommand = "select DISTINCT(equipment) from fieldinfomation where fieldinfomation.ChildDesign_ID=@chid";
            sqlOperation.AddParameterWithValue("@chid", chid);
            equipid = sqlOperation.ExecuteScalar(equipidcommand);
           
        }
        else
        {
            string childcommand = "select DISTINCT(ID) from childdesign where Treatment_ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            reader = sqlOperation.ExecuteReader(childcommand);
            if (reader.Read())
            {
                chid = reader["ID"].ToString();
            }
            reader.Close();
            if (chid != "")
            {
                string equipidcommand = "select DISTINCT(equipment) from fieldinfomation where fieldinfomation.ChildDesign_ID=@chid";
                sqlOperation.AddParameterWithValue("@chid", chid);
                equipid = sqlOperation.ExecuteScalar(equipidcommand);
            }
            else
            {
                return "{\"info\":[]}";
            }
        }
        StringBuilder info = new StringBuilder("{\"info\":[");
        
        string childdesigncommand = "select DISTINCT(ChildDesign_ID) as chiddesign from fieldinfomation,childdesign,treatment where fieldinfomation.equipment=@equip and fieldinfomation.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid";
        sqlOperation.AddParameterWithValue("@equip", equipid);
        sqlOperation.AddParameterWithValue("@pid", patientid);
        reader = sqlOperation.ExecuteReader(childdesigncommand);
        ArrayList chiddesignidlist = new ArrayList();
        while (reader.Read())
        {
            chiddesignidlist.Add(reader["chiddesign"].ToString());  
        }
        reader.Close();
        string str = string.Join(",", (string[])chiddesignidlist.ToArray(typeof(string)));
        if (str == "")
        {
            info.Append("]}");
            return info.ToString();
        }

        string alldesignlistcommand = "select appointment_accelerate.Date as appadate,appointment_accelerate.Begin as appbegin,appointment_accelerate.End as append,treatmentrecord.Treat_User_ID as treat,treatmentrecord.IsFirst as isfirst,treatment.Treatmentdescribe as treatname,treatment.ID as treatid,childdesign.DesignName as childname,childdesign.ID as chid  from appointment_accelerate,treatmentrecord,childdesign,treatment where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID and childdesign.ID  in (" + str + ") ORDER BY appointment_accelerate.Date asc,appointment_accelerate.Begin asc";
        reader = sqlOperation.ExecuteReader(alldesignlistcommand);
        int flag = 0;
        int begincheck = 0;
        int chiddesigncheck = 0;
        string tempdate = "";
        string tempbegin = "";
        while (reader.Read())
        {

            if (tempdate != reader["appadate"].ToString())
            {
                if (flag == 0)
                {
                    info.Append("{\"appdate\":\"" + reader["appadate"].ToString() + "\",\"timeinfo\":[");
                }
                else
                {
                    info.Append("]}]},");
                    info.Append("{\"appdate\":\"" + reader["appadate"].ToString() + "\",\"timeinfo\":[");
                }
                tempbegin = "";
                begincheck = 0;
                chiddesigncheck = 0;

            }
         
            if (tempbegin != reader["appbegin"].ToString())
            {
                if (begincheck != 0)
                {
                    info.Append("]},");
                    info.Append("{\"begintime\":\"" + reader["appbegin"].ToString() + "\",\"endtime\":\"" + reader["append"].ToString() + "\",\"childgesin\":[");
                }
                else
                {
                    info.Append("{\"begintime\":\"" + reader["appbegin"].ToString() + "\",\"endtime\":\"" + reader["append"].ToString() + "\",\"childgesin\":[");
                }
                chiddesigncheck = 0;

            }
                
            if (chiddesigncheck != 0)
            {
                info.Append(",");
                info.Append("{\"designname\":\"" + reader["childname"].ToString() + "\",\"chid\":\"" + reader["chid"].ToString() + "\",\"treatid\":\"" + reader["treatid"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treatname"].ToString() + "\",\"isfirst\":\"" + reader["isfirst"].ToString() + "\",\"istreated\":\"" + reader["treat"].ToString() + "\"}");
            }
            else
            {
                info.Append("{\"designname\":\"" + reader["childname"].ToString() + "\",\"chid\":\"" + reader["chid"].ToString() + "\",\"treatid\":\"" + reader["treatid"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treatname"].ToString() + "\",\"isfirst\":\"" + reader["isfirst"].ToString() + "\",\"istreated\":\"" + reader["treat"].ToString() + "\"}");
            }
            chiddesigncheck++;
            begincheck++;
            tempdate = reader["appadate"].ToString();
            tempbegin = reader["appbegin"].ToString();
            flag++;
          
        }
        if (flag != 0)
        {
            info.Append("]}]}]}");

        }
        else
        {   
            info.Append("]}");
        }
   
        return info.ToString();

    }
}