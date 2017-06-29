<%@ WebHandler Language="C#" Class="FixInfo" %>

using System;
using System.Web;
using System.Text;

public class FixInfo : IHttpHandler
{
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
            String fixedID = context.Request.QueryString["treatID"];
           
            int treatID = Convert.ToInt32(fixedID);




            string sqlCommand = "select fixed.*,material.Name as mname,user.Name as doctor,fixedequipment.Name as fename,fixedrequirements.* from fixedequipment,user,material,fixedrequirements,treatment,fixed where fixed.Application_User_ID=user.ID and fixedequipment.ID=fixed.FixedEquipment_ID and fixed.Model_ID=material.ID and fixed.FixedRequirements_ID=fixedrequirements.ID and treatment.Fixed_ID=fixed.ID and  treatment.ID = @treatid";
          //  string sqlCommand1 = "select user.Name as appuser,from user,treatment,patient,fixed where patient.ID=treatment.Patient_ID and treatment.Fixed_ID=fixed.ID and fixed.Application_User_ID=user.ID and fixed.Application_User_ID is not NULL and fixed.Operate_User_ID is NULL and fixed.ID = @fixedid";
            
            sqlOperation.AddParameterWithValue("@treatid", treatID);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
            
             StringBuilder backText = new StringBuilder("{\"fixedInfo\":[");
            //backText.Append(reader.Read());
        
            while (reader.Read())
            {
                string date = reader["ApplicationTime"].ToString();
                DateTime dt1 = Convert.ToDateTime(date);
                string date1 = dt1.ToString("yyyy-MM-dd HH:mm"); 
                backText.Append("{\"modelID\":\"" + reader["mname"].ToString() + "\",\"requireID\":\"" + reader["Requirements"].ToString() +                    
                     "\",\"body\":\"" + reader["BodyPosition"].ToString() + "\",\"fixedEquipment\":\"" + reader["fename"].ToString() +
                     "\",\"ApplicationTime\":\"" + date1 + "\",\"ApplicationUser\":\"" + reader["doctor"].ToString() + "\",\"BodyPositionDetail\":\"" + reader["BodyPositionDetail"].ToString() +
                     "\",\"AnnexDescription\":\"" + reader["AnnexDescription"].ToString() + "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\"}");                              
            }
            reader.Close();                
            backText.Append("]}");
            return backText.ToString();
        }
   
          



}