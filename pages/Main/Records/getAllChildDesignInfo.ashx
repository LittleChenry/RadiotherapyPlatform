<%@ WebHandler Language="C#" Class="getAllChildDesignInfo" %>

using System;
using System.Web;
using System.Text;


public class getAllChildDesignInfo : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getallchilddesign(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getallchilddesign(HttpContext context)
    {
        string patientid = context.Request["patientid"];
        int temp = 1;
        string countcommand = "select count(*) from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and (childdesign.State>=2  or childdesign.State=0)";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        int number = int.Parse(sqlOperation.ExecuteScalar(countcommand));
        StringBuilder info = new StringBuilder("{\"patientinfo\":[");
        string designcommand = "select childdesign.Changelog as changelog,childdesign.SpecialEnjoin as specialenjoin,treatment.State as treatsate,childdesign.ID as chid,DesignName,childdesign.Splitway_ID as splitway,childdesign.Totalnumber as total,childdesign.fillNumber as fillnum,childdesign.state as childstate,Treatmentdescribe,childdesign.Treatment_ID as treatid,childdesign.IlluminatedNumber as illumnumber,childdesign.Coplanar as coplanar,childdesign.MachineNumbe as mu,childdesign.ControlPoint as control from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.Patient_ID=@pid and (childdesign.State>=2  or childdesign.State=0) order by treatid asc,chid asc";
        sqlOperation.AddParameterWithValue("@pid", patientid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(designcommand);
        while (reader.Read())
        {
            string splitname = "select Ways from splitway where ID=@split";
            sqlOperation1.AddParameterWithValue("@split", reader["splitway"].ToString());
            string split = sqlOperation1.ExecuteScalar(splitname);
                
            int count = 0;
            int appointid = 0;
            string maxdate = "无";
            string date = "";
            string begin = "";
            string sqlcommand2 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and Date>=@nowdate order by Date desc,Begin desc";
            sqlOperation1.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
            sqlOperation1.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
            MySql.Data.MySqlClient.MySqlDataReader  reader1 = sqlOperation1.ExecuteReader(sqlcommand2);
            while (reader1.Read())
            {
                if (reader1["Treat_User_ID"].ToString() == "")
                {
                    //appointid = int.Parse(reader1["Appointment_ID"].ToString());
                    if (maxdate == "无")
                    {
                        maxdate = reader1["Date"].ToString();
                    }

                }
                count++;
            }
            reader1.Close();
            string sqlcommand = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and Date<@nowdate order by Date desc,Begin desc";
            reader1 = sqlOperation1.ExecuteReader(sqlcommand);
            while (reader1.Read())
            {
                if (reader1["Treat_User_ID"].ToString() != "")
                {
                    appointid = int.Parse(reader1["Appointment_ID"].ToString());
                    date = reader1["Date"].ToString();
                    begin = reader1["Begin"].ToString();
                    break;
                }
            }
            reader1.Close();
            if (appointid != 0)
            {
                string sqlcommand1 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.ChildDesign_ID=@chid and treatmentrecord.Appointment_ID=appointment_accelerate.ID and (Date<@date or (Date=@date and Begin<=@begin)) order by Date,Begin asc";
                sqlOperation1.AddParameterWithValue("@date", date);
                sqlOperation1.AddParameterWithValue("@begin", begin);
                reader1 = sqlOperation1.ExecuteReader(sqlcommand1);
                while (reader1.Read())
                {
                    if (reader1["Treat_User_ID"].ToString() != "")
                    {
                        count++;
                    }

                }
                reader1.Close();
            }
            int rest = 0;
            if (reader["total"].ToString() != "")
            {
                rest = int.Parse(reader["total"].ToString()) - count;
            }
            info.Append("{\"chid\":\"" + reader["chid"].ToString() + "\",\"DesignName\":\"" + reader["DesignName"].ToString() + "\",\"rest\":\"" + rest + "\",\"splitname\":\"" + split + "\",\"Totalnumber\":\"" + reader["total"].ToString() + "\",\"treatstate\":\"" + reader["treatsate"].ToString() + "\",\"fillnum\":\"" + reader["fillnum"].ToString() + "\",\"childstate\":\"" + reader["childstate"].ToString() + "\",\"splitway\":\"" + reader["splitway"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"treatid\":\"" + reader["treatid"].ToString() + "\",\"changelog\":\"" + reader["changelog"].ToString() + "\",\"specialenjoin\":\"" + reader["specialenjoin"].ToString() + "\",\"illumnumber\":\"" + reader["illumnumber"].ToString() + "\",\"coplanar\":\"" + reader["coplanar"].ToString() + "\",\"mu\":\"" + reader["mu"].ToString() + "\",\"control\":\"" + reader["control"].ToString() + "\"");
            string amount = "select count(*) from treatmentrecord where ChildDesign_ID=@chid and Treat_User_ID is not null";
            sqlOperation1.AddParameterWithValue("@chid", reader["chid"].ToString());
            count = int.Parse(sqlOperation1.ExecuteScalar(amount));
            info.Append(",\"treattimes\":\"" + count + "\",\"fieldinfo\":[");
            string fieldcountcommand = "select count(*) from fieldinfomation where ChildDesign_ID=@ChildDesign_ID";
            sqlOperation1.AddParameterWithValue("@ChildDesign_ID", reader["chid"].ToString());
            int fieldcount = int.Parse(sqlOperation1.ExecuteScalar(fieldcountcommand));
            string sqlCommand = "SELECT fieldinfomation.ChildDesign_ID,code,mu,equipment,radiotechnique,radiotype,fieldinfomation.energy as energy1,wavedistance,angleframe,noseangle,bedrotation,subfieldnumber,Singledose,Totaldose,guangxianLeft,guangxianRight from fieldinfomation where ChildDesign_ID=@ChildDesign_ID ";
            reader1 = sqlOperation1.ExecuteReader(sqlCommand);
            int tempco=1;
            while (reader1.Read())
            {
                info.Append("{\"code\":\"" + reader1["code"].ToString() + "\",\"mu\":\"" + reader1["mu"].ToString() + "\",\"equipment\":\"" + reader1["equipment"].ToString() + "\",");
                info.Append("\"radiotechnique\":\"" + reader1["radiotechnique"].ToString() + "\",\"radiotype\":\"" + reader1["radiotype"].ToString() + "\",\"energy\":\"" + reader1["energy1"].ToString() + "\",\"wavedistance\":\"" + reader1["wavedistance"].ToString() + "\",");
                info.Append("\"angleframe\":\"" + reader1["angleframe"].ToString() + "\",\"noseangle\":\"" + reader1["noseangle"].ToString() + "\",\"guangxianLeft\":\"" + reader1["guangxianLeft"].ToString() + "\",\"guangxianRight\":\"" + reader1["guangxianRight"].ToString() + "\",\"bedrotation\":\"" + reader1["bedrotation"].ToString() + "\",\"subfieldnumber\":\"" + reader1["subfieldnumber"].ToString() + "\",");
                info.Append("\"Singledose\":\"" + reader1["Singledose"].ToString() + "\",\"Totaldose\":\"" + reader1["Totaldose"].ToString() + "\"}");
                if (tempco < fieldcount)
                {
                    info.Append(",");
                }
                tempco++;  
            }
            reader1.Close();
            info.Append("]}");            
            if (temp <= number - 1)
            {
                info.Append(",");
            
            }
            temp++;
              
        }
        reader.Close();
        info.Append("]}");
        return info.ToString();
    }

}