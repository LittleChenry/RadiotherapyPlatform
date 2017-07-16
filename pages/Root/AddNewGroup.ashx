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

        DataLayer sqlInner = new DataLayer("sqlStr");
        sqlInner.AddParameterWithValue("@gid", groupsID);
        string sqlcommandInner = "";
        sqlCommand = "SELECT ID FROM user";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            string id = reader["ID"].ToString();
            int identity = 0, state = 0;
            sqlcommandInner = "INSERT INTO groups2user(User_ID,Group_ID,identity,state) VALUES(@uid,@gid,@identity,@state)";
            sqlInner.AddParameterWithValue("@uid", id);
            identity = checkIdentity(id,obj);
            sqlInner.AddParameterWithValue("@identity",identity);
            state = checkState(id, obj);
            if (identity == 1 && obj.Length > 2)
            {
                state = 0;
            }
            sqlInner.AddParameterWithValue("@state", state);
            sqlInner.ExecuteNonQuery(sqlcommandInner);
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

    private int checkIdentity(string id, LitJson.JsonData[] obj)
    {
        for (int i = 0; i < obj.Length; ++i)
        {
            if (id == obj[i]["ID"].ToString())
            {
                if (i == 0)
                    return 1;
                else if (i == 1)
                    return 2;
                else
                    return 3;
            }
        }
        return 0;
    }

    private int checkState(string id, LitJson.JsonData[] obj)
    {
        for (int i = 0; i < obj.Length; ++i)
        {
            if (id == obj[i]["ID"].ToString())
                return 1;
        }
        return 0;
    }
}