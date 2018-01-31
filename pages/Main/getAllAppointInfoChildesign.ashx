<%@ WebHandler Language="C#" Class="getAllAppointInfoChildesign" %>

using System;
using System.Web;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class getAllAppointInfoChildesign : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getallchilddeigninfo(context);
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
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getallchilddeigninfo(HttpContext context)
    {
        
        string patientid = context.Request["patientid"];
        string equipid = context.Request["equipid"];
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
        StringBuilder backstring = new StringBuilder("{\"backinfo\":[");
        string str = string.Join(",", (string[])childdesignlist.ToArray(typeof(string)));
        if (str == "")
        {
            backstring.Append("]}");
            return backstring.ToString();
        }
        else
        {
            string selectcomandforback = "select treatment.Treatmentdescribe as treat,childdesign.DesignName as designname,appointment_accelerate.Date as appointdate,appointment_accelerate.Begin as begintime,appointment_accelerate.End as endtime,treatmentrecord.IsFirst as isFirst,treatmentrecord.Isban as isban,treatmentrecord.Treat_User_ID as treatuser from treatmentrecord,appointment_accelerate,childdesign,treatment where childdesign.Treatment_ID=treatment.ID and treatmentrecord.ChildDesign_ID=childdesign.ID and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ChildDesign_ID in ("+str+") ORDER BY Date asc,Begin asc";
            reader = sqlOperation.ExecuteReader(selectcomandforback);
            string tempdate = "";
            string begintemp = "";
            int kou = 0;
            int ku = 0;
            while (reader.Read())
            {
                string completed = "";
                if (reader["treatuser"].ToString() == "")
                {
                    completed = "0";
                }
                else
                {
                    completed = "1";
                }
                if (tempdate != reader["appointdate"].ToString() || begintemp != reader["begintime"].ToString())
                {
                    ku = 0;
                    if (kou == 0)
                    {
                        backstring.Append("{\"date\":\"" + reader["appointdate"].ToString() + "\",\"begin\":\"" + reader["begintime"].ToString() + "\",\"end\":\"" + reader["endtime"].ToString() + "\",\"chidinfogroup\":[");
                    }
                    else
                    {
                        backstring.Append("]},");
                        backstring.Append("{\"date\":\"" + reader["appointdate"].ToString() + "\",\"begin\":\"" + reader["begintime"].ToString() + "\",\"end\":\"" + reader["endtime"].ToString() + "\",\"chidinfogroup\":[");
                    }

                    backstring.Append("{\"designname\":\"" + reader["designname"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treat"].ToString() + "\",\"isFirst\":\"" + reader["isFirst"].ToString() + "\",\"isban\":\"" + reader["isban"].ToString() + "\",\"Completed\":\"" + completed + "\"}");
                    ku++;
                }
                else
                {
                    if (ku == 0)
                    {
                        backstring.Append("{\"designname\":\"" + reader["designname"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treat"].ToString() + "\",\"isFirst\":\"" + reader["isFirst"].ToString() + "\",\"isban\":\"" + reader["isban"].ToString() + "\",\"Completed\":\"" + completed + "\"}");
                    }
                    else
                    {
                        backstring.Append(",");
                        backstring.Append("{\"designname\":\"" + reader["designname"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["treat"].ToString() + "\",\"isFirst\":\"" + reader["isFirst"].ToString() + "\",\"isban\":\"" + reader["isban"].ToString() + "\",\"Completed\":\"" + completed + "\"}");

                    }
                    ku++;
                }
                kou++;
                tempdate = reader["appointdate"].ToString();
                begintemp = reader["begintime"].ToString();
            }
            reader.Close();
            if (kou == 0)
            {
                backstring.Append("]}");
            }
            else
            {
                backstring.Append("]}]}");
            }
            return backstring.ToString();
  
        }
    }

}