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
        string taskitem = context.Request["item"];
        string item = "";
        switch (taskitem)
        {
            case "Fixed":
                item = "体位固定";
                break;
            case "Location":
                item = "模拟定位";
                break;
            case "Accelerator":
                item = "加速器";
                break;
            case "Replacement":
                item = "复位模拟";
                break;
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