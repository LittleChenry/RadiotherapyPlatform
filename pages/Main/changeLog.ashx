<%@ WebHandler Language="C#" Class="changeLog" %>

using System;
using System.Web;
using System.Text;

public class changeLog : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            checkinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
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
    public void checkinfo(HttpContext context)
    {
        string logactor=context.Request["logactor"];
        if (logactor == "1")
        {
            string id = context.Request["user"];
            string treatid = context.Request["treatid"];
            string state = context.Request["state"];
            string command = "select patient.Name as pname,treatment.Treatmentdescribe as treatname from treatment,patient where treatment.Patient_ID=patient.ID and treatment.ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command);
            string loginfo = "";
            if (reader.Read())
            {
                if (state == "0")
                {
                    loginfo = loginfo + "恢复病人" + reader["pname"].ToString() + "疗程,疗程名称:" + reader["treatname"].ToString();
                }
                else
                {
                    loginfo = loginfo + "暂停病人" + reader["pname"].ToString() + "疗程,疗程名称:" + reader["treatname"].ToString();
                }
            }
            reader.Close();
            string insertcommand = "INSERT into loginfo(userID,logInformation,Date) VALUES(@userid,@login,@date)";
            sqlOperation.AddParameterWithValue("@userid", id);
            sqlOperation.AddParameterWithValue("@login", loginfo);
            sqlOperation.AddParameterWithValue("@date", DateTime.Now);
            sqlOperation.ExecuteNonQuery(insertcommand);
        }
        else
        {
            
            
        }
       
        

    }



}