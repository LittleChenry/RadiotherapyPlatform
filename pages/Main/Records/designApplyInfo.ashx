<%@ WebHandler Language="C#" Class="designApplyInfo" %>

using System;
using System.Web;
using System.Text;
using System.Collections.Generic;
public class designApplyInfo : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
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

        string sqlCommand1 = "select design.ID as designid,Treatmentname,technology.ID as teID,equipmenttype.ID as eqID,technology.Name as tname,equipmenttype.Type as eqname,user.Name as doctor,design.* from technology,equipmenttype,design,user,treatment where technology.ID=design.Technology_ID and equipmenttype.ID=design.Equipment_ID and design.ID=treatment.Design_ID and design.Application_User_ID =user.ID  and treatment.Patient_ID=@patient";
        //  string sqlCommand1 = "select user.Name as appuser,from user,treatment,patient,fixed where patient.ID=treatment.Patient_ID and treatment.Fixed_ID=fixed.ID and fixed.Application_User_ID=user.ID and fixed.Application_User_ID is not NULL and fixed.Operate_User_ID is NULL and fixed.ID = @fixedid";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand1);

        StringBuilder backText = new StringBuilder("{\"designInfo\":[");
        //backText.Append(reader.Read());
        
        while (reader.Read())
        {
            string date = reader["ApplicationTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] {'&'})[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"apptime\":\"" + date1 +
                 "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"designID\":\"" + reader["designid"].ToString() +
                  "\",\"technology\":\"" + reader["teID"].ToString() + "\",\"equipment\":\"" + reader["eqID"].ToString() + "\",\"technologyname\":\"" + reader["tname"].ToString() + "\",\"equipmentname\":\"" + reader["eqname"].ToString() +
                  "\",\"RadiotherapyHistory\":\"" + reader["RadiotherapyHistory"].ToString() + "\",\"DosagePriority\":\"" + Priority + "\",\"Dosage\":\"" + Dosage + "\"}");

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