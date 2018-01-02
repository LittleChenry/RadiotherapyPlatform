<%@ WebHandler Language="C#" Class="GetGroupInformation" %>

using System;
using System.Web;
using System.Text;

public class GetGroupInformation : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = group();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string group()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string now = "";
        int count = 0;
        string zy = "";
        string zyid = "";
        bool flag = false;
        string sqlCommand = "SELECT `user`.`Name`,`user`.ID uid,groups.ID gid,groups.groupName,groups2user.identity FROM "
                            + "`user` RIGHT JOIN groups2user ON `user`.ID=groups2user.User_ID "
                            +"RIGHT JOIN groups ON groups2user.Group_ID=groups.ID WHERE groups2user.state=1 OR groups2user.identity=1 ORDER BY gid,identity";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder result = new StringBuilder("[");
        while(reader.Read()){
            bool havehigh = reader["identity"].ToString() == "1";
            bool iszz = reader["identity"].ToString() == "2";
            if (now != reader["gid"].ToString())
            {
                now = reader["gid"].ToString();
                count = 1;
                if (flag)
                {
                    result.Append("\",\"zyid\":\"").Append(zyid).Append("\",\"zy\":\"").Append(zy).Append("\"},");
                    zy = "";
                    zyid = "";
                }
                else
                    flag = true;
                result.Append("{\"gid\":\"").Append((reader["gid"].ToString()))
                      .Append("\",\"groupName\":\"")
                      .Append(reader["groupName"].ToString())
                      .Append("\",\"hid\":\"")
                      .Append(havehigh ? reader["uid"].ToString() : "")
                      .Append("\",\"high\":\"")
                      .Append(havehigh ? reader["Name"].ToString(): "");
                if (!havehigh)
                {
                    if (iszz)
                    {
                        result.Append("\",\"gzid\":\"")
                     .Append(reader["uid"].ToString())
                     .Append("\",\"gz\":\"")
                     .Append(reader["Name"].ToString());
                        count++;
                    }
                    else
                    {
                        count = 2;
                        zyid += reader["uid"].ToString() + " ";
                        zy += reader["Name"].ToString() + ", ";
                    }
                }
            }
            else if (count == 1)
            {
                if (iszz)
                {
                    result.Append("\",\"gzid\":\"")
                          .Append(reader["uid"].ToString())
                          .Append("\",\"gz\":\"")
                          .Append(reader["Name"].ToString());
                    count++;
                }
                else
                {
                    result.Append("\",\"gzid\":\"")
                          .Append("")
                          .Append("\",\"gz\":\"")
                          .Append("");
                    count = 2;
                    zyid += reader["uid"].ToString() + " ";
                    zy += reader["Name"].ToString() + ", ";
                }
            }
            else
            {
                zyid += reader["uid"].ToString() + " ";
                zy += reader["Name"].ToString() + ", ";
            }
           
        }

        result.Append("\",\"zyid\":\"").Append(zyid).Append("\",\"zy\":\"").Append(zy).Append("\"}]");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return result.ToString();
    }
}