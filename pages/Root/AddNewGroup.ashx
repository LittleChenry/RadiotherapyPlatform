<%@ WebHandler Language="C#" Class="AddNewGroup" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Text;

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
        string jsonStr = context.Request.Form["data"];
        string name = context.Request.Form["name"];
        JavaScriptSerializer js = new JavaScriptSerializer();
        LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);
        string sqlCommand = "INSERT INTO groups (groupName) VALUES (@groupName);SELECT @@IDENTITY";
        //sqlOperation.AddParameterWithValue("@Charge_User_Name", obj[0]["Name"].ToString());
        //sqlOperation.AddParameterWithValue("@userID", obj[0]["ID"].ToString());
        sqlOperation.AddParameterWithValue("@groupName", name);
        string groupsID = "";

        groupsID = sqlOperation.ExecuteScalar(sqlCommand);
        
        string higherID = obj[0]["ID"].ToString();
        string chargerID = obj[1]["ID"].ToString();

        sqlOperation.AddParameterWithValue("@gid",groupsID);
        sqlCommand = "INSERT INTO groups2user(User_ID,Group_ID,identity) VALUES(@uid,@gid,@identity)";
        sqlOperation.AddParameterWithValue("@uid", higherID);
        sqlOperation.AddParameterWithValue("@identity", 1);

        sqlOperation.ExecuteNonQuery(sqlCommand);

        sqlOperation.AddParameterWithValue("@uid", chargerID);
        sqlOperation.AddParameterWithValue("@identity", 2);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        sqlOperation.AddParameterWithValue("@identity", 3);

        for (int i = 2; i < obj.Length; ++i)
        {
            sqlOperation.AddParameterWithValue("@uid", obj[i]["ID"].ToString());
            try
            {
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
            catch (Exception e)
            {
                string msg = e.ToString();
            }
        }
        
        /*
        StringBuilder update = new StringBuilder("UPDATE user SET Group_ID=@Group_ID WHERE ID in(");
        for (int i = 0; i < obj.Length; ++i)
        {
            update.Append(obj[i]["ID"].ToString())
                  .Append(",");
        }
        update.Remove(update.Length - 1, 1);
        update.Append(")");
        sqlCommand = update.ToString();
        sqlOperation.AddParameterWithValue("@Group_ID", groupsID);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        string updateChargerGroupID = "UPDATE user SET Group_ID=-1 WHERE ID=@ID";
        sqlOperation.AddParameterWithValue("@ID", obj[0]["ID"].ToString());
        sqlOperation.ExecuteNonQuery(updateChargerGroupID);
        */
        
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;        
        
    }
}