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
        string sqlCommand3 = "select design.ID as designid,Treatmentdescribe,Treatmentname,technology.name as tname,equipmenttype.type as eqname,design.Technology_ID as techid,user.Name as doctor,design.* from technology,equipmenttype,design,user,treatment where technology.ID=design.Technology_ID and equipmenttype.ID=design.Equipment_ID and design.ID=treatment.Design_ID and design.Application_User_ID =user.ID  and treatment.Patient_ID=@patient";      
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
             string raytypename = null;            
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
             if (reader["Raytype_ID"] is DBNull)
             {

                 raytypename = null;
             }
             else
             {
                 string sql = "select Name from raytype where ID=@Raytype_ID";
                 sqlOperation2.AddParameterWithValue("@Raytype_ID", reader["Raytype_ID"].ToString());
                 raytypename = sqlOperation2.ExecuteScalar(sql);
             }
             //string left = "";
             //string right = "";
             //string rise = "";
             //string drop = "";
             //string enter = "";
             //string out1 = "";
             //if (!(reader["parameters"] is DBNull))
             //{
             //    string parameters = reader["parameters"].ToString();
             //    string a1 = parameters.Split(new char[1] { ';' })[0];
             //    string a2 = parameters.Split(new char[1] { ';' })[1];
             //    string a3 = parameters.Split(new char[1] { ';' })[2];
             //    if (Convert.ToDouble(a1) >=0 && a1!="-0")
             //    {
             //        left = a1;
             //    }
             //    else
             //    {
             //        right = a1.Substring(1);
             //    }
             //    if (Convert.ToDouble(a2) >= 0 && a2 != "-0")
             //    {
             //        rise = a2;
             //    }
             //    else
             //    {
             //        drop = a2.Substring(1);
             //    }
             //    if (Convert.ToDouble(a3) >= 0 && a3 != "-0")
             //    {
             //        enter = a3;
             //    }
             //    else
             //    {
             //        out1 = a3.Substring(1);
             //    }
             //}
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] {'&'})[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"apptime\":\"" + date1 +
                 "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"ReceiveUser\":\"" + receiver + "\",\"ReceiveTime\":\"" + date2 + "\",\"SubmitUser\":\"" + operate + "\",\"SubmitTime\":\"" + date3 +
                  "\",\"technology\":\"" + reader["tname"].ToString() + "\",\"equipment\":\"" + reader["eqname"].ToString() + "\",\"PlanSystem\":\"" + reader["PlanSystem_ID"].ToString() +
                  "\",\"RadiotherapyHistory\":\"" + reader["RadiotherapyHistory"].ToString() + "\",\"DosagePriority\":\"" + Priority + "\",\"Dosage\":\"" + Dosage + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() +
                  "\",\"Raytype\":\"" + reader["Raytype_ID"].ToString() + "\",\"equipmentid\":\"" + reader["Equipment_ID"].ToString() + "\",\"technologyid\":\"" + reader["techid"].ToString() +
                   "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"Raytypename\":\"" + raytypename + //"\",\"left\":\"" + left + "\",\"right\":\"" + right + "\",\"rise\":\"" + rise + "\",\"drop\":\"" + drop + "\",\"enter\":\"" + enter + "\",\"out\":\"" + out1 +
                   "\",\"PlanSystemname\":\"" + planname + "\",\"designID\":\"" + reader["designid"].ToString() + "\",\"userID\":\"" + reader["Submit_User_ID"].ToString() + "\"}");

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