<%@ WebHandler Language="C#" Class="getEquipIDAndName" %>

using System;
using System.Web;
using System.Text;

public class getEquipIDAndName : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getequipstring(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getequipstring(HttpContext context)
    {
        string task = context.Request["task"];
        string command = "select count(*) from equipment where TreatmentItem=@task and state=1";
        sqlOperation.AddParameterWithValue("@task", task);
        int count = int.Parse(sqlOperation.ExecuteScalar(command));
        string command2 = "select Name,ID from equipment where TreatmentItem=@task and state=1";
        StringBuilder backstring = new StringBuilder("{\"machine\":[");
        int i=1;
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command2);
        while (reader.Read())
        {
            backstring.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\"}");
            if (i < count)
            {
                backstring.Append(",");
                
            }
            i++;
        
        }
        backstring.Append("]}");
        return backstring.ToString();
        
        
    }

}