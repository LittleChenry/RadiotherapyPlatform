<%@ WebHandler Language="C#" Class="getMainItemLength" %>

using System;
using System.Web;
using System.Text;

public class getMainItemLength : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getMain(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getMain(HttpContext context)
    {
        string eid = context.Request.Form["equipmentID"];
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string command = "SELECT DISTINCT inspections.TemplateID FROM checkrecord LEFT JOIN checkresults ON checkrecord.id=checkresults.Record_ID LEFT JOIN inspections ON checkresults.Inspections_ID=inspections.ID WHERE Equipment_ID=@eid";
        sqlOperator.AddParameterWithValue("@eid", eid);
        int tid = int.Parse(sqlOperator.ExecuteScalar(command));
        command = "SELECT MainItem FROM inspections WHERE TemplateID=@tid ORDER BY MainItem";
        sqlOperator.AddParameterWithValue("@tid", tid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(command);
        StringBuilder sb = new StringBuilder("[");
        string current = "";
        int times = 0;
        if (reader.Read())
        {
            current = reader["MainItem"].ToString();
            ++times;
        }
        while (reader.Read())
        {
            string now = reader["MainItem"].ToString();
            if (now != current)
            {
                sb.Append("{\"name\":\"").Append(current)
                  .Append("\",\"len\":\"").Append(times)
                  .Append("\"},");
                times = 1;
                current = now;
            }
            else
            {
                ++times;
            }
        }
        sb.Append("{\"name\":\"").Append(current)
          .Append("\",\"len\":\"").Append(times)
          .Append("\"}]");
        return sb.ToString();
    }

}