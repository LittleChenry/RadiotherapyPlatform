<%@ WebHandler Language="C#" Class="AddNewGroup" %>

using System;
using System.Web;
using System.Web.Script.Serialization;

public class AddNewGroup : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        //context.Response.ContentType = "text/plain";
        context.Response.ContentType = "application/x-www-form-urlencoded";
        Insert(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void Insert(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        var jsonStr = context.Request.Form["data"];
        JavaScriptSerializer js = new JavaScriptSerializer();
        LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);
        string sqlCommand = "SELECT ID FROM groups WHERE Charge_User_ID=@ID";
        sqlOperation.AddParameterWithValue("@ID", obj[0]["ID"].ToString());
        string has = sqlOperation.ExecuteScalar(sqlCommand);
        string groupsID = "";
        if (has != "")
        {
            try
            {
                sqlCommand = "UPDATE groups SET Charge_User_Name='',Charge_User_ID=0 WHERE ID=" + has;
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
            catch (Exception ex)
            {
                string messg = ex.Message;
            }
        }
        sqlCommand = "INSERT INTO groups (Charge_User_Name,Charge_User_ID) VALUES (@Charge_User_Name,@ID);SELECT @@IDENTITY";
        string name = obj[0]["Name"].ToString();
        sqlOperation.AddParameterWithValue("@Charge_User_Name", name);
        sqlOperation.AddParameterWithValue("@ID", obj[0]["ID"]);
        groupsID = sqlOperation.ExecuteScalar(sqlCommand);
        for (int i = 0; i < obj.Length; i++)
        {
            string sqlInsert = "UPDATE user SET Group_ID=@Group_ID WHERE ID=@ID";
            sqlOperation.AddParameterWithValue("@Group_ID", groupsID);
            sqlOperation.AddParameterWithValue("@ID", obj[i]["ID"].ToString());
            sqlOperation.ExecuteNonQuery(sqlInsert);
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}