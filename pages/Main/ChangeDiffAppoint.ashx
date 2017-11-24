<%@ WebHandler Language="C#" Class="ChangeDiffAppoint" %>

using System;
using System.Web;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

public class ChangeDiffAppoint : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        deleteandchange(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private void deleteandchange(HttpContext context)
    {
        string equipid = context.Request["EquipmentID"];
        string day1 = context.Request["day1"];
        string day2 = context.Request["day2"];
        string countcommand = "select count(*) from appointment_accelerate where Date=@day1 and Equipment_ID=@Equipment_ID and Completed=0";
        sqlOperation.AddParameterWithValue("@day1", day1);
        sqlOperation.AddParameterWithValue("@Equipment_ID", equipid);
        int count =int.Parse(sqlOperation.ExecuteScalar(countcommand));

        string selectday1 = "select ID,Begin from appointment_accelerate where Date=@day1 and Equipment_ID=@Equipment_ID and  Completed=0 order by Begin asc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectday1);
        int i=1;
        StringBuilder backString1 = new StringBuilder("[");
        while (reader.Read())
        {
            backString1.Append("{\"appointid\":\"" + reader["ID"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\"}");
            if (i < count)
            {
                backString1.Append(",");
            }
  
        }
        reader.Close();
        backString1.Append("]");

        string countcommand2 = "select count(*) from appointment_accelerate where Date=@day1 and Equipment_ID=@Equipment_ID and Completed=0";
        sqlOperation.AddParameterWithValue("@day1", day2);
        count = int.Parse(sqlOperation.ExecuteScalar(countcommand2));

        string selectday2 = "select ID,Begin from appointment_accelerate where Date=@day1 and Equipment_ID=@Equipment_ID and  Completed=0 order by Begin asc";
        reader = sqlOperation.ExecuteReader(selectday2);
        i = 1;
        StringBuilder backString2 = new StringBuilder("[");
        while (reader.Read())
        {
            backString2.Append("{\"appointid\":\"" + reader["ID"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\"}");
            if (i < count)
            {
                backString2.Append(",");
            }

        }
        reader.Close();
        backString2.Append("]");
        JArray jday1 = (JArray)JsonConvert.DeserializeObject(backString1.ToString());
        JArray jday2 = (JArray)JsonConvert.DeserializeObject(backString2.ToString());
        int len1 = jday1.Count;
        int len2 = jday2.Count;
        int point1 = 0;
        int point2 = 0;
        while (true)
        { 
             if (point1 >= len1 && point2 >= len2)
            {
                break;
            }
             if (point1 >= len1 && point2 < len2)
            {
                for (int temp= point2; temp < len2; temp++)
                {
                    string selectanother = "select count(*) from appointment_accelerate where Date=@date and Begin=@begin and Equipment_ID=@Equipment_ID";
                    sqlOperation.AddParameterWithValue("@date", day1);
                    sqlOperation.AddParameterWithValue("@begin", jday2[temp]["Begin"].ToString());
                    sqlOperation.AddParameterWithValue("@Equipment_ID", equipid);
                    int result = int.Parse(sqlOperation.ExecuteScalar(selectanother));
                    if (result == 0)
                    {
                        string updatetime = "update appointment_accelerate set Date=@date2 where ID=@appointid";
                        sqlOperation.AddParameterWithValue("@date2", day1);
                        sqlOperation.AddParameterWithValue("@appointid", jday2[temp]["appointid"].ToString());
                        sqlOperation.ExecuteNonQuery(updatetime);
                    }
                }
                break;
            }
             if (point1 < len1 && point2 >= len2)
             {
                 for (int temp = point1; temp < len1; temp++)
                 {
                     string selectanother = "select count(*) from appointment_accelerate where Date=@date and Begin=@begin and Equipment_ID=@Equipment_ID";
                     sqlOperation.AddParameterWithValue("@date", day2);
                     sqlOperation.AddParameterWithValue("@begin", jday1[temp]["Begin"].ToString());
                     sqlOperation.AddParameterWithValue("@Equipment_ID", equipid);
                     int result = int.Parse(sqlOperation.ExecuteScalar(selectanother));
                     if (result == 0)
                     {
                         string updatetime = "update appointment_accelerate set Date=@date2 where ID=@appointid";
                         sqlOperation.AddParameterWithValue("@date2", day2);
                         sqlOperation.AddParameterWithValue("@appointid", jday1[temp]["appointid"].ToString());
                         sqlOperation.ExecuteNonQuery(updatetime);
                     }
                 }
                 break;
             }
            if (int.Parse(jday1[point1]["Begin"].ToString()) < int.Parse(jday2[point2]["Begin"].ToString()))
            {
                string selectanother = "select count(*) from appointment_accelerate where Date=@date and Begin=@begin and Equipment_ID=@Equipment_ID";
                sqlOperation.AddParameterWithValue("@date", day2);
                sqlOperation.AddParameterWithValue("@begin", jday1[point1]["Begin"].ToString());
                sqlOperation.AddParameterWithValue("@Equipment_ID", equipid);
                int result = int.Parse(sqlOperation.ExecuteScalar(selectanother));
                if (result == 0)
                {
                    string updatetime = "update appointment_accelerate set Date=@date2 where ID=@appointid";
                    sqlOperation.AddParameterWithValue("@date2", day2);
                    sqlOperation.AddParameterWithValue("@appointid", jday1[point1]["appointid"].ToString());
                    sqlOperation.ExecuteNonQuery(updatetime);
                }
                point1++;
                continue;
 
            }
            if (int.Parse(jday1[point1]["Begin"].ToString()) > int.Parse(jday2[point2]["Begin"].ToString()))
            {
                string selectanother = "select count(*) from appointment_accelerate where Date=@date and Begin=@begin and Equipment_ID=@Equipment_ID";
                sqlOperation.AddParameterWithValue("@date", day1);
                sqlOperation.AddParameterWithValue("@begin", jday2[point2]["Begin"].ToString());
                sqlOperation.AddParameterWithValue("@Equipment_ID", equipid);
                int result = int.Parse(sqlOperation.ExecuteScalar(selectanother));
                if (result == 0)
                {
                    string updatetime = "update appointment_accelerate set Date=@date2 where ID=@appointid";
                    sqlOperation.AddParameterWithValue("@date2", day1);
                    sqlOperation.AddParameterWithValue("@appointid", jday2[point2]["appointid"].ToString());
                    sqlOperation.ExecuteNonQuery(updatetime);
                }
                point2++;
                continue;
 

            }
            if (int.Parse(jday1[point1]["Begin"].ToString()) == int.Parse(jday2[point2]["Begin"].ToString()))
            {

                string updatetime = "update appointment_accelerate set Date=@date2 where ID=@appointid";
                sqlOperation.AddParameterWithValue("@date2", day1);
                sqlOperation.AddParameterWithValue("@appointid", jday2[point2]["appointid"].ToString());
                sqlOperation.ExecuteNonQuery(updatetime);
                string updatetime2 = "update appointment_accelerate set Date=@date2 where ID=@appointid";
                sqlOperation.AddParameterWithValue("@date2", day2);
                sqlOperation.AddParameterWithValue("@appointid", jday1[point1]["appointid"].ToString());
                sqlOperation.ExecuteNonQuery(updatetime2);
                point1++;
                point2++;
                continue;

            }
           
        }
    }
}