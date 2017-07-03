<%@ WebHandler Language="C#" Class="receiveInfo" %>

using System;
using System.Web;
using System.Text;
public class receiveInfo : IHttpHandler {
    


    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);

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
        int treatid = Convert.ToInt32(context.Request.QueryString["treatID"]);


        string sqlCommand = "select user.Name as username,ReceiveTime from design,treatment,user where design.ID=treatment.Design_ID and design.Receive_User_ID=user.ID and Treatment.ID=@treatID";
        sqlOperation2.AddParameterWithValue("@treatID", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"receiveInfo\":[");
        while (reader.Read())
        {
            string date = reader["ReceiveTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"ReceiveTime\":\"" + date1 + "\",\"name\":\"" + reader["username"] + "\"}");

        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}