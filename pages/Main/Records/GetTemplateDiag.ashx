<%@ WebHandler Language="C#" Class="GetTemplateDiag" %>

using System;
using System.Web;
using System.Text;
public class GetTemplateDiag : IHttpHandler {
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);

            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
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

        int templateid = Convert.ToInt32(context.Request.QueryString["templateID"]);
        string Count = "select TemplateID from doctortemplate where ID=@ID";
        sqlOperation2.AddParameterWithValue("@ID", templateid);
        int diagid = int.Parse(sqlOperation2.ExecuteScalar(Count));
        int i = 1;
        string sqlCommand1 = "select diagnosisrecord.* from diagnosisrecord where diagnosisrecord.ID=@diagid";
        sqlOperation2.AddParameterWithValue("@diagid", diagid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"diagnosisInfo\":[");
        while (reader.Read())
        {
            string icdcode = "select Group1,Group2,Chinese from icdcode where ID=@icdcodeid";
            sqlOperation1.AddParameterWithValue("@icdcodeid", reader["DiagnosisResult_ID"].ToString());
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(icdcode);
            string result1 = "";
            string result2 = "";
            if (reader1.Read())
            {
                result1 = reader1["Group1"].ToString() + "," + reader1["Group2"].ToString() + "," + reader1["Chinese"].ToString();
            }
            reader1.Close();
            string icdcode1 = "select Groupfirst,Groupsecond from morphol where ID=@morpholid";
            sqlOperation1.AddParameterWithValue("@morpholid", reader["PathologyResult"].ToString());
             reader1= sqlOperation1.ExecuteReader(icdcode1);
             if (reader1.Read())
             {
                 result2 = reader1["Groupsecond"].ToString() + "," + reader1["Groupfirst"].ToString() ;
             }
             reader1.Close();
            string date = reader["Time"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"partID\":\"" + reader["Part_ID"] + "\",\"LightPart_ID\":\"" + reader["LightPart_ID"] + "\",\"diagnosisresultName1\":\"" + result1 + "\",\"diagnosisresultName2\":\"" + result2 +
                 "\",\"diagnosisresultID\":\"" + reader["DiagnosisResult_ID"].ToString() + "\",\"treatmentaimID\":\"" + reader["TreatAim_ID"].ToString() + "\",\"PathologyResult\":\"" + reader["PathologyResult"].ToString() +
                 "\",\"Time\":\"" + date1 + "\"}");         
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}