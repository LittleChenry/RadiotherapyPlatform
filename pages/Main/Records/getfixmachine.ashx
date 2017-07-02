<%@ WebHandler Language="C#" Class="getfixmachine" %>

using System;
using System.Web;
using System.Text;

public class getfixmachine : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getFixmachine(context);
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
   public string getFixmachine(HttpContext context)
    {
        string item = context.Request["item"];
        string taskitem;
        switch (item)
        {
            case "fixed":
                taskitem = "体位固定";
                break;
            
            case "location":
                taskitem = "模拟定位";
                break;
            default:
                taskitem = "";
            
            
            
            
            
            
            
            
        }
       
            
            
        string countItem = "SELECT count(*) FROM equipment where TreatmentItem=@item";
        sqlOperation.AddParameterWithValue("@item", item);
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT ID,Name FROM equipment where TreatmentItem=@item";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\"}");
            if (i < count)
            {

                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        return backText.ToString();
    }


}