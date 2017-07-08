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

        int count = 0;
        if (pres[1] != cid)
        {
            string select = "SELECT COUNT(ID) FROM groups WHERE Charge_User_ID=@preid";
            sqlOperation.AddParameterWithValue("@preid", pres[1]);
            if (int.Parse(sqlOperation.ExecuteScalar(select)) > 1)
            {
                count = 1;
            }
        }
        else if (pres[1] == cid)
        {
            count = 1;
        }

        //修改组名
        string sqlCommand = "UPDATE groups set groupName=@groupName,Charge_User_Name=@uName,Charge_User_ID=@cid WHERE ID=@gid";
        sqlOperation.AddParameterWithValue("@groupName", groupName);
        sqlOperation.AddParameterWithValue("@gid", gid);
        sqlOperation.AddParameterWithValue("@uName", cname);
        sqlOperation.AddParameterWithValue("@cid", cid);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        
        //成员置空
        int j = ((count == 1) ? 2 : 1);
        if (j < pres.Length)
        {
            StringBuilder update = new StringBuilder("UPDATE user set Group_ID=0 WHERE ID in(");
            for (int i = j; i < pres.Length - 1; i++)
            {
                update.Append(pres[i]).Append(",");
            }
            update.Remove(update.Length - 1, 1)
                  .Append(")");

            sqlCommand = update.ToString();
            sqlOperation.ExecuteNonQuery(sqlCommand);
        }
        
        //更新成员
        StringBuilder upUser = new StringBuilder("UPDATE user SET Group_ID=@gid WHERE ID in(");
        for (int i = 1; i < nows.Length - 1; ++i)
        {
            upUser.Append(nows[i]).Append(",");
        }
        upUser.Remove(upUser.Length - 1, 1)
            .Append(")");
        sqlCommand = upUser.ToString();
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (pres[1] != cid)
        {
            sqlCommand = "UPDATE user set Group_ID=-1 WHERE ID=@id";
            sqlOperation.AddParameterWithValue("@id", cid);
            sqlOperation.ExecuteNonQuery(sqlCommand);
        }

        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
    }
}