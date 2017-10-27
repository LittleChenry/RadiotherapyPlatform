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

        DateTime dt = DateTime.Now;
        int year = dt.Year;
        string countItem = "SELECT count(*) FROM patient where Radiotherapy_ID DIV 10000=@year";
        sqlOperation.AddParameterWithValue("@year", year);
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));
        if (count == 0)
        {
            DateTime dt2 = DateTime.Now;
            int yearid = dt2.Year;
            return yearid + "0001";
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