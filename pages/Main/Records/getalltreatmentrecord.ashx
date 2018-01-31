<%@ WebHandler Language="C#" Class="getalltreatmentrecord" %>

using System;
using System.Web;
using System.Text;

public class getalltreatmentrecord : IHttpHandler {

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
        string chid = context.Request.QueryString["chid"];
        int treat = int.Parse(chid);
        string sqlcommand1 = "select count(*) from treatmentrecord where ChildDesign_ID=@chid and Treat_User_ID is not NULL";
        sqlOperation.AddParameterWithValue("@chid", chid);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlcommand1));
        string sqlcommand = "select ID,TreatTime,TreatedDays,TreatedTimes,Treat_User_ID,Check_User_ID,IlluminatedNumber,MachineNumber,Assist_User,Singlenumber,Remarks from treatmentrecord where ChildDesign_ID=@chid and Treat_User_ID is not NULL order by treatmentrecord.TreatTime asc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand);
        int temp = 0;
       StringBuilder backText = new StringBuilder("{\"Item\":[");
        while(reader.Read())
        {
            string treatuser = "select Name from user where ID=@id";
            sqlOperation1.AddParameterWithValue("@id", Convert.ToInt32(reader["Treat_User_ID"].ToString()));
            string treatusername = sqlOperation1.ExecuteScalar(treatuser);
            string checkusername = "";
            if (reader["Check_User_ID"].ToString() != "")
            {
                string checkuser = "select Name from user where ID=@id";
                sqlOperation1.AddParameterWithValue("@id", Convert.ToInt32(reader["Check_User_ID"].ToString()));
                checkusername = sqlOperation1.ExecuteScalar(checkuser);

            }
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"TreatTime\":\"" + reader["TreatTime"].ToString() + "\",\"treatusername\":\"" + treatusername + "\",\"checkusername\":\"" + checkusername + "\",\"TreatedDays\":\"" + reader["TreatedDays"].ToString() + "\",\"TreatedTimes\":\"" + reader["TreatedTimes"].ToString() + "\",\"IlluminatedNumber\":\"" + reader["IlluminatedNumber"].ToString() + "\",\"MachineNumber\":\"" + reader["MachineNumber"].ToString() + "\",\"Assist_User\":\"" + reader["Assist_User"].ToString() + "\",\"Singlenumber\":\"" + reader["Singlenumber"].ToString() + "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\"}");
            if (temp < count-1)
            {

                backText.Append(",");
            }
            temp++;

        }
        backText.Append("]}");
        return backText.ToString();
    }


}