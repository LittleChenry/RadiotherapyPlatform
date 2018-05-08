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
        string strpath = "E:/lala.csv"; //cvs文件路径
        string strline;
        string [] aryline;

        System.IO.StreamReader mysr = new System.IO.StreamReader(strpath);

        while((strline = mysr.ReadLine()) != null)
        {
             aryline = strline.Split(new char[]{','});
            string newtreatmentcommand = "select max(treatment.ID) from treatment,patient where patient.ID=treatment.Patient_ID and patient.Radiotherapy_ID=@radio";
            sqlOperation.AddParameterWithValue("@radio",aryline[0]);
            string treatid = sqlOperation.ExecuteScalar(newtreatmentcommand);
            string newchildcommand = "select max(childdesign.ID) from childdesign where childdesign.Treatment_ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            string childid = sqlOperation.ExecuteScalar(newchildcommand);
            string update = "update childdesign set Totalnumber=@total,fillNumber=@fillnumber";
            sqlOperation.AddParameterWithValue("@total", int.Parse(aryline[1]) - int.Parse(aryline[2]));
            sqlOperation.AddParameterWithValue("@fillnumber", int.Parse(aryline[2]));
            sqlOperation.ExecuteNonQuery(update);

        }
        return "success";
    }
        
    }
