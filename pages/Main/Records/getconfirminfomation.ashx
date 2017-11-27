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

        int treatid = Convert.ToInt32(context.Request.QueryString["treatID"]);
        int appointid = Convert.ToInt32(context.Request.QueryString["appoint"]);
        string IlluminatedNumber = "";
        string MachineNumbe = "";
        int DosagePriority = 0;
        string design = "select iscommon from treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        string des = sqlOperation.ExecuteScalar(design);
        if (des == "1")
        {
            string sqlcommand1 = "select IlluminatedNumber,MachineNumbe,DosagePriority from design,treatment where design.ID=treatment.Design_ID and treatment.ID=@treat";
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand1);

            if (reader.Read())
            {
                string Do = reader["DosagePriority"].ToString();
                string Priority = Do.Split(new char[1] { '&' })[0];
                string[] dosage = Priority.Split(new char[1] { ';' });
                int k = 0;
                int finaldos = 0;
                for (k = 0; k <= dosage.Length - 2; k++)
                {
                    if (Convert.ToInt32(dosage[k].Split(new char[1] { ',' })[3]) >= finaldos)
                    {
                        finaldos = Convert.ToInt32(dosage[k].Split(new char[1] { ',' })[3]);
                    }
                }
                IlluminatedNumber = reader["IlluminatedNumber"].ToString();
                MachineNumbe = reader["MachineNumbe"].ToString();
                DosagePriority = finaldos;
            }
            reader.Close();

        }
        else
        {
            string totalnumbercommand = "select Singledose from fieldinfomation where treatmentid=@treat";
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
          string machinenumber = "select sum(mu) from fieldinfomation where treatmentid=@treat";
          MachineNumbe = sqlOperation.ExecuteScalar(machinenumber); 
          string command = "select count(*) from fieldinfomation where treatmentid=@treat";
          IlluminatedNumber = sqlOperation.ExecuteScalar(command);  
        }
        int addosage = 0;
        string addcommand = "select Singlenumber from treatmentrecord where Treatment_ID=@treat";
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

        string sqlcommand2 = "select count(*) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL";
        int finishedtimes = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        backText.Append("{\"finishedtimes\":\"" + finishedtimes.ToString() + "\",\"IlluminatedNumber\":\"" + IlluminatedNumber + "\",\"MachineNumbe\":\"" + MachineNumbe + "\",\"addosage\":\"" + addosage + "\",\"DosagePriority\":\"" + DosagePriority.ToString() + "\"}");
        backText.Append("]}");
        return backText.ToString(); 
        }
    }
