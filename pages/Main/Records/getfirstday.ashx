<%@ WebHandler Language="C#" Class="getfirstday" %>

using System;
using System.Web;
using System.Text;

public class getfirstday : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = gettotal(context);
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
    private string gettotal(HttpContext context)
    {
        string treatid = context.Request.QueryString["treatmentID"];
        int treat = int.Parse(treatid);
        string total = "";
        string sqlcommand = "select TreatTime from treatmentrecord where Treatment_ID=@treat order by ID asc";
        sqlOperation.AddParameterWithValue("treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand);
        if (reader.Read())
        {
            total = reader["TreatTime"].ToString() ;

        }
        return total;
    }

}