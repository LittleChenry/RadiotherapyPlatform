<%@ WebHandler Language="C#" Class="GetTemplateDesignApply" %>

using System;
using System.Web;
using System.Text;
public class GetTemplateDesignApply : IHttpHandler {
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
        int templateid = Convert.ToInt32(context.Request.QueryString["templateID"]);        
        string Count = "select TemplateID from doctortemplate where ID=@ID";
        sqlOperation2.AddParameterWithValue("@ID", templateid);      
        int fixedid = int.Parse(sqlOperation2.ExecuteScalar(Count));
        string sqlCommand1 = "select design.* from design where design.ID=@fixedID";
        sqlOperation2.AddParameterWithValue("@fixedID", fixedid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"templateInfo\":[");
        while (reader.Read())
        {
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] { '&' })[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"technology\":\"" + reader["Technology_ID"].ToString() + "\",\"equipment\":\"" + reader["Equipment_ID"].ToString() +
                  "\",\"RadiotherapyHistory\":\"" + reader["RadiotherapyHistory"].ToString() + "\",\"DosagePriority\":\"" + Priority + "\",\"Dosage\":\"" + Dosage + "\"}");
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}