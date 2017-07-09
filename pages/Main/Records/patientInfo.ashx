<%@ WebHandler Language="C#" Class="patientInfo" %>

using System;
using System.Web;
using System.Text;
public class patientInfo : IHttpHandler
{

    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2=null;
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
        int treatid = Convert.ToInt32(context.Request.QueryString["treatID"]);


        string sqlCommand = "select patient.*,user.Name as username from user,treatment,patient where patient.Register_User_ID=user.ID and patient.ID=treatment.Patient_ID and treatment.ID=@treatID";
        sqlOperation2.AddParameterWithValue("@treatID", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"patientInfo\":[");
        while (reader.Read())
        {
            string date = reader["Birthday"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd");
            string date2 = reader["RegisterTime"].ToString();
            DateTime dt2 = Convert.ToDateTime(date2);
            string date3 = dt2.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"IDcardNumber\":\"" + reader["IdentificationNumber"] + "\",\"Hospital\":\"" + reader["Hospital"] +
                 "\",\"Sub\":\"" + reader["SubCenterPrincipal_ID"].ToString() + "\",\"RecordNumber\":\"" + reader["RecordNumber"].ToString() + "\",\"Picture\":\"" + reader["Picture"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Gender\":\"" + reader["Gender"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() + "\",\"Birthday\":\"" + date1 + 
                 "\",\"Nation\":\"" + reader["Nation"].ToString() + "\",\"Address\":\"" + reader["Address"].ToString() + "\",\"Contact1\":\"" + reader["Contact1"].ToString() + "\",\"doctor\":\"" + reader["RegisterDoctor"].ToString() + "\",\"Registeruser\":\"" + reader["username"].ToString() +
                 "\",\"Contact2\":\"" + reader["Contact2"].ToString() + "\",\"Height\":\"" + reader["Height"].ToString() + "\",\"Weight\":\"" + reader["Weight"].ToString() + "\",\"date\":\"" + date3 + "\"}");
           
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}