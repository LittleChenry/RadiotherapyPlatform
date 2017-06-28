<%@ WebHandler Language="C#" Class="UpdateGroup" %>

using System;
using System.Web;
using System.Web.Script.Serialization;

public class UpdateGroup : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/x-www-form-urlencoded";
        update(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void update(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string jsonStr = context.Request.Form["data"];
        JavaScriptSerializer js = new JavaScriptSerializer();
        LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);
        string remove = context.Request.Form["delete"];
        string[] removes = remove.Split(' ');
        string removeSql = "UPDATE user SET Group_ID=0 WHERE ID in(";
        int len = removes.Length;
        bool changeCharger = false;
        if(int.Parse(removes[0]) != int.Parse(obj[0]["ID"].ToString())){
            changeCharger = true;
            sqlOperation.AddParameterWithValue("@CID", obj[0]["ID"].ToString());
            sqlOperation.AddParameterWithValue("@gid", obj[obj.Length - 1]["GroupID"].ToString());
            sqlOperation.AddParameterWithValue("@Cname", obj[0]["Name"].ToString());
            sqlOperation.ExecuteNonQuery("UPDATE groups SET Charge_User_Name=@Cname,Charge_User_ID=@CID WHERE ID=@gid");
        }
        if (len > 2)
        {
            for (int i = 1; i < len; ++i)
            {
                if (removes[i] != "")
                {
                    removeSql += removes[i];
                    if (i != (len - 2))
                    {
                        removeSql += ",";
                    }
                }
            }
            if (changeCharger)
            {
                removeSql += "," + removes[0];
            }
            removeSql += ")";
            sqlOperation.ExecuteNonQuery(removeSql);
        }
        
        string sqlCommand = "UPDATE groups SET Charge_User_Name = @name WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@name", obj[0]["Name"].ToString());
        sqlOperation.AddParameterWithValue("@id", obj[0]["ID"].ToString());
        sqlOperation.ExecuteNonQuery(sqlCommand);
        sqlCommand = "UPDATE user SET Group_ID=@gid WHERE ID in(";
        sqlOperation.AddParameterWithValue("@gid", obj[obj.Length - 1]["GroupID"].ToString());
        for (int i = 0; i < obj.Length - 1; i++)
        {
            sqlCommand += obj[i]["ID"];
            if (i != obj.Length - 2)
            {
                sqlCommand += ",";
            }
        }
        sqlCommand += ")";
        sqlOperation.ExecuteNonQuery(sqlCommand);
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}