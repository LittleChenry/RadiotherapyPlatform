<%@ WebHandler Language="C#" Class="getigrtnumber" %>

using System;
using System.Web;
using System.Text;

public class getigrtnumber : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getnumber(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getnumber(HttpContext context)
    {
        int id=Convert.ToInt32(context.Request["ID"]);

        string countItem = "SELECT count(*) FROM locaterecord where TreatmentRecord_ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        string  count = sqlOperation.ExecuteScalar(countItem);
        return count;
    }

}