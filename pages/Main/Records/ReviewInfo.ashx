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
     
        string sqlCommand = "select review.*,user.Name as username,review.ID as reviewid,Treatmentname from review,treatment,user where review.ID=treatment.Review_ID and review._User_ID=user.ID and treatment.ID=@treatID";
        sqlOperation2.AddParameterWithValue("@treatID", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"reviewInfo\":[");
        while (reader.Read())
        {
            string date = reader["ReviewTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"ReviewTime\":\"" + date1 + "\",\"name\":\"" + reader["username"] + "\",\"sum\":\"" + reader["SUM"] +
                "\",\"degree\":\"" + reader["Percent"] + "\",\"PlanQA\":\"" + reader["PlanQA"] + "\",\"userID\":\"" + reader["_User_ID"] +
                "\",\"Remark\":\"" + reader["Remark"] + "\",\"PDF1\":\"" + reader["PDF1"] + "\",\"PDF2\":\"" + reader["PDF2"] + "\"}");
          
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}