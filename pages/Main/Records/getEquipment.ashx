<%@ WebHandler Language="C#" Class="getEquipment" %>

using System;
using System.Web;
using System.Text;
public class getEquipment : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
  
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
           
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getfixrecordinfo(HttpContext context)
    {               
        DateTime date = DateTime.Now;
        string date1 = date.ToString("yyyy-MM-dd");
        string sqlCommand = "SELECT count(*) from equipment";       
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        int i = 1;
        string sqlCommand2 = "select equipment.ID as eqid,equipment.Name as eqname,TreatmentItem,Type from equipmenttype,equipment where equipment.EquipmentType=equipmenttype.ID";       
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        StringBuilder backText = new StringBuilder("{\"EquipmentInfo\":[");

        while (reader.Read())
        {
            backText.Append("{\"equipmentID\":\"" + reader["eqid"].ToString() + "\",\"equipmentName\":\"" + reader["eqname"].ToString() +
                    "\",\"TreatmentItem\":\"" + reader["TreatmentItem"].ToString() + "\",\"Type\":\"" + reader["Type"].ToString() + "\"}");

            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        reader.Close();       
        // backText.Remove(backText.Length - 1, 1);                
        backText.Append("]}");
        return backText.ToString();
    }
}