<%@ WebHandler Language="C#" Class="getCheckRecord" %>

using System;
using System.Web;
using System.Text;

public class getCheckRecord : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = getRecord(context);
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private String getRecord(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string date = context.Request.Form["date"];
        string eid = context.Request.Form["equipmentID"];

        string sqlCommand = "SELECT inspection.ChildItem,checkresult.IMRTRealValue,DATE_FORMAT(checkrecord.checkDate,'%e') checkDate FROM inspection LEFT JOIN checkresult ON inspection.ID=checkresult.Inspection_ID LEFT JOIN checkrecord ON checkresult.Record_ID=checkrecord.ID WHERE checkrecord.checkCycle='day' AND DATE_FORMAT(checkrecord.checkDate,'%Y-%m')=@date AND checkrecord.Equipment_ID=@eid";
        sqlOperator.AddParameterWithValue("@date", date);
        sqlOperator.AddParameterWithValue("@eid", eid);

        StringBuilder result = new StringBuilder("[");

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);

        string day = "";
        string lastDay = "";
        if (reader.Read())
        {
            //找到第一个有记录的天，之前的为空记录
            day = reader["checkDate"].ToString();
            int d = int.Parse(day);
            for (int i = 1; i < d; i++)
            {
                result.Append("{},");
            }
            result.Append("{\"").Append(reader["ChildItem"].ToString()).Append("\":\"")
                  .Append(reader["IMRTRealValue"].ToString()).Append("\",");
        }
        else
        {
            for (int i = 0; i < 31; i++)
            {
                result.Append("{},");
            }
            result.Remove(result.Length - 1, 1).Append("]");
            return result.ToString();
        }
        while (reader.Read())
        {
            string now = reader["checkDate"].ToString();
            if (now != day)
            {
                result.Remove(result.Length - 1, 1).Append("},");
                int n = int.Parse(now);
                int d = int.Parse(day);
                for (int i = d + 1; i < n; i++)
                {
                    result.Append("{},");
                }
                result.Append("{\"").Append(reader["ChildItem"].ToString()).Append("\":\"")
                  .Append(reader["IMRTRealValue"].ToString()).Append("\",");
                day = now;
            }
            else
            {
                result.Append("\"").Append(reader["ChildItem"].ToString()).Append("\":\"")
                      .Append(reader["IMRTRealValue"].ToString()).Append("\",");
            }
            lastDay = reader["checkDate"].ToString();
        }
        
        result.Remove(result.Length-1,1).Append("}");
        
        int ld = int.Parse(lastDay.Split(' ')[0]);
        for (int i = ld; i < 31; i++)
        {
            result.Append(",{}");
        }

        result.Append("]");
        return result.ToString();
    }
}