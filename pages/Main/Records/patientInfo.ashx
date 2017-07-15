<%@ WebHandler Language="C#" Class="patientInfo" %>

using System;
using System.Web;
using System.Text;
public class patientInfo : IHttpHandler
{

    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation3 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2=null;
            sqlOperation3.Close();
            sqlOperation3.Dispose();
            sqlOperation3 = null;
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


        string sqlCommand = "select Group_ID,Belongingdoctor,patient.*,user.Name as username from user,treatment,patient where patient.Register_User_ID=user.ID and patient.ID=treatment.Patient_ID and treatment.ID=@treatID";
        sqlOperation2.AddParameterWithValue("@treatID", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"patientInfo\":[");
        while (reader.Read())
        {
            string group = "";
            int group2 = -1;
            if (reader["Group_ID"].ToString()!= "")
            {
                group2 = Convert.ToInt32(reader["Group_ID"].ToString());
            }
            string command = "select count(*) from groups2user where User_ID=@user and Group_ID=@group";
            sqlOperation3.AddParameterWithValue("@user", Convert.ToInt32(reader["Belongingdoctor"].ToString()));
            sqlOperation3.AddParameterWithValue("@group", group2);
            string count1 = sqlOperation3.ExecuteScalar(command);
            if (count1 == "0")
            {
                group = "";
            }
            else
            {
                group = reader["Group_ID"].ToString();
            }
            string date = reader["Birthday"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd");
            string date2 = reader["RegisterTime"].ToString();
            DateTime dt2 = Convert.ToDateTime(date2);
            string date3 = dt2.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"group\":\"" + group + "\",\"IDcardNumber\":\"" + reader["IdentificationNumber"] + "\",\"Hospital\":\"" + reader["Hospital"] +
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