<%@ WebHandler Language="C#" Class="processXlS" %>

using System;
using System.Web;
using System.Collections;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


public class processXlS : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string json = processdata();
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(json);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string processdata()
    {
        string strpath = "E:/plan.csv"; //cvs文件路径
        string strline;
        string [] aryline;

        System.IO.StreamReader mysr = new System.IO.StreamReader(strpath);

        while((strline = mysr.ReadLine()) != null)
        {
             aryline = strline.Split(new char[]{','});
             string newtreatmentcommand = "select max(treatment.ID) from treatment,patient,childdesign where patient.ID=treatment.Patient_ID and childdesign.Treatment_ID=treatment.ID and patient.Radiotherapy_ID=@radio";
            sqlOperation.AddParameterWithValue("@radio",aryline[0]);
            string treatid = sqlOperation.ExecuteScalar(newtreatmentcommand);
            string newchildcommand = "select max(childdesign.ID) from childdesign where childdesign.Treatment_ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            string childid = sqlOperation.ExecuteScalar(newchildcommand);
            //医师预约之前需要清除当前子计划的所有已有预约信息
            string selectcommand = "select treatmentrecord.Appointment_ID as appointid,treatmentrecord.ID as treatmentrecordid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and ChildDesign_ID=@chid";
            sqlOperation.AddParameterWithValue("@chid", childid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectcommand);
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
                sqlOperation.AddParameterWithValue("@chid", childid);
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
            
            
            string update = "update childdesign set Totalnumber=@total,fillNumber=@fillnumber where ID=@chid";
            sqlOperation.AddParameterWithValue("@total", int.Parse(aryline[1]) - int.Parse(aryline[2]));
            sqlOperation.AddParameterWithValue("@fillnumber", int.Parse(aryline[2]));
            sqlOperation.AddParameterWithValue("@chid", int.Parse(childid));
            sqlOperation.ExecuteNonQuery(update);

        }
        return "success";
    }
        
    }
