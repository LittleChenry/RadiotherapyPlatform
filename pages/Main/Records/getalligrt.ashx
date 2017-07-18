<%@ WebHandler Language="C#" Class="getalligrt" %>

using System;
using System.Web;
using System.Text;

public class getalligrt : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getallrecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getallrecord(HttpContext context)
    {
        string treatid = context.Request.QueryString["treatmentID"];
        int treat = int.Parse(treatid);
        string sqlcommand1 = "select count(*) from igrt where TreatmentID=@treat";
        sqlOperation.AddParameterWithValue("treat", treatid);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlcommand1));
        string sqlcommand = "select Operate_User_ID,OperateTime,X_System,Y_System,Z_System,Assist from igrt where TreatmentID=@treat";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand);
        int temp = 0;
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        while (reader.Read())
        {
            string treatuser = "select Name from user where ID=@id";
            sqlOperation1.AddParameterWithValue("@id", Convert.ToInt32(reader["Operate_User_ID"].ToString()));
            string treatusername = sqlOperation1.ExecuteScalar(treatuser);

            backText.Append("{\"OperateTime\":\"" + reader["OperateTime"].ToString() + "\",\"X_System\":\"" + reader["X_System"].ToString() + "\",\"treatusername\":\"" + treatusername + "\",\"Y_System\":\"" + reader["Y_System"].ToString() + "\",\"Z_System\":\"" + reader["Z_System"].ToString() + "\",\"Assist\":\"" + reader["Assist"].ToString() + "\"}");
            if (temp < count - 1)
            {

                backText.Append(",");
            }
            temp++;

        }
        backText.Append("]}");
        return backText.ToString();
    }

}