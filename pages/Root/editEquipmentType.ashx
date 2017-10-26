<%@ WebHandler Language="C#" Class="editEquipmentType" %>

using System;
using System.Web;

public class editEquipmentType : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        update(context);
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void update(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string type = context.Request.Form["type"];
        string id = context.Request.Form["id"];
        string isDefault = context.Request.Form["isDefault"];

        string sqlCommand = "UPDATE equipmenttype set Type=@Type,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperator.clearParameter();
        sqlOperator.AddParameterWithValue("@Type", type);
        sqlOperator.AddParameterWithValue("@IsDefault", int.Parse(isDefault));
        sqlOperator.AddParameterWithValue("@id", id);
        sqlOperator.ExecuteNonQuery(sqlCommand);

        if (isDefault == "0")
        {
            string sqlCommand1 = "update equipmenttype set IsDefault=1 where ID != @ID";
            sqlOperator.clearParameter();
            sqlOperator.AddParameterWithValue("@ID", id);
            sqlOperator.ExecuteNonQuery(sqlCommand1);
        }

        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
    }

}