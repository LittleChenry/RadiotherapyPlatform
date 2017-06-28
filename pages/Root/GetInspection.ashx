<%@ WebHandler Language="C#" Class="GetInspection" %>

using System;
using System.Web;
using System.Text;

public class GetInspection : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getInformation(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string cycle = context.Request.QueryString["cycle"];
        string sqlCommand = "SELECT count(ID) FROM Inspection WHERE Cycle=@cycle";
        sqlOperation.AddParameterWithValue("@cycle", cycle);
        int sum = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        sqlCommand = "SELECT * FROM Inspection WHERE Cycle=@cycle ORDER BY MainItem";
        StringBuilder backString = new StringBuilder("[");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        int count = 1;
        while (reader.Read())
        {
            backString.Append("{\"MainItem\":\"");
            backString.Append(reader["MainItem"].ToString());
            backString.Append("\",\"ID\":\"");
            backString.Append(reader["ID"].ToString());
            backString.Append("\",\"ChildItem\":\"");
            backString.Append(reader["ChildItem"].ToString());
            backString.Append("\",\"UIMRTReference\":\"");
            backString.Append(reader["UIMRTReference"].ToString());
            backString.Append("\",\"UIMRTUnit\":\"");
            backString.Append(reader["UIMRTUnit"].ToString());
            backString.Append("\",\"UIMRTError\":\"");
            backString.Append(reader["UIMRTError"].ToString());
            backString.Append("\",\"IMRTReference\":\"");
            backString.Append(reader["IMRTReference"].ToString());
            backString.Append("\",\"IMRTUnit\":\"");
            backString.Append(reader["IMRTUnit"].ToString());
            backString.Append("\",\"IMRTError\":\"");
            backString.Append(reader["IMRTError"].ToString());
            backString.Append("\",\"SRSReference\":\"");
            backString.Append(reader["SRSReference"].ToString());
            backString.Append("\",\"SRSUnit\":\"");
            backString.Append(reader["SRSUnit"].ToString());
            backString.Append("\",\"SRSError\":\"");
            backString.Append(reader["SRSError"].ToString());
            backString.Append("\"}");
            if (count < sum)
                backString.Append(",");
            ++count;
        }
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose();
        return backString.ToString();
    }

}