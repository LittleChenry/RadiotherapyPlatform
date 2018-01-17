<%@ WebHandler Language="C#" Class="updatesql" %>

using System;
using System.Web;
using System.Text;


public class updatesql : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        updatesqlcom();
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private void updatesqlcom()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        string command = "select ID,Name from headrest";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command);
        while (reader.Read())
        {
            string command2 = "update fixed set HeadRest_ID=@head where HeadRest_ID=@id";
            sqlOperation2.AddParameterWithValue("@head", reader["Name"].ToString());
            sqlOperation2.AddParameterWithValue("@id", reader["ID"].ToString());
            sqlOperation2.ExecuteNonQuery(command2);
            
        }
        reader.Close();
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
     
    }
    
    
    
    
    
    

}