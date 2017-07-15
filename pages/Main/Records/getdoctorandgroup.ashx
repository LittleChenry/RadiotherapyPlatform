<%@ WebHandler Language="C#" Class="getdoctorandgroup" %>

using System;
using System.Web;
using System.Text;
using System.Collections;

public class getdoctorandgroup : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getdocandgroup(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getdocandgroup(HttpContext context)
    {
        string users = "SELECT distinct(user.ID) as userid FROM user,user2role where user.ID=user2role.User_ID and user2role.Role_ID=2";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(users);
        ArrayList array = new ArrayList();
        while (reader.Read())
        {
            array.Add(reader["userid"].ToString());
            
        }
        reader.Close();
        StringBuilder backText = new StringBuilder("{\"Item\":{");
        foreach (string element in array)
        {
              string selectusername = "select Name from user where user.ID=@userid";
              sqlOperation.AddParameterWithValue("@userid", Convert.ToInt32(element));
              string username = sqlOperation.ExecuteScalar(selectusername);
              backText.Append("\"" + username + element + "\":[{\"userid\":\"" + element + "\",\"username\":\"");
              backText.Append(username + "\"}");
             string user = element;
             string countItem = "SELECT count(distinct(groups.ID)) FROM groups2user,groups where groups2user.User_ID=@user and groups2user.Group_ID=groups.ID";
             sqlOperation.AddParameterWithValue("@user", Convert.ToInt32(user));
             int count = int.Parse(sqlOperation.ExecuteScalar(countItem));
             if (count > 0)
             {
                 backText.Append(",");
             }
             string sqlCommand = "SELECT distinct(groups.ID) as groupid,groups.groupName as groupname FROM groups2user,groups where groups2user.User_ID=@user and groups2user.Group_ID=groups.ID";
             MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlCommand);
             int i = 1;
            while (reader1.Read())
            {
                backText.Append("{\"groupid\":\"" + reader1["groupid"].ToString() + "\",\"groupname\":\"" + reader1["groupname"].ToString() + "\"}");
                if (i < count)
                {

                    backText.Append(",");
                }
                i++;
            }
            backText.Append("],");
            reader1.Close();
            
        }
        backText.Append("}}");
        backText.Remove(backText.ToString().LastIndexOf(','), 1);
        return backText.ToString();
    }

}