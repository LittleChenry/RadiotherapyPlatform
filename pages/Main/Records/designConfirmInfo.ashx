<%@ WebHandler Language="C#" Class="designConfirmInfo" %>

using System;
using System.Web;
using System.Text;
using System.Collections.Generic;

public class designConfirmInfo : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
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
    private string getfixrecordinfo(HttpContext context)
    {
        String designID = context.Request.QueryString["treatID"];

        int treatID = Convert.ToInt32(designID);
        string sqlCommand4 = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand4));
        string sqlcommand5= "select count(treatment.ID) from treatment,design where treatment.Patient_ID=@patient and treatment.Design_ID=design.ID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand5));
        int i = 1;
        string sqlCommand = "select Treatmentname,technology.name as tname,equipmenttype.type as eqname,grid.Name as gridname,algorithm.Name as algorithmname,plansystem.Name as planname,user.Name as doctor,design.* from technology,equipmenttype,design,user,treatment,plansystem,grid,algorithm where grid.ID=design.Grid_ID and plansystem.ID=design.PlanSystem_ID and algorithm.ID=design.Algorithm_ID and technology.ID=design.Technology_ID and equipmenttype.ID=design.Equipment_ID and design.ID=treatment.Design_ID and design.Application_User_ID =user.ID  and treatment.Patient_ID=@patient";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        StringBuilder backText = new StringBuilder("{\"designInfo\":[");
        //backText.Append(reader.Read());

        while (reader.Read())
        {
            string date = reader["ApplicationTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            string date2 = reader["ReceiveTime"].ToString();
            DateTime dt2 = Convert.ToDateTime(date2);
            date2 = dt2.ToString("yyyy-MM-dd HH:mm");
            string date4 = reader["SubmitTime"].ToString();
            DateTime dt4 = Convert.ToDateTime(date4);
            date4= dt4.ToString("yyyy-MM-dd HH:mm");
            string date3 = reader["ConfirmTime"].ToString();
            if (date3 != "")
            {
                DateTime dt3 = Convert.ToDateTime(date3);
                date3 = dt3.ToString("yyyy-MM-dd HH:mm");
            }
            string sqlCommand1 = "select user.Name from design,user,treatment where design.ID=treatment.Design_ID and design.Receive_User_ID =user.ID and ReceiveTime = @ReceiveTime and treatment.Patient_ID=@patient";
            sqlOperation1.AddParameterWithValue("@ReceiveTime", reader["ReceiveTime"].ToString());
            sqlOperation1.AddParameterWithValue("@patient", patientid);
            string receiver = sqlOperation1.ExecuteScalar(sqlCommand1);
            string sqlCommand2 = "select user.Name from design,user,treatment where design.ID=treatment.Design_ID and design.Submit_User_ID =user.ID and ReceiveTime = @ReceiveTime and treatment.Patient_ID=@patient";
            sqlOperation2.AddParameterWithValue("@ReceiveTime", reader["ReceiveTime"].ToString());
            sqlOperation2.AddParameterWithValue("@patient", patientid);
            string submit= sqlOperation2.ExecuteScalar(sqlCommand2);
            string operate = null;
            if (reader["Confirm_User_ID"] is DBNull)
            {

                operate = null;
            }
            else
            {
                string sqlCommand3 = "select user.Name from design,user,treatment where design.ID=treatment.Design_ID and design.Confirm_User_ID =user.ID and ReceiveTime = @ReceiveTime and treatment.Patient_ID=@patient";
                sqlOperation2.AddParameterWithValue("@ReceiveTime", reader["ReceiveTime"].ToString());
                sqlOperation2.AddParameterWithValue("@patient", patientid);
                operate = sqlOperation2.ExecuteScalar(sqlCommand3);
            }
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] { '&' })[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"apptime\":\"" + date1 + "\",\"ConfirmUser\":\"" + operate + "\",\"ConfirmTime\":\"" + date3 + "\",\"State\":\"" + reader["State"].ToString() + "\",\"advice\":\"" + reader["Checkadvice"].ToString() +
                 "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"ReceiveUser\":\"" + receiver + "\",\"ReceiveTime\":\"" + date2 + "\",\"SubmitUser\":\"" + submit + "\",\"SubmitTime\":\"" + date4 +
                  "\",\"technology\":\"" + reader["tname"].ToString() + "\",\"equipment\":\"" + reader["eqname"].ToString() + "\",\"PlanSystem\":\"" + reader["planname"].ToString() +
                  "\",\"RadiotherapyHistory\":\"" + reader["RadiotherapyHistory"].ToString() + "\",\"DosagePriority\":\"" + Priority + "\",\"Dosage\":\"" + Dosage + "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() +
                   "\",\"IlluminatedNumber\":\"" + reader["IlluminatedNumber"].ToString() + "\",\"Coplanar\":\"" + reader["Coplanar"].ToString() + "\",\"MachineNumbe\":\"" + reader["MachineNumbe"].ToString() +
                   "\",\"ControlPoint\":\"" + reader["ControlPoint"].ToString() + "\",\"Grid_ID\":\"" + reader["gridname"].ToString() + "\",\"Algorithm_ID\":\"" + reader["algorithmname"].ToString() +
                   "\",\"Feasibility\":\"" + reader["Feasibility"].ToString() + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }

        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}