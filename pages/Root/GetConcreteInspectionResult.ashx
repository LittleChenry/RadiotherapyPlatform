<%@ WebHandler Language="C#" Class="GetConcreteInspectionResult" %>

using System;
using System.Web;
using System.Text;

public class GetConcreteInspectionResult : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = InspectionResult(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string InspectionResult(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        string id = context.Request.QueryString["id"];
        string sqlCommand = "SELECT COUNT(ID) FROM checkresult WHERE Record_ID=@id";
        string sqlCommand2 = "";
        sqlOperation.AddParameterWithValue("@id", id);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
            return "[{\"MainItem\":\"null\"}]";
        sqlCommand = "SELECT * FROM checkresult WHERE Record_ID=@id";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        MySql.Data.MySqlClient.MySqlDataReader reader2;
        StringBuilder backString = new StringBuilder("[");
        sqlCommand2 = "SELECT Name From user WHERE ID=@uid";
        sqlOperation2.AddParameterWithValue("@uid", context.Request.QueryString["people"]);
        backString.Append("{\"name\":\"");        
        string name = sqlOperation2.ExecuteScalar(sqlCommand2);
        backString.Append(name + "\"},");
        int n = 1;
        while (reader.Read())
        {
            backString.Append("{\"MainItem\":\"");
            sqlCommand2 = "SELECT MainItem,ChildItem FROM Inspection WHERE ID=@InsID";
            sqlOperation2.AddParameterWithValue("@InsID", reader["Inspection_ID"].ToString());
            reader2 = sqlOperation2.ExecuteReader(sqlCommand2);
            if (reader2.Read())
            {
                backString.Append(reader2["MainItem"].ToString());
                backString.Append("\",\"ChildItem\":\"");
                backString.Append(reader2["ChildItem"].ToString());
            }
            reader2.Close();
            backString.Append("\",\"UIMRTRealValue\":\"");
            backString.Append(reader["UIMRTRealValue"].ToString());
            backString.Append("\",\"UIMRTState\":\"");
            backString.Append(reader["UIMRTState"].ToString());
            backString.Append("\",\"IMRTRealValue\":\"");
            backString.Append(reader["IMRTRealValue"].ToString());
            backString.Append("\",\"IMRTState\":\"");
            backString.Append(reader["IMRTState"].ToString());
            backString.Append("\",\"SRSRealValue\":\"");
            backString.Append(reader["SRSRealValue"].ToString());
            backString.Append("\",\"SRSState\":\"");
            backString.Append(reader["SRSState"].ToString());
            backString.Append("\",\"FunctionalStatus\":\"");
            backString.Append(reader["FunctionalStatus"].ToString());
            backString.Append("\"}");
            if (n < count)
            {
                backString.Append(",");
            }
            ++n;
        }
        reader.Close();
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose(); 
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        return backString.ToString();
    }
    
}