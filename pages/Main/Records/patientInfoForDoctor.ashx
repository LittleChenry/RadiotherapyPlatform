<%@ WebHandler Language="C#" Class="patientInfoForDoctor" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class patientInfoForDoctor : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
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
        String userid = context.Request.QueryString["userID"];
        int userID = Convert.ToInt32(userid);
        string sqlCommand1 = "SELECT Group_ID from groups2user where User_ID=@userid and identity<>0";
        sqlOperation.AddParameterWithValue("@userid", userID);
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlCommand1);
        ArrayList array = new ArrayList();
        ArrayList array2 = new ArrayList();
        while (reader1.Read())
        {
            array.Add(reader1["Group_ID"].ToString());
        }
       reader1.Close();
       foreach (string element in array)
       {
           string sqlcommand2 = "select ID from groups2user where identity<>0 and Group_ID=@groupid";
           sqlOperation1.AddParameterWithValue("@groupid", Convert.ToInt32(element));
           MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(sqlcommand2);
           while (reader2.Read())
           {
               array2.Add(reader2["ID"].ToString());
           }
           reader2.Close();
       }

       int Count = 0;
       int count = 0;
       foreach (string element in array2)
       {
           string sqlCommand = "SELECT count(*) from treatment where Group_ID=@groupid";
           sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
           count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
           Count = Count + count;
       }
       string sql = "select count(*) from treatment where Group_ID is NULL and Belongingdoctor=@userid";
        sqlOperation2.AddParameterWithValue("@userid", Convert.ToInt32(userID));
        int count2=int.Parse(sqlOperation2.ExecuteScalar(sql));
        
       if (Count == 0)
       {
           return "{\"PatientInfo\":false}";
       }
       int i = 1;
       StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
       foreach (string element in array2)
       {
           string sqlCommand11 = "select groups.groupName as groupname from groups,groups2user where groups.ID=groups2user.Group_ID and groups2user.ID=@groupid";
           sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
           string groupname = sqlOperation.ExecuteScalar(sqlCommand11);
           string sqlCommand2 = "select treatment.Group_ID as groupID,treatment.ID as treatid,patient.*,State,Progress,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and patient.RegisterDoctor=user.ID and treatment.Group_ID=@groupid  order by patient.ID desc";
           sqlOperation2.AddParameterWithValue("@groupid", Convert.ToInt32(element));
           MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
           while (reader.Read())
           {
               string result = "";
               if (reader["DiagnosisRecord_ID"] is DBNull)
               {
                   result = "";
               }
               else
               {
                   string sqlCommand3 = "select TumorName from diagnosisrecord,diagnosisresult where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =diagnosisresult.ID";
                   sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                   string TumorName = sqlOperation1.ExecuteScalar(sqlCommand3);
                   string sqlCommand4 = "select Description from diagnosisrecord,diagnosisresult where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =diagnosisresult.ID";
                   sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                   string Description = sqlOperation1.ExecuteScalar(sqlCommand4);
                   result = TumorName + Description;
               }
 
               backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result +
                    "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + groupname
                    + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\"}");

               if (i < Count)
               {
                   backText.Append(",");
               }
               i++;
           }
           reader.Close();
       }
       if (count2 != 0)
       {
           backText.Append(",");
       }
       string command3 = "select treatment.ID as treatid,patient.*,State,Progress,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and patient.RegisterDoctor=user.ID and treatment.Group_ID is NULL and treatment.Belongingdoctor=@userid  order by patient.ID desc";
       MySql.Data.MySqlClient.MySqlDataReader reader3 = sqlOperation2.ExecuteReader(command3);
       int temp=0;
       while (reader3.Read())
       {
          
           string result = "";
           if (reader3["DiagnosisRecord_ID"] is DBNull)
           {
               result = "";
           }
           else
           {
               string sqlCommand3 = "select TumorName from diagnosisrecord,diagnosisresult where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =diagnosisresult.ID";
               sqlOperation1.AddParameterWithValue("@ID", reader3["DiagnosisRecord_ID"].ToString());
               string TumorName = sqlOperation1.ExecuteScalar(sqlCommand3);
               string sqlCommand4 = "select Description from diagnosisrecord,diagnosisresult where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =diagnosisresult.ID";
               sqlOperation1.AddParameterWithValue("@ID", reader3["DiagnosisRecord_ID"].ToString());
               string Description = sqlOperation1.ExecuteScalar(sqlCommand4);
               result = TumorName + Description;
           }

           backText.Append("{\"Name\":\"" + reader3["Name"].ToString() + "\",\"diagnosisresult\":\"" + result +
                "\",\"Radiotherapy_ID\":\"" + reader3["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader3["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + ""
                + "\",\"Progress\":\"" + reader3["Progress"].ToString() + "\",\"doctor\":\"" + reader3["doctor"].ToString() + "\",\"treatID\":\"" + reader3["treatid"].ToString() + "\"}");

           if (temp < count2-1)
           {
               backText.Append(",");
           }
           temp++;
       }
        
       backText.Append("]}");
       return backText.ToString();
    }
}