<%@ WebHandler Language="C#" Class="ReviewInfo" %>

using System;
using System.Web;
using System.Text;
public class ReviewInfo : IHttpHandler {
   private DataLayer sqlOperation2 = new DataLayer("sqlStr");
   private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
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
        int treatid = Convert.ToInt32(context.Request.QueryString["treatID"]);
        string sqlCommand1 = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand1));
        string sqlcommand2 = "select count(treatment.ID) from treatment,review where treatment.Patient_ID=@patient and treatment.Review_ID=review.ID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        int i = 1;
        string sqlCommand = "select review.*,user.Name as username,Treatmentname from review,treatment,user where review.ID=treatment.Review_ID and review._User_ID=user.ID and treatment.Patient_ID=@patient";
        sqlOperation2.AddParameterWithValue("@patient", patientid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"reviewInfo\":[");
        while (reader.Read())
        {
            string date = reader["ReviewTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"ReviewTime\":\"" + date1 + "\",\"name\":\"" + reader["username"] + "\",\"TechnologyConfirm\":\"" + reader["TechnologyConfirm"] +
                "\",\"PlanSystemConfirm\":\"" + reader["PlanSystemConfirm"] + "\",\"EquipmentConfirm\":\"" + reader["EquipmentConfirm"] +
                "\",\"AngleConfirm\":\"" + reader["AngleConfirm"] + "\",\"CoplanarConfirm\":\"" + reader["CoplanarConfirm"] +
                "\",\"MachineNumbeConfirm\":\"" + reader["MachineNumbeConfirm"] + "\",\"ControlPointConfirm\":\"" + reader["ControlPointConfirm"] +
                "\",\"GridConfirm\":\"" + reader["GridConfirm"] + "\",\"AlgorithmConfirm\":\"" + reader["AlgorithmConfirm"] +
                "\",\"FeasibilityConfirm\":\"" + reader["FeasibilityConfirm"] + "\",\"Reoptimization\":\"" + reader["Reoptimization"] +
                "\",\"ReferenceCenter\":\"" + reader["ReferenceCenter"] + "\",\"TreatmentCenter\":\"" + reader["TreatmentCenter"] +
                "\",\"Movement\":\"" + reader["Movement"] + "\",\"PlaceInformation\":\"" + reader["PlaceInformation"] +
                "\",\"DRR\":\"" + reader["DRR"] + "\",\"IsExport\":\"" + reader["IsExport"] + "\",\"Treatmentname\":\"" + reader["Treatmentname"] + "\"}");
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