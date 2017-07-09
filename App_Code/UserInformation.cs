using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// 维护用户对象
/// </summary>
public class UserInformation
{
    private int userID;//便于查询数据库
    private string userNumber;
    private string userName;
    private string userRole;
    private string assistant;
    private LinkedList<int> progress;

    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="id">用户id</param>
    /// <param name="number">用户账号</param>
    /// <param name="name">用户的名字</param>
	public UserInformation(int id, string number, string name)
	{
        userID = id;
        userName = name;
        userNumber = number;
	}

    /// <summary>
    /// 获取用户ID
    /// </summary>
    /// <returns></returns>
    public int GetUserID()
    {
        return userID;
    }

    /// <summary>
    /// 获取用户账号
    /// </summary>
    /// <returns></returns>
    public string GetUserNumber()
    {
        return userNumber;
    }

    /// <summary>
    /// 获取用户名字
    /// </summary>
    /// <returns></returns>
    public string GetUserName()
    {
        return userName;
    }

    public string GetUserRole()
    {
        return userRole;
    }

    public void setUserRole(string role)
    {
        userRole = role;
    }

    public void setAssistant(string assistant)
    {
        this.assistant = assistant;
    }

    public string getAssistant()
    {
        return this.assistant;
    }

    public void setProgress(LinkedList<int> progress)
    {
        this.progress = progress;
    }

    public LinkedList<int> getProgress()
    {
        return this.progress;
    }

    public static Dictionary<string,string> GetRoleName()
    {
        Dictionary<string, string> RoleName = new Dictionary<string, string>();
        string strSqlCommand = "SELECT * FROM ROLE";
        DataLayer sqlOperation = new DataLayer("sqlStr");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(strSqlCommand);
        while (reader.Read())
        {
            RoleName[reader["description"].ToString()] = reader["name"].ToString();
        }
        sqlOperation.Close();
        return RoleName;
    }
}