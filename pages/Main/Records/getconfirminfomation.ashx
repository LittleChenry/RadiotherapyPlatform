<%@ WebHandler Language="C#" Class="getconfirminfomation" %>

using System;
using System.Web;
 using System.Text;

public class getconfirminfomation : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = treatrecord(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string treatrecord(HttpContext context)
    {

        int chid = Convert.ToInt32(context.Request.QueryString["chid"]);
        int appointid = Convert.ToInt32(context.Request.QueryString["appoint"]);
        string IlluminatedNumber = "";
        string MachineNumbe = "";
        int DosagePriority = 0;
        string totalnumbercommand = "select Singledose from fieldinfomation where ChildDesign_ID=@chid";
        sqlOperation.AddParameterWithValue("@chid",chid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(totalnumbercommand);
        if (reader.Read())
        {
            string temp=reader["Singledose"].ToString();
            if (temp != "")
            {
                DosagePriority = int.Parse(temp);
            }
                
        }
        reader.Close();
        string machinenumber = "select sum(mu) from fieldinfomation where ChildDesign_ID=@chid";
        MachineNumbe = sqlOperation.ExecuteScalar(machinenumber);
        string command = "select count(*) from fieldinfomation where ChildDesign_ID=@chid";
        IlluminatedNumber = sqlOperation.ExecuteScalar(command);  
        int addosage = 0;
        string addcommand = "select Singlenumber from treatmentrecord where ChildDesign_ID=@chid";
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(addcommand);
        while (reader1.Read())
        {
            string temp = reader1["Singlenumber"].ToString();
            if (temp != "")
            {
                addosage = addosage + int.Parse(temp);
                
            }
                
        }
        reader1.Close();

        string sqlcommand2 = "select count(*) from treatmentrecord where ChildDesign_ID=@chid and Treat_User_ID is not NULL";
        int finishedtimes = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        backText.Append("{\"finishedtimes\":\"" + finishedtimes.ToString() + "\",\"IlluminatedNumber\":\"" + IlluminatedNumber + "\",\"MachineNumbe\":\"" + MachineNumbe + "\",\"addosage\":\"" + addosage + "\",\"DosagePriority\":\"" + DosagePriority.ToString() + "\"}");
        backText.Append("]}");
        return backText.ToString(); 
        }
    }
