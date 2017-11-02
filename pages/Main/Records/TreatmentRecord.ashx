<%@ WebHandler Language="C#" Class="TreatmentRecord" %>

using System;
using System.Web;
 using System.Text;
public class TreatmentRecord : IHttpHandler {
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

        int treatid = Convert.ToInt32(context.Request["treatmentID"]);
        int appointid = Convert.ToInt32(context.Request["appoint"]);
        int totalnumber = Convert.ToInt32(context.Request["totalnumber"]);
        int user = Convert.ToInt32(context.Request["user"]);
        string assistant = context.Request["assistant"];
        int treatdays = Convert.ToInt32(context.Request["treatdays"]);
        int patient = Convert.ToInt32(context.Request["patientid"]);
        int singlenumber = Convert.ToInt32(context.Request["singlenumber"]);
        double machinenumber = Convert.ToDouble(context.Request["machinenumber"]);
        int Illuminated = Convert.ToInt32(context.Request["IlluminatedNumber"]);
        string remark = context.Request["remark"];
        string design = "select Design_ID from treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        string des = sqlOperation.ExecuteScalar(design);
     
        if (design != "")
        {
            string sqlcommand1 = "select IlluminatedNumber,MachineNumbe,DosagePriority from design,treatment where design.ID=treatment.Design_ID and treatment.ID=@treat";
            sqlOperation.AddParameterWithValue("treat", treatid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand1);
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
                Illuminated = int.Parse(reader["IlluminatedNumber"].ToString());
                machinenumber = double.Parse(reader["MachineNumbe"].ToString());
                singlenumber = finaldos;
            }
            reader.Close();
        }
       
        string sqlcommand2 = "select count(*) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL";
        int finishedtimes = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        string insert = "update treatmentrecord set TreatTime=@time,TreatedDays=@treatdays,TreatedTimes=@treattimes,Rest=@rest,Treat_User_ID=@user,IlluminatedNumber=@number1,MachineNumber=@number2,Assist_User=@assist,Singlenumber=@single,Remarks=@remarks where Appointment_ID=@appoint and Treatment_ID=@treat";
        sqlOperation.AddParameterWithValue("@time", DateTime.Now);
        sqlOperation.AddParameterWithValue("@treatdays", treatdays);
        sqlOperation.AddParameterWithValue("@treattimes", finishedtimes + 1);
        sqlOperation.AddParameterWithValue("@rest", totalnumber - finishedtimes - 1);
        sqlOperation.AddParameterWithValue("@user", user);
        sqlOperation.AddParameterWithValue("@number1", Illuminated);
        sqlOperation.AddParameterWithValue("@number2", machinenumber);
        sqlOperation.AddParameterWithValue("@assist", assistant);
        sqlOperation.AddParameterWithValue("@single", singlenumber);
        sqlOperation.AddParameterWithValue("@appoint", appointid);
        sqlOperation.AddParameterWithValue("@remarks", remark);
        int success = sqlOperation.ExecuteNonQuery(insert);
        if (success > 0)
        {

            string sqlcommand3 = "update appointment_accelerate set Patient_ID=@patient,Treatment_ID=@treat,Completed=1 where ID=@appoint";
            sqlOperation.AddParameterWithValue("@patient", patient);
            int success1 = sqlOperation.ExecuteNonQuery(sqlcommand3);
            if (success1 == 0)
            {
                return "fail";
            }
            else
            {
                return "success";
            }

        }
        return "fail";
        
    }
}