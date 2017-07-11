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
            int treatID = Convert.ToInt32(locationID);
            string sqlCommand3 = "select Patient_ID from treatment where treatment.ID=@treatID";
            sqlOperation.AddParameterWithValue("@treatID", treatID);
            int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand3));
            string sqlcommand2 = "select count(treatment.ID) from treatment,location where treatment.Patient_ID=@patient and treatment.Location_ID=location.ID ";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
            int i = 1;
            string sqlCommand1 = "select Treatmentname,CTPictures,location.ApplicationTime as apptime,fixed.*,material.Name as mname,scanpart.Name as partname,scanmethod.*,locationrequirements.*,user.Name as doctor,fixedequipment.Name as fename,location.Operate_User_ID as opid,location.OperateTime as optime,location.* from locationrequirements,scanpart,scanmethod,location,fixedequipment,user,material,treatment,fixed where scanmethod.ID=location.ScanMethod_ID and scanpart.ID=location.ScanPart_ID and locationrequirements.ID=location.LocationRequirements_ID and location.ID=treatment.Location_ID and fixedequipment.ID=fixed.FixedEquipment_ID and fixed.Model_ID=material.ID and treatment.Fixed_ID=fixed.ID and location.Application_User_ID =user.ID and treatment.Patient_ID=@patient";
            sqlOperation1.AddParameterWithValue("@patient", patientid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation1.ExecuteReader(sqlCommand1);
            StringBuilder backText = new StringBuilder("{\"locationInfo\":[");
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
                    string sqlCommand = "select user.Name from location,user,treatment where location.ID=treatment.Location_ID and location.Operate_User_ID =user.ID and location.OperateTime = @OperateTime and treatment.Patient_ID=@patient";
                    sqlOperation.AddParameterWithValue("@OperateTime", reader["optime"].ToString());
                    operate = sqlOperation.ExecuteScalar(sqlCommand);
                    
                }
                string enmethod="";
                if (reader["Enhance"].ToString()=="0")
                {

                    enmethod = "";
                }
                else
                {
                    string sqlCommand4 = "select enhancemethod.Method as method from location,enhancemethod,treatment where location.ID=treatment.Location_ID and location.EnhanceMethod_ID =enhancemethod.ID and location.ApplicationTime=@apptime and treatment.Patient_ID=@patient";
                    sqlOperation.AddParameterWithValue("@apptime", reader["apptime"].ToString());
                    enmethod = sqlOperation.ExecuteScalar(sqlCommand4);

                }
                backText.Append("{\"Thickness\":\"" + reader["Thickness"].ToString() + "\",\"ReferenceNumber\":\"" + reader["ReferenceNumber"].ToString() +"\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString()+
                        "\",\"ReferenceScale\":\"" + reader["ReferenceScale"].ToString() + "\",\"Number\":\"" + reader["Number"].ToString() +
                         "\",\"modelID\":\"" + reader["mname"].ToString() + "\",\"requireID\":\"" + reader["Requirements"].ToString() + "\",\"operate\":\"" + operate +
                         "\",\"body\":\"" + reader["BodyPosition"].ToString() + "\",\"fixedEquipment\":\"" + reader["fename"].ToString() +
                         "\",\"ApplicationTime\":\"" + date1 + "\",\"ApplicationUser\":\"" + reader["doctor"].ToString() +
                         "\",\"ScanPart\":\"" + reader["partname"].ToString() + "\",\"ScanMethod\":\"" + reader["Method"].ToString() +
                         "\",\"UpperBound\":\"" + reader["UpperBound"].ToString() + "\",\"LowerBound\":\"" + reader["LowerBound"].ToString() +
                         "\",\"Enhance\":\"" + reader["Enhance"].ToString() + "\",\"EnhanceMethod\":\"" + enmethod +
                         "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"BodyPositionDetail\":\"" + reader["BodyPositionDetail"].ToString() +
                         "\",\"AnnexDescription\":\"" + reader["AnnexDescription"].ToString() + "\",\"CTPictures\":\"" + reader["CTPictures"].ToString() + "\",\"OperateTime\":\"" + date2 + "\"}");
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