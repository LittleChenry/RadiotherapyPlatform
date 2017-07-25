<%@ WebHandler Language="C#" Class="getallpdf" %>

using System;
using System.Web;

public class getallpdf : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getreplaceapplydinfo(context);
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
    private string getreplaceapplydinfo(HttpContext context)
    {
        String treat = context.Request.QueryString["treatID"];
        int treatID = Convert.ToInt32(treat);
        string desgin = "select PDF1,PDF2 from treatment,review where treatment.Review_ID=review.ID and treatment.ID=@treatid";
        sqlOperation.AddParameterWithValue("@treatid", treatID);
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(desgin);
        string data = "";
        if (reader1.Read())
        {
            data = data + reader1["PDF1"].ToString() + "," + reader1["PDF2"].ToString();
        }
      
        return data;
    }

}