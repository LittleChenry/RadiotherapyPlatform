<%@ WebHandler Language="C#" Class="patientforprint" %>

using System;
using System.Web;
using System.Text;

public class patientforprint : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = patientfixInformation(context);
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string patientfixInformation(HttpContext context)
    {
        string treatid = context.Request["treat"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT count(*) from patient,treatment where treatment.Patient_ID=patient.ID and treatment.ID=@id";
        sqlOperation.AddParameterWithValue("@id", treatid);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"patient\":false}";
        }

        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"patient\":[");
        string sqlCommand2 = "select design.parameters as parameter,SplitWay_ID,treatment.TotalNumber as total,treatment.positioninfomation as pos,design.DosagePriority as DosagePriority,treataim.Aim as treatmentaim,treatment.Treatmentdescribe,Treatmentname,Progress,iscommon,patient.*,user.Name as doctor,diagnosisrecord.Part_ID as partID,diagnosisrecord.LightPart_ID as LightPart_ID,diagnosisrecord.DiagnosisResult_ID as diag from treatment,patient,user,diagnosisrecord,treataim,design where treatment.Design_ID=design.ID and treatment.DiagnosisRecord_ID=diagnosisrecord.ID  and patient.RegisterDoctor=user.ID and treatment.Patient_ID=patient.ID and treatment.ID=@id and diagnosisrecord.TreatAim_ID=treataim.ID";
        sqlOperation2.AddParameterWithValue("@id", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
        while (reader.Read())
        {
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] { '&' })[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            string sqlCommand3 = "select Chinese from icdcode where ID=@icdID";
            sqlOperation.AddParameterWithValue("@icdID", Convert.ToInt32(reader["diag"].ToString()));
            string result = sqlOperation.ExecuteScalar(sqlCommand3);
            string total = "";
            string splitway = "";
            string parameterx = "";
            string parametery = "";
            string parameterz = "";
            if (reader["total"].ToString() != "")
            {
                total = reader["total"].ToString();
            }
            else
            {
                total = "尚未制定";
                
            }
            if (reader["iscommon"].ToString() == "1")
            {
                parameterx = reader["parameter"].ToString().Split(new char[1] { ';' })[0];
                parametery = reader["parameter"].ToString().Split(new char[1] { ';' })[1];
                parameterz = reader["parameter"].ToString().Split(new char[1] { ';' })[2];
            }
            if (reader["SplitWay_ID"].ToString() != "")
            {
                string splitwaycommand = "select Ways from splitway where ID=@splitid";
                sqlOperation.AddParameterWithValue("@splitid", reader["SplitWay_ID"].ToString());
                splitway = sqlOperation.ExecuteScalar(splitwaycommand);
            }
            else
            {
                splitway = "尚未制定";

            }
            string firsttime = "";
            string firsttimecommand = "select TreatTime from treatmentrecord where Treatment_ID=@treat and TreatTime is not NULL order by TreatTime asc";
            sqlOperation.AddParameterWithValue("@treat",treatid);
            MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation.ExecuteReader(firsttimecommand);
            if (reader2.Read())
            {
                firsttime = reader2["TreatTime"].ToString();
                firsttime = firsttime.Split(new char[1] {' '})[0];
            }
            else
            {
                firsttime = "尚未开始治疗";
            }
            reader2.Close();
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Priority\":\"" + Priority + "\",\"IdentificationNumber\":\"" + reader["IdentificationNumber"] + "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() +
                 "\",\"Hospital\":\"" + reader["Hospital"].ToString() + "\",\"RecordNumber\":\"" + reader["RecordNumber"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Gender\":\"" + reader["Gender"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() + "\",\"RegisterDoctor\":\"" + reader["doctor"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() +
                 "\",\"Nation\":\"" + reader["Nation"].ToString() + "\",\"Address\":\"" + reader["Address"].ToString() + "\",\"Contact1\":\"" + reader["Contact1"].ToString() + "\",\"diagnosisresult\":\"" + result +
                 "\",\"Contact2\":\"" + reader["Contact2"].ToString() + "\",\"parameterz\":\"" + parameterz + "\",\"parameterx\":\"" + parameterx + "\",\"parametery\":\"" + parametery + "\",\"total\":\"" + total + "\",\"splitway\":\"" + splitway + "\",\"firsttime\":\"" + firsttime + "\",\"pos\":\"" + reader["pos"].ToString() + "\",\"treatmentaim\":\"" + reader["treatmentaim"].ToString() + "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"Hospital_ID\":\"" + reader["Hospital_ID"].ToString() + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"partID\":\"" + reader["partID"].ToString() + "\",\"LightPart_ID\":\"" + reader["LightPart_ID"].ToString() + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }

        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;

        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        return backText.ToString();
    }

}