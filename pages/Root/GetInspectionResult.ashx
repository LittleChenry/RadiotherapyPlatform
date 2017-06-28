<%@ WebHandler Language="C#" Class="GetInspectionResult" %>

using System;
using System.Web;
using System.Text;

public class GetInspectionResult : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getInformation();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getInformation()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        string sqlCommand2 = "";
        string sqlCommand = "SELECT COUNT(ID) FROM checkrecord";
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "[{\"ID\":\"null\"}]";
        }
        sqlCommand = "SELECT * FROM checkrecord ORDER BY checkDate desc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backString = new StringBuilder("[");
        int n = 1;
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"");
            backString.Append(reader["ID"].ToString());
            backString.Append("\",\"Date\":\"");
            backString.Append(reader["checkDate"].ToString());
            sqlCommand2 = "SELECT Name FROM equipment WHERE ID=@id";
            sqlOperation2.AddParameterWithValue("@id", reader["Equipment_ID"]);
            string equipmentName = sqlOperation2.ExecuteScalar(sqlCommand2);
            backString.Append("\",\"EquipmentName\":\"");
            backString.Append(equipmentName);
            backString.Append("\",\"Cycle\":\"");
            backString.Append(reader["checkCycle"].ToString());
            backString.Append("\",\"People\":\"");
            backString.Append(reader["checkPeople"].ToString());
            backString.Append("\"}");
            if (n < count)
                backString.Append(",");
        }
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        return backString.ToString();
    }
}