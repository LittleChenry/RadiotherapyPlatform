<%@ WebHandler Language="C#" Class="getPatientInfoNew" %>

using System;
using System.Web;
using System.Text;
using System.Collections;

public class getPatientInfoNew : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getpatientinfo(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
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
        string patientcommand = "select Distinct(Treatment_ID) as TreatmentID from childdesign where (state=2 or state=3)";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(patientcommand);
        ArrayList TreatmentList = new ArrayList();
        while (reader.Read())
        {
            TreatmentList.Add(reader["TreatmentID"].ToString());
            
        }
        
        
        
        
        
        
        
        
        
        
        
        string command = "select count(*) from equipment where TreatmentItem=@task and state=1";
        sqlOperation.AddParameterWithValue("@task", task);
        int count = int.Parse(sqlOperation.ExecuteScalar(command));
        string command2 = "select Name,ID from equipment where TreatmentItem=@task and state=1";
        StringBuilder backstring = new StringBuilder("{\"machine\":[");
        int i = 1;
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command2);
        while (reader.Read())
        {
            backstring.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\"}");
            if (i < count - 1)
            {
                backstring.Append(",");

            }
            i++;

        }
        backstring.Append("]}");
        return backstring.ToString();


    }

}