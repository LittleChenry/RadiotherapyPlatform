<%@ WebHandler Language="C#" Class="GetTemplateLocationApply" %>

using System;
using System.Web;
 using System.Text;
public class GetTemplateLocationApply : IHttpHandler {
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
        string sqlCommand1 = "select location.* from location where location.ID=@fixedID";
        sqlOperation2.AddParameterWithValue("@fixedID", fixedid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"templateInfo\":[");
        while (reader.Read())
        {
            backText.Append("{\"scanmethodID\":\"" + reader["ScanMethod_ID"].ToString() + "\",\"scanpartID\":\"" + reader["ScanPart_ID"] +
                "\",\"UpperBound\":\"" + reader["UpperBound"] + "\",\"LowerBound\":\"" + reader["LowerBound"] +
                "\",\"locationrequireID\":\"" + reader["LocationRequirements_ID"] + "\",\"Remarks\":\"" + reader["Remarks"] +
                "\",\"Enhance\":\"" + reader["Enhance"] + "\",\"enhancemethod\":\"" + reader["EnhanceMethod_ID"] + "\"}");           
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}