<%@ WebHandler Language="C#" Class="LocationInfo" %>



using System;
using System.Web;
using System.Text;

public class LocationInfo : IHttpHandler
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
            sqlOperation1= null;
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
            String locationID = context.Request.QueryString["treatID"];
            int i = 1;
            int treatID = Convert.ToInt32(locationID);

            string sqlCommand1 = "select location.ApplicationTime as apptime,fixed.*,material.Name as mname,scanpart.Name as partname,scanmethod.*,enhancemethod.Method as enmethod,locationrequirements.*,user.Name as doctor,fixedequipment.Name as fename,location.Operate_User_ID as opid,location.OperateTime as optime,location.* from locationrequirements,scanpart,scanmethod,enhancemethod,location,fixedequipment,user,material,treatment,fixed where enhancemethod.ID=location.EnhanceMethod_ID and scanmethod.ID=location.ScanMethod_ID and scanpart.ID=location.ScanPart_ID and locationrequirements.ID=location.LocationRequirements_ID and location.ID=treatment.Location_ID and fixedequipment.ID=fixed.FixedEquipment_ID and  fixed.Model_ID=material.ID and  treatment.Fixed_ID=fixed.ID and location.Application_User_ID =user.ID and treatment.ID = @treatid";
            //  string sqlCommand1 = "select user.Name as appuser,from user,treatment,patient,fixed where patient.ID=treatment.Patient_ID and treatment.Fixed_ID=fixed.ID and fixed.Application_User_ID=user.ID and fixed.Application_User_ID is not NULL and fixed.Operate_User_ID is NULL and fixed.ID = @fixedid";

            sqlOperation1.AddParameterWithValue("@treatid", treatID);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation1.ExecuteReader(sqlCommand1);
            
             StringBuilder backText = new StringBuilder("{\"locationInfo\":[");
            //backText.Append(reader.Read());
        
            while (reader.Read())
            {
                string date = reader["apptime"].ToString();
                DateTime dt1 = Convert.ToDateTime(date);
                string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
                string date2 = reader["optime"].ToString();
                if(date2!=""){
                    DateTime dt2 = Convert.ToDateTime(date2);
                     date2 = dt2.ToString("yyyy-MM-dd HH:mm");
                }
                string operate = null;
                if (reader["opid"] is DBNull)
                {

                    operate = null;
                }
                else
                {
                    string sqlCommand = "select user.Name from location,user,treatment where location.ID=treatment.Location_ID and location.Operate_User_ID =user.ID and treatment.ID = @treatid";
                    sqlOperation.AddParameterWithValue("@treatid", treatID);
                    operate = sqlOperation.ExecuteScalar(sqlCommand);
                    
                }
                backText.Append("{\"Thickness\":\"" + reader["Thickness"].ToString() + "\",\"ReferenceNumber\":\"" + reader["ReferenceNumber"].ToString() +
                        "\",\"ReferenceScale\":\"" + reader["ReferenceScale"].ToString() + "\",\"Number\":\"" + reader["Number"].ToString() +
                         "\",\"modelID\":\"" + reader["mname"].ToString() + "\",\"requireID\":\"" + reader["Requirements"].ToString() + "\",\"operate\":\"" + operate +
                         "\",\"body\":\"" + reader["BodyPosition"].ToString() + "\",\"fixedEquipment\":\"" + reader["fename"].ToString() +
                         "\",\"ApplicationTime\":\"" + date1 + "\",\"ApplicationUser\":\"" + reader["doctor"].ToString() +
                         "\",\"ScanPart\":\"" + reader["partname"].ToString() + "\",\"ScanMethod\":\"" + reader["Method"].ToString() +
                         "\",\"UpperBound\":\"" + reader["UpperBound"].ToString() + "\",\"LowerBound\":\"" + reader["LowerBound"].ToString() +
                         "\",\"Enhance\":\"" + reader["Enhance"].ToString() + "\",\"EnhanceMethod\":\"" + reader["enmethod"].ToString() +
                         "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"BodyPositionDetail\":\"" + reader["BodyPositionDetail"].ToString() +
                         "\",\"AnnexDescription\":\"" + reader["AnnexDescription"].ToString() + "\",\"OperateTime\":\"" + date2 + "\"}");
            }
            
            backText.Append("]}");
            reader.Close();
            return backText.ToString();
        }
   
          



}