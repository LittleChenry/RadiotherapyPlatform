﻿<%@ WebHandler Language="C#" Class="UpdateGroup" %>

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

        string sqlCommand = "UPDATE groups SET groupName=@gname WHERE ID=@gid";
        sqlOperation.AddParameterWithValue("@gid", gid);
        sqlOperation.AddParameterWithValue("@gname", groupName);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        sqlCommand = "UPDATE groups2user SET state=0,identity=0 WHERE Group_ID=@gid";
        sqlOperation.ExecuteNonQuery(sqlCommand);
        try
        {
            sqlCommand = "UPDATE groups2user SET state=0,identity=1 WHERE Group_ID=@gid AND User_ID=@uid";
            sqlOperation.AddParameterWithValue("@uid", int.Parse(nows[0]));
            if (nows[0] == nows[1])
            {
                sqlCommand = "UPDATE groups2user SET state=1,identity=1 WHERE Group_ID=@gid AND User_ID=@uid";
            }
            sqlOperation.ExecuteNonQuery(sqlCommand);
            if (nows[0] != nows[1])
            {
                sqlCommand = "UPDATE groups2user SET state=1,identity=2 WHERE Group_ID=@gid AND User_ID=@uid";
                sqlOperation.AddParameterWithValue("@uid", int.Parse(nows[1]));
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }

            for (int i = 2; i < nows.Length - 1; ++i)
            {
                sqlCommand = "UPDATE groups2user SET state=1,identity=3 WHERE Group_ID=@gid AND User_ID=@uid";
                sqlOperation.AddParameterWithValue("@uid", int.Parse(nows[i]));
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
        }
        catch (Exception e)
        {
            string msg = e.ToString();
        }

        //sqlCommand = "DELETE FROM groups2user WHERE Group_ID=@gid";
        //sqlOperation.ExecuteNonQuery(sqlCommand);

        //sqlCommand = "INSERT INTO groups2user(User_ID,Group_ID,identity) VALUES(@uid,@gid,@identity)";
        //sqlOperation.AddParameterWithValue("@uid", nows[0]);
        //sqlOperation.AddParameterWithValue("@identity",1);
        //sqlOperation.ExecuteNonQuery(sqlCommand);

        //sqlOperation.AddParameterWithValue("@uid", nows[1]);
        //sqlOperation.AddParameterWithValue("@identity", 2);
        //sqlOperation.ExecuteNonQuery(sqlCommand);

        //sqlOperation.AddParameterWithValue("@identity", 3);
        //for (int i = 2; i < nows.Length - 1; ++i)
        //{
        //    sqlOperation.AddParameterWithValue("@uid", nows[i]);
        //    sqlOperation.ExecuteNonQuery(sqlCommand);
        //}

        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
    }
}