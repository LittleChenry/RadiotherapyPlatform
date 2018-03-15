<%@ WebHandler Language="C#" Class="addWorkTimeTable" %>

using System;
using System.Web;
using System.Text;

public class addWorkTimeTable : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        if (context.Request.Form["code"] == "add")
        {
            context.Response.Write(add(context));
        }
        if (context.Request.Form["code"] == "get")
        {
            context.Response.Write(get(context));
        }
        if (context.Request.Form["code"] == "delete")
        {
            context.Response.Write(delete(context));
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string delete(HttpContext context)
    {
        string id = context.Request.Form["ID"];
        string updateSQL = "update worktimetable set isused = 0 where id = @ID";
        sqlOperation.AddParameterWithValue("@ID", id);
        int success = sqlOperation.ExecuteNonQuery(updateSQL);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        if (success > 0)
        {
            return "success";
        }
        else
        {
            return "fail";
        }
    }
    public string get(HttpContext context)
    {
        string month = context.Request.Form["month"];
        DateTime date = new DateTime(DateTime.Now.Year,Convert.ToInt32(month),1);
        string dateStr = date.ToString("yyyy-MM");
        string selectSQL = "select ID,DATE_FORMAT(date,'%Y-%m-%d') as Date,isused,DATE_FORMAT(modifytime,'%Y-%m-%d') as ModifyTime from worktimetable where date_format(date,'%Y-%m')=@date and isused = 1 order by date";
        sqlOperation.AddParameterWithValue("@date", dateStr);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectSQL);
        StringBuilder backString = new StringBuilder("[");
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"");
            backString.Append(reader["ID"].ToString());
            backString.Append("\",\"Date\":\"");
            backString.Append(reader["Date"].ToString());
            backString.Append("\",\"IsUsed\":\"");
            backString.Append(reader["IsUsed"].ToString());
            backString.Append("\",\"ModifyTime\":\"");
            backString.Append(reader["ModifyTime"].ToString());
            backString.Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1);
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backString.ToString();
    }
    public string add(HttpContext context)
    {
        
        string date = context.Request.Form["date"];
        string modifyTime = DateTime.Now.ToString("yyyy-MM-dd");
        string selectSQL = "select count(1) from WorkTimeTable where date = @date";
        sqlOperation.AddParameterWithValue("@date", date);
        int result = Convert.ToInt32(sqlOperation.ExecuteScalar(selectSQL));
        if (result > 0)
        {
            string updateSQL = "update WorkTimeTable set isused = 1 where date = @date";
            sqlOperation.AddParameterWithValue("@date", date);
            int success = sqlOperation.ExecuteNonQuery(updateSQL);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "fail";
            }
        }
        else
        {
            string insertSQL = "insert into worktimetable (date,isused,modifytime) values(@date,@isused,@modifytime)";
            sqlOperation.AddParameterWithValue("@date",date);
            sqlOperation.AddParameterWithValue("@isused", 1);
            sqlOperation.AddParameterWithValue("@modifytime", modifyTime);
            int success = sqlOperation.ExecuteNonQuery(insertSQL);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "fail";
            }
        }
    }
}