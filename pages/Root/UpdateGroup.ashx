<%@ WebHandler Language="C#" Class="UpdateGroup" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Text;

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

        string pre = context.Request.Form["pre"];
        string[] pres = pre.Split(' ');

        string now = context.Request.Form["now"];
        string []nows = now.Split(' ');

        string gid = pres[0];
        string groupName = context.Request.Form["name"];

        string cname = context.Request.Form["chargerName"];
        string cid = nows[0];

        //修改组名
        string sqlCommand = "UPDATE groups set groupName=@groupName,Charge_User_Name=@uName,Charge_User_ID=@cid WHERE ID=@gid";
        sqlOperation.AddParameterWithValue("@groupName", groupName);
        sqlOperation.AddParameterWithValue("@gid", gid);
        sqlOperation.AddParameterWithValue("@uName", cname);
        sqlOperation.AddParameterWithValue("@cid", cid);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        
        //成员置空
        StringBuilder update = new StringBuilder("UPDATE user set Group_ID=0 WHERE ID in(");
        for (int i = 1; i < pres.Length - 1; i++)
        {
            update.Append(pres[i]).Append(",");
        }
        update.Remove(update.Length - 1, 1)
              .Append(")");
        
        sqlCommand = update.ToString();
        sqlOperation.ExecuteNonQuery(sqlCommand);
        
        //更新成员
        StringBuilder upUser = new StringBuilder("UPDATE user SET Group_ID=@gid WHERE ID in(");
        for (int i = 0; i < nows.Length - 1; ++i)
        {
            upUser.Append(nows[i]).Append(",");
        }
        upUser.Remove(upUser.Length - 1, 1)
            .Append(")");
        sqlCommand = upUser.ToString();
        sqlOperation.ExecuteNonQuery(sqlCommand);
        //string jsonStr = context.Request.Form["data"];
        //JavaScriptSerializer js = new JavaScriptSerializer();
        //LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);
        //string remove = context.Request.Form["delete"];
        //string[] removes = remove.Split(' ');
        //string removeSql = "UPDATE user SET Group_ID=0 WHERE ID in(";
        //int len = removes.Length;
        //bool changeCharger = false;
        //if(int.Parse(removes[0]) != int.Parse(obj[0]["ID"].ToString())){
        //    changeCharger = true;
        //    sqlOperation.AddParameterWithValue("@CID", obj[0]["ID"].ToString());
        //    sqlOperation.AddParameterWithValue("@gid", obj[obj.Length - 1]["GroupID"].ToString());
        //    sqlOperation.AddParameterWithValue("@Cname", obj[0]["Name"].ToString());
        //    sqlOperation.ExecuteNonQuery("UPDATE groups SET Charge_User_Name=@Cname,Charge_User_ID=@CID WHERE ID=@gid");
        //}
        //if (len > 2)
        //{
        //    for (int i = 1; i < len; ++i)
        //    {
        //        if (removes[i] != "")
        //        {
        //            removeSql += removes[i];
        //            if (i != (len - 2))
        //            {
        //                removeSql += ",";
        //            }
        //        }
        //    }
        //    if (changeCharger)
        //    {
        //        removeSql += "," + removes[0];
        //    }
        //    removeSql += ")";
        //    sqlOperation.ExecuteNonQuery(removeSql);
        //}
        
        //string sqlCommand = "UPDATE groups SET Charge_User_Name = @name WHERE ID=@id";
        //sqlOperation.AddParameterWithValue("@name", obj[0]["Name"].ToString());
        //sqlOperation.AddParameterWithValue("@id", obj[0]["ID"].ToString());
        //sqlOperation.ExecuteNonQuery(sqlCommand);
        //sqlCommand = "UPDATE user SET Group_ID=@gid WHERE ID in(";
        //sqlOperation.AddParameterWithValue("@gid", obj[obj.Length - 1]["GroupID"].ToString());
        //for (int i = 0; i < obj.Length - 1; i++)
        //{
        //    sqlCommand += obj[i]["ID"];
        //    if (i != obj.Length - 2)
        //    {
        //        sqlCommand += ",";
        //    }
        //}
        //sqlCommand += ")";
        //sqlOperation.ExecuteNonQuery(sqlCommand);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
    }
}