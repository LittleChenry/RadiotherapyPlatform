<%@ WebHandler Language="C#" Class="FixInfo" %>

using System;
using System.Web;
using System.Text;

public class FixInfo : IHttpHandler
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
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
            String fixedID = context.Request.QueryString["treatID"];
            int treatID = Convert.ToInt32(fixedID);
            string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
            sqlOperation.AddParameterWithValue("@treatID", treatID);
            int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
            string sqlcommand2 = "select count(treatment.ID) from treatment,fixed where treatment.Patient_ID=@patient and treatment.Fixed_ID=fixed.ID ";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
            int i = 1;
            string sqlCommand1 = "select Treatmentname,fixed.*,material.Name as mname,fixed.ID as fixedid,user.Name as doctor,fixedequipment.Name as fename,fixedrequirements.* from fixedequipment,user,material,fixedrequirements,treatment,fixed where fixed.Application_User_ID=user.ID and fixedequipment.ID=fixed.FixedEquipment_ID and fixed.Model_ID=material.ID and fixed.FixedRequirements_ID=fixedrequirements.ID and treatment.Fixed_ID=fixed.ID and treatment.Patient_ID=@patient";
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand1);
             StringBuilder backText = new StringBuilder("{\"fixedInfo\":[");
 
        
            while (reader.Read())
            {
                string date = reader["ApplicationTime"].ToString();
                DateTime dt1 = Convert.ToDateTime(date);
                string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
                string date2 = reader["OperateTime"].ToString();
                if (date2 != "")
                {
                    DateTime dt2 = Convert.ToDateTime(date2);
                    date2 = dt2.ToString("yyyy-MM-dd HH:mm");
                }
                string operate = null;
                if (reader["Operate_User_ID"] is DBNull)
                {

                    operate = null;
                }
                else
                {
                    string sqlCommand3 = "select user.Name from fixed,user,treatment where fixed.ID=treatment.Fixed_ID and fixed.Operate_User_ID =user.ID and fixed.OperateTime = @OperateTime and treatment.Patient_ID=@patient";
                    sqlOperation1.AddParameterWithValue("@treatid", treatID);
                    sqlOperation1.AddParameterWithValue("@patient", patientid);
                    sqlOperation1.AddParameterWithValue("@OperateTime", reader["OperateTime"].ToString());
                    operate = sqlOperation1.ExecuteScalar(sqlCommand3);

                }
                backText.Append("{\"modelID\":\"" + reader["mname"].ToString() + "\",\"requireID\":\"" + reader["Requirements"].ToString() + "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() +
                     "\",\"body\":\"" + reader["BodyPosition"].ToString() + "\",\"fixedEquipment\":\"" + reader["fename"].ToString() + "\",\"operate\":\"" + operate +
                     "\",\"ApplicationTime\":\"" + date1 + "\",\"ApplicationUser\":\"" + reader["doctor"].ToString() + "\",\"BodyPositionDetail\":\"" + reader["BodyPositionDetail"].ToString() +
                     "\",\"AnnexDescription\":\"" + reader["AnnexDescription"].ToString() + "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"Pictures\":\"" + reader["Pictures"].ToString() + "\",\"OperateTime\":\"" + date2 +
                     "\",\"fixedID\":\"" + reader["fixedid"].ToString() +  "\"}");
                if (i < count)
                {
                    backText.Append(",");
                }
                i++;
            }
            reader.Close();                
            backText.Append("]}");
            return backText.ToString();
        }
   
          



}