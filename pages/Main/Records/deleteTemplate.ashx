<%@ WebHandler Language="C#" Class="deleteTemplate" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class deleteTemplate : IHttpHandler {


    private DataLayer sqlOperation = new DataLayer("sqlStr");

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = RecordPatientInformation(context);
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
    private string RecordPatientInformation(HttpContext context)
    {
        try
        {
            string templateid = context.Request.QueryString["templateID"];
            int templateID = Convert.ToInt32(templateid);
            //string userID = "1";

            string delete = "delete from doctortemplate where ID=@treatmentid";
            sqlOperation.AddParameterWithValue("@treatmentid", templateID);
            int success=sqlOperation.ExecuteNonQuery(delete);            
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }
           
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }
    }
}
