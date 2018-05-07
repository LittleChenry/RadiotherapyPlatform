<%@ WebHandler Language="C#" Class="getCompleteWarning" %>

using System;
using System.Web;
using System.Text;

public class getCompleteWarning : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getCompleteInfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getCompleteInfo(HttpContext context)
    {

        string treatlist = context.Request["patientidlist"];
        string[] treatarray=new string[]{};
        if (treatlist != "")
        {
            treatarray = treatlist.Split(new Char[] { ',' });
        }
      
        StringBuilder str = new StringBuilder("[");
        Boolean firstbool = false;
        for (int temp = 0; temp < treatarray.Length; temp++)
        {

            int treatid = int.Parse(treatarray[temp]);
            string patientname="";
            string treatmentname="";
            string radio = "";
            string treatmentcommand = "select patient.Radiotherapy_ID as radio,patient.Name as pname,treatment.Treatmentdescribe as treatname from patient,treatment where treatment.Patient_ID=patient.ID and treatment.ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(treatmentcommand);
            if (reader.Read())
            {
                patientname = reader["pname"].ToString();
                treatmentname = reader["treatname"].ToString();
                radio = reader["radio"].ToString();
            }
            reader.Close();
            Boolean treatbool=false;
            Boolean hasdesign = false;
            string checkchDesigncommand = "select childdesign.DesignName as designname,childdesign.Totalnumber as total,childdesign.ID as chid from treatment,childdesign where childdesign.Treatment_ID=treatment.ID and treatment.ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            reader = sqlOperation.ExecuteReader(checkchDesigncommand);
            while (reader.Read())
            {
                hasdesign = true;
                string checkrestcommand = "select count(*) from treatmentrecord where Treat_User_ID is not null and ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@chid",reader["chid"].ToString());
                int hasnumber = int.Parse(sqlOperation1.ExecuteScalar(checkrestcommand));
                if (reader["total"].ToString() != "")
                {
                    if (hasnumber < int.Parse(reader["total"].ToString()))
                    {
                        treatbool = true;
                    }
                }
                else
                {
                    treatbool = true;
                }
                string checkhascommand = "select count(*) from treatmentrecord,appointment_accelerate where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date>=@date and Treat_User_ID is null and ChildDesign_ID=@chid";
                sqlOperation1.AddParameterWithValue("@date", DateTime.Now.ToString("yyyy-MM-dd"));
                int restnumber = int.Parse(sqlOperation1.ExecuteScalar(checkhascommand));
                if (restnumber > 0 && restnumber <= 3)
                {
                    if (firstbool == false)
                    {
                        str.Append("{\"pname\":\"" + patientname + "\",\"treatname\":\"" + treatmentname + "\",\"radio\":\"" + radio + "\",\"childname\":\"" + reader["designname"].ToString() + "\",\"info\":\"" + "还剩" + restnumber + "次" + "\"}");
                        firstbool =true;
                    }
                    else
                    {
                        str.Append(",{\"pname\":\"" + patientname + "\",\"treatname\":\"" + treatmentname + "\",\"radio\":\"" + radio + "\",\"childname\":\"" + reader["designname"].ToString() + "\",\"info\":\"" + "还剩" + restnumber + "次" + "\"}");
                    }

                }

            }
            reader.Close();
            if (hasdesign == true)
            {
                if (treatbool == false)
                {
                    if (firstbool == false)
                    {
                        str.Append("{\"pname\":\"" + patientname + "\",\"treatname\":\"" + treatmentname + "\",\"radio\":\"" + radio + "\",\"childname\":\"" + "all" + "\",\"info\":\"" + "可以结束" + "\"}");
                        firstbool = true;
                    }
                    else
                    {
                        str.Append(",{\"pname\":\"" + patientname + "\",\"treatname\":\"" + treatmentname + "\",\"radio\":\"" + radio + "\",\"childname\":\"" + "all" + "\",\"info\":\"" + "可以结束" + "\"}");
                    }
                }
            }

        }
        str.Append("]");
        return str.ToString();

    }

}