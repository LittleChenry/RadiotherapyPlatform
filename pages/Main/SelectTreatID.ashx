<%@ WebHandler Language="C#" Class="SelectTreatID" %>

using System;
using System.Web;
using System.Text;

public class SelectTreatID : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(gettreatid());
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string gettreatid()
    {

        string countItem = "SELECT count(*) FROM patient ";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));
        if (count == 0)
        {
            DateTime dt = new DateTime();
            int year = dt.Year;
            return year + "0001";
        }
        else
        {
            string sqlcommnd = "select Max(Radiotherapy_ID) from patient";
            int maxid = int.Parse(sqlOperation.ExecuteScalar(sqlcommnd));
            int id = maxid + 1;
            return id+"";

        }
        
        
    }


}