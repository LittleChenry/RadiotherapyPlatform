<%@ WebHandler Language="C#" Class="GetTemplateFixApply" %>

using System;
using System.Web;
using System.Text;
public class GetTemplateFixApply : IHttpHandler {
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
        string sqlCommand1 = "select fixed.* from fixed where fixed.ID=@fixedID";
        sqlOperation2.AddParameterWithValue("@fixedID", fixedid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"templateInfo\":[");
        while (reader.Read())
        {
            backText.Append("{\"Model_ID\":\"" + reader["Model_ID"].ToString() + "\",\"FixedRequirements_ID\":\"" + reader["FixedRequirements_ID"] + "\",\"BodyPosition\":\"" + reader["BodyPosition"] + "\",\"FixedEquipment_ID\":\"" + reader["FixedEquipment_ID"] + "\"}");           
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}