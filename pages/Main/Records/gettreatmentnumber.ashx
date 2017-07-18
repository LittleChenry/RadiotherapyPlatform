<%@ WebHandler Language="C#" Class="gettreatmentnumber" %>

using System;
using System.Web;
using System.Text;

public class gettreatmentnumber : IHttpHandler {
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
        string treatid=context.Request.QueryString["treatmentID"];
        int treat=int.Parse(treatid);
        int total = 0;
        string sqlcommand = "select TreatedTimes,Rest from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL order by TreatedTimes desc";
        sqlOperation.AddParameterWithValue("treat",treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand);
        if (reader.Read())
        {
            total = Convert.ToInt32(reader["TreatedTimes"].ToString()) + Convert.ToInt32(reader["Rest"].ToString());

        }
        return total.ToString();
    }

}