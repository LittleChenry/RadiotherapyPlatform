<%@ WebHandler Language="C#" Class="geteuqipmenttype" %>

using System;
using System.Web;

public class geteuqipmenttype : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getprinItem(HttpContext context)
    {
        string treatid = context.Request.QueryString["treatmentID"];
        string sqlCommand = "SELECT Equipment_ID FROM treatment,design where treatment.Design_ID=design.ID and treatment.ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        string equip = sqlOperation.ExecuteScalar(sqlCommand);
        return equip;
    }

}