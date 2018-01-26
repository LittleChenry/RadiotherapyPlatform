<%@ WebHandler Language="C#" Class="getFirstAccTime" %>

using System;
using System.Web;
using System.Text;

public class getFirstAccTime : IHttpHandler { 
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if(context.Request.Form["type"] == "get"){
            string result = get(context);
            context.Response.Write(result);
        }
        if (context.Request.Form["type"] == "add"){
            string result = add(context);
            context.Response.Write(result);
        }
        if(context.Request.Form["type"] == "edit"){
            string result = edit(context);
            context.Response.Write(result);
        }
        if(context.Request.Form["type"] == "delete"){
            string result = delete(context);
            context.Response.Write(result);
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    //get
    public string get(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT id,name,begintime,endtime FROM firstacctime ORDER BY begintime";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);
        StringBuilder backString = new StringBuilder("[");
        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["id"].ToString())
                      .Append("\",\"name\":\"")
                      .Append(reader["name"].ToString())
                      .Append("\",\"begintime\":\"")
                      .Append(reader["begintime"].ToString())
                      .Append("\",\"endtime\":\"")
                      .Append(reader["endtime"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
        return backString.ToString();
    }
    //add
    public string add(HttpContext context)
    {
        string name = context.Request.Form["name"];
        string addBeginHour = context.Request.Form["addBeginHour"];
        string addBeginMinute = context.Request.Form["addBeginMinute"];
        string addEndHour = context.Request.Form["addEndHour"];
        string addEndMinute = context.Request.Form["addEndMinute"];

        int beginTime = Convert.ToInt32(addBeginHour) * 60 + Convert.ToInt32(addBeginMinute);
        int endTime = Convert.ToInt32(addEndHour) * 60 + Convert.ToInt32(addEndMinute);

        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string selectCommand = "SELECT id,name,begintime,endtime FROM firstacctime";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation1.ExecuteReader(selectCommand);
        while (reader.Read())
        {
            if ((Convert.ToInt32(reader["begintime"]) >= endTime) || (Convert.ToInt32(reader["endtime"]) <= beginTime))
            {
                continue;
            }
            else
            {
                return "repeat";
            }
        }
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        string insertCommand = "INSERT INTO firstacctime (name,begintime,endtime) VALUES(@name,@begintime,@endtime)";
        sqlOperation2.AddParameterWithValue("@name",name);
        sqlOperation2.AddParameterWithValue("@begintime", beginTime);
        sqlOperation2.AddParameterWithValue("@endtime", endTime);
        int success = sqlOperation2.ExecuteNonQuery(insertCommand);

        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        
        if (success > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }

    }

    public string edit(HttpContext context)
    {
        string name = context.Request.Form["name"];
        string editBeginHour = context.Request.Form["editBeginHour"];
        string editBeginMinute = context.Request.Form["editBeginMinute"];
        string editEndHour = context.Request.Form["editEndHour"];
        string editEndMinute = context.Request.Form["editEndMinute"];
        string editID = context.Request.Form["editID"];

        int beginTime = Convert.ToInt32(editBeginHour) * 60 + Convert.ToInt32(editBeginMinute);
        int endTime = Convert.ToInt32(editEndHour) * 60 + Convert.ToInt32(editEndMinute);

        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string selectCommand = "SELECT id,name,begintime,endtime FROM firstacctime";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation1.ExecuteReader(selectCommand);
        while (reader.Read())
        {
            string id = reader["id"].ToString();
            if(reader["id"].ToString() == editID){
                continue;
            }
            if ((Convert.ToInt32(reader["begintime"]) >= endTime) || (Convert.ToInt32(reader["endtime"]) <= beginTime))
            {
                continue;
            }
            else
            {
                return "repeat";
            }
        }

        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        string updateCommand = "UPDATE firstacctime SET name=@name,begintime=@begintime,endtime=@endtime WHERE id=@id";
        sqlOperation2.AddParameterWithValue("@name", name);
        sqlOperation2.AddParameterWithValue("@begintime",beginTime);
        sqlOperation2.AddParameterWithValue("@endtime",endTime);
        sqlOperation2.AddParameterWithValue("@id",editID);
        int success = sqlOperation2.ExecuteNonQuery(updateCommand);

        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        
        if (success > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }

    }

    public string delete(HttpContext context)
    {
        string editID = context.Request.Form["editID"];
        string deleteCommand = "DELETE FROM firstacctime WHERE ID=@ID";

        DataLayer sqlOperation = new DataLayer("sqlStr");
        sqlOperation.AddParameterWithValue("@ID",editID);
        int success = sqlOperation.ExecuteNonQuery(deleteCommand);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        if (success > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }
    }
}