<%@ WebHandler Language="C#" Class="designSubmitInfo" %>

using System;
using System.Web;
using System.Text;
using System.Collections.Generic;
public class designSubmitInfo : IHttpHandler {

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
        string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        string sqlcommand2 = "select count(treatment.ID) from treatment,design where treatment.Patient_ID=@patient and treatment.Design_ID=design.ID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        int i = 1;
        string sqlCommand3 = "select design.ID as designid,Treatmentdescribe,Treatmentname,technology.name as tname,equipmenttype.type as eqname,user.Name as doctor,design.* from technology,equipmenttype,design,user,treatment where technology.ID=design.Technology_ID and equipmenttype.ID=design.Equipment_ID and design.ID=treatment.Design_ID and design.Application_User_ID =user.ID  and treatment.Patient_ID=@patient";      
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand3);

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
            string date3 = reader["SubmitTime"].ToString();
            if (date3 != "")
            {
                DateTime dt3 = Convert.ToDateTime(date3);
                date3 = dt3.ToString("yyyy-MM-dd HH:mm");
            }
            string sqlCommand1 = "select user.Name from design,user,treatment where design.ID=treatment.Design_ID and design.Receive_User_ID =user.ID and ReceiveTime = @ReceiveTime and treatment.Patient_ID=@patient";
            sqlOperation1.AddParameterWithValue("@ReceiveTime", reader["ReceiveTime"].ToString());
            sqlOperation1.AddParameterWithValue("@patient", patientid);
            string receiver = sqlOperation1.ExecuteScalar(sqlCommand1);
             string operate = null;
             if (reader["Submit_User_ID"] is DBNull)
             {

                 operate = null;
             }
             else
             {
                 string sqlCommand4 = "select user.Name from design,user,treatment where design.ID=treatment.Design_ID and design.Submit_User_ID =user.ID and ReceiveTime = @ReceiveTime and treatment.Patient_ID=@patient";
                 sqlOperation2.AddParameterWithValue("@ReceiveTime", reader["ReceiveTime"].ToString());
                 sqlOperation2.AddParameterWithValue("@patient", patientid);
                 operate = sqlOperation2.ExecuteScalar(sqlCommand4);
             }
             string planname = null;
             string gridname = null;
             string alname = null;
             if (reader["PlanSystem_ID"] is DBNull)
             {

                 planname = null;
             }
             else
             {
                 string sql1 = "select Name from plansystem where plansystem.ID=@PlanSystem_ID";
                 sqlOperation2.AddParameterWithValue("@PlanSystem_ID", reader["PlanSystem_ID"].ToString());
                 planname = sqlOperation2.ExecuteScalar(sql1);
             }
             if (reader["Grid_ID"] is DBNull)
             {

                 gridname = null;
             }
             else
             {
                 string sql = "select Name from grid where grid.ID=@Grid_ID";
                 sqlOperation2.AddParameterWithValue("@Grid_ID", reader["Grid_ID"].ToString());
                 gridname = sqlOperation2.ExecuteScalar(sql);
             }
             if (reader["Algorithm_ID"] is DBNull)
             {

                 alname = null;
             }
             else
             {
                 string sql2 = "select Name from algorithm where algorithm.ID=@Grid_ID";
                 sqlOperation2.AddParameterWithValue("@Grid_ID", reader["Algorithm_ID"].ToString());
                 alname = sqlOperation2.ExecuteScalar(sql2);
             }
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] {'&'})[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"apptime\":\"" + date1 +
                 "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"ReceiveUser\":\"" + receiver + "\",\"ReceiveTime\":\"" + date2 + "\",\"SubmitUser\":\"" + operate + "\",\"SubmitTime\":\"" + date3 +
                  "\",\"technology\":\"" + reader["tname"].ToString() + "\",\"equipment\":\"" + reader["eqname"].ToString() + "\",\"PlanSystem\":\"" + reader["PlanSystem_ID"].ToString() +
                  "\",\"RadiotherapyHistory\":\"" + reader["RadiotherapyHistory"].ToString() + "\",\"DosagePriority\":\"" + Priority + "\",\"Dosage\":\"" + Dosage + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() +
                   "\",\"IlluminatedNumber\":\"" + reader["IlluminatedNumber"].ToString() + "\",\"Coplanar\":\"" + reader["Coplanar"].ToString() + "\",\"MachineNumbe\":\"" + reader["MachineNumbe"].ToString() +
                   "\",\"ControlPoint\":\"" + reader["ControlPoint"].ToString() + "\",\"Grid_ID\":\"" + reader["Grid_ID"].ToString() + "\",\"Algorithm_ID\":\"" + reader["Algorithm_ID"].ToString() +
                   "\",\"Feasibility\":\"" + reader["Feasibility"].ToString() + "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"gridname\":\""+ gridname +
                   "\",\"PlanSystemname\":\"" + planname + "\",\"algorithmname\":\"" + alname + "\",\"designID\":\"" + reader["designid"].ToString() + "\",\"userID\":\"" + reader["Submit_User_ID"].ToString() + "\"}");

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