<%@ WebHandler Language="C#" Class="patientInfoForDoctor" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class patientInfoForDoctor : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
            context.Response.ContentType = "text/plain";
            string json = getfixrecordinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            context.Response.Write(json);
       
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getfixrecordinfo(HttpContext context)
    {       
        String userid = context.Request.QueryString["userID"];
        int userID = Convert.ToInt32(userid);
        string type = context.Request["type"];

        if (type == "1")
        {

            string sqlCommand1 = "SELECT Group_ID from groups2user where User_ID=@userid and identity<>0";
            sqlOperation.AddParameterWithValue("@userid", userID);
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlCommand1);
            ArrayList array = new ArrayList();
            ArrayList array2 = new ArrayList();
            while (reader1.Read())
            {
                array.Add(reader1["Group_ID"].ToString());
            }
            reader1.Close();
            foreach (string element in array)
            {
                string sqlcommand2 = "select ID from groups2user where identity<>0 and Group_ID=@groupid";
                sqlOperation1.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(sqlcommand2);
                while (reader2.Read())
                {
                    array2.Add(reader2["ID"].ToString());
                }
                reader2.Close();
            }

            int Count = 0;
            int count = 0;
            foreach (string element in array2)
            {
                string sqlCommand = "SELECT count(*) from treatment where Group_ID=@groupid and treatment.State<>2 and treatment.Progress like '%12%'";
                sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
                Count = Count + count;
            }
            string sql = "select count(*) from treatment where Group_ID is NULL and Belongingdoctor=@userid and treatment.State<>2 and treatment.Progress like '%12%'";
            sqlOperation2.AddParameterWithValue("@userid", Convert.ToInt32(userID));
            int count2 = int.Parse(sqlOperation2.ExecuteScalar(sql));
            int i = 1;
            StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
            foreach (string element in array2)
            {
                string sqlCommand11 = "select groups.groupName as groupname from groups,groups2user where groups.ID=groups2user.Group_ID and groups2user.ID=@groupid";
                sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                string groupname = sqlOperation.ExecuteScalar(sqlCommand11);
                string sqlCommand2 = "select treatment.State as treatstate,treatment.Group_ID as groupID,treatment.ID as treatid,patient.*,State,Progress,iscommon,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where treatment.State<>2 and treatment.Progress like '%12%' and patient.ID=treatment.Patient_ID and treatment.Belongingdoctor=user.ID and treatment.Group_ID=@groupid  order by patient.ID desc";
                sqlOperation2.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
                while (reader.Read())
                {
                    Boolean hastreat = false;
                    string alldesigncommand = "select ID from childdesign where Treatment_ID=@treat";
                    sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                    reader1 = sqlOperation1.ExecuteReader(alldesigncommand);
                    while (reader1.Read())
                    {
                        string haschildcommand = "SELECT count(*) from treatmentrecord where ChildDesign_ID=@chid and Treat_User_ID is not null";
                        sqlOperation.AddParameterWithValue("@chid", reader1["ID"].ToString());
                        int numbertemp = int.Parse(sqlOperation.ExecuteScalar(haschildcommand));
                        if (numbertemp == 0)
                        {
                            hastreat = true;
                            break;
                        }
                    }
                    reader1.Close();
                    string hasfirst;
                    if (hastreat == true)
                    {
                        hasfirst = "1";
                    }
                    else
                    {
                        hasfirst = "0";
                    }
                    string progress = reader["Progress"].ToString();
                    string[] strArray = progress.Split(',');
                    string LoadCTTime = "";
                    string designSubmitTime = "";
                    string result = "";
                    if (reader["DiagnosisRecord_ID"] is DBNull)
                    {
                        result = "";
                    }
                    else
                    {
                        string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                        sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                        result = sqlOperation1.ExecuteScalar(sqlCommand3);

                    }
                    if (Array.LastIndexOf(strArray, "6") > 0 && Array.LastIndexOf(strArray, "7") < 0)
                    {
                        string sqlCommand6 = "select ct.OperateTime  from location,treatment,ct where location.ID=treatment.Location_ID and treatment.ID =@treatID and location.CT_ID=ct.ID";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        LoadCTTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                       
                    }
                    if (Array.LastIndexOf(strArray, "9") > 0 && Array.LastIndexOf(strArray, "10") < 0)
                    {
                        string sqlCommand6 = "select design.SubmitTime  from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID ";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        designSubmitTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                       
                    }
                    backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"state\":\"" + reader["treatstate"].ToString() +
                         "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + groupname
                         + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"LoadCTTime\":\"" + LoadCTTime + "\",\"designSubmitTime\":\"" + designSubmitTime + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\",\"hasfirst\":\"" + hasfirst + "\"}");
                    if (i < Count)
                    {
                        backText.Append(",");
                    }
                    i++;
                }
                reader.Close();
            }
            if (count2 != 0 && Count != 0)
            {
                backText.Append(",");
            }
            string command3 = "select treatment.State as treatstate,treatment.ID as treatid,patient.*,State,Progress,iscommon,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and treatment.State<>2 and treatment.Progress like '%12%' and treatment.Belongingdoctor=user.ID and treatment.Group_ID is NULL and treatment.Belongingdoctor=@userid  order by patient.ID desc";
            MySql.Data.MySqlClient.MySqlDataReader reader3 = sqlOperation2.ExecuteReader(command3);
            int temp = 0;
            while (reader3.Read())
            {
                Boolean hastreat = false;
                string alldesigncommand = "select ID from childdesign where Treatment_ID=@treat";
                sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                reader1 = sqlOperation1.ExecuteReader(alldesigncommand);
                while (reader1.Read())
                {
                    string haschildcommand = "SELECT count(*) from treatmentrecord where ChildDesign_ID=@chid and Treat_User_ID is not null";
                    sqlOperation.AddParameterWithValue("@chid", reader1["ID"].ToString());
                    int numbertemp = int.Parse(sqlOperation.ExecuteScalar(haschildcommand));
                    if (numbertemp == 0)
                    {
                        hastreat = true;
                        break;
                    }
                }
                reader1.Close();
                string hasfirst;
                if (hastreat == true)
                {
                    hasfirst = "1";
                }
                else
                {
                    hasfirst = "0";
                }
                string progress = reader3["Progress"].ToString();
                string[] strArray = progress.Split(',');
                string LoadCTTime = "";
                string designSubmitTime = "";
                string result = "";
                if (reader3["DiagnosisRecord_ID"] is DBNull)
                {
                    result = "";
                }
                else
                {
                    string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                    sqlOperation1.AddParameterWithValue("@ID", reader3["DiagnosisRecord_ID"].ToString());
                    result = sqlOperation1.ExecuteScalar(sqlCommand3);
                }
                if (Array.LastIndexOf(strArray, "6") > 0 && Array.LastIndexOf(strArray, "7") < 0)
                {
                    string sqlCommand6 = "select ct.OperateTime  from location,treatment,ct where location.ID=treatment.Location_ID and treatment.ID =@treatID and location.CT_ID=ct.ID";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    LoadCTTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                   
                }
                if (Array.LastIndexOf(strArray, "9") > 0 && Array.LastIndexOf(strArray, "10") < 0)
                {
                    string sqlCommand6 = "select design.SubmitTime  from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID ";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    designSubmitTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                   
                }
                backText.Append("{\"Name\":\"" + reader3["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"state\":\"" + reader3["treatstate"].ToString() +
                     "\",\"Radiotherapy_ID\":\"" + reader3["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader3["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + ""
                     + "\",\"Progress\":\"" + reader3["Progress"].ToString() + "\",\"doctor\":\"" + reader3["doctor"].ToString() + "\",\"treatID\":\"" + reader3["treatid"].ToString() + "\",\"LoadCTTime\":\"" + LoadCTTime + "\",\"designSubmitTime\":\"" + designSubmitTime + "\",\"iscommon\":\"" + reader3["iscommon"].ToString() + "\",\"hasfirst\":\"" + hasfirst + "\"}");

                if (temp < count2 - 1)
                {
                    backText.Append(",");
                }
                temp++;
            }

            backText.Append("]}");
            return backText.ToString();
        }
        else if (type == "2")
        {

            string sqlCommand1 = "SELECT Group_ID from groups2user where User_ID=@userid and identity<>0";
            sqlOperation.AddParameterWithValue("@userid", userID);
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlCommand1);
            ArrayList array = new ArrayList();
            ArrayList array2 = new ArrayList();
            while (reader1.Read())
            {
                array.Add(reader1["Group_ID"].ToString());
            }
            reader1.Close();
            foreach (string element in array)
            {
                string sqlcommand2 = "select ID from groups2user where identity<>0 and Group_ID=@groupid";
                sqlOperation1.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(sqlcommand2);
                while (reader2.Read())
                {
                    array2.Add(reader2["ID"].ToString());
                }
                reader2.Close();
            }

            int Count = 0;
            int count = 0;
            foreach (string element in array2)
            {
                string sqlCommand = "SELECT count(*) from treatment where Group_ID=@groupid and treatment.State=2";
                sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
                Count = Count + count;
            }
            string sql = "select count(*) from treatment where Group_ID is NULL and Belongingdoctor=@userid and treatment.State=2";
            sqlOperation2.AddParameterWithValue("@userid", Convert.ToInt32(userID));
            int count2 = int.Parse(sqlOperation2.ExecuteScalar(sql));
            int i = 1;
            StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
            foreach (string element in array2)
            {
                string sqlCommand11 = "select groups.groupName as groupname from groups,groups2user where groups.ID=groups2user.Group_ID and groups2user.ID=@groupid";
                sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                string groupname = sqlOperation.ExecuteScalar(sqlCommand11);
                string sqlCommand2 = "select treatment.State as treatstate,treatment.Group_ID as groupID,treatment.ID as treatid,patient.*,State,Progress,iscommon,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where treatment.State=2 and patient.ID=treatment.Patient_ID and treatment.Belongingdoctor=user.ID and treatment.Group_ID=@groupid  order by patient.ID desc";
                sqlOperation2.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
                while (reader.Read())
                {

                   
                    string progress = reader["Progress"].ToString();
                    string[] strArray = progress.Split(',');
                    string LoadCTTime = "";
                    string designSubmitTime = "";
                    string result = "";
                    
                    if (reader["DiagnosisRecord_ID"] is DBNull)
                    {
                        result = "";
                    }
                    else
                    {
                        string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                        sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                        result = sqlOperation1.ExecuteScalar(sqlCommand3);

                    }
                    if (Array.LastIndexOf(strArray, "6") > 0 && Array.LastIndexOf(strArray, "7") < 0)
                    {
                        string sqlCommand6 = "select ct.OperateTime  from location,treatment,ct where location.ID=treatment.Location_ID and treatment.ID =@treatID and location.CT_ID=ct.ID";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        LoadCTTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                    }
                    if (Array.LastIndexOf(strArray, "9") > 0 && Array.LastIndexOf(strArray, "10") < 0)
                    {
                        string sqlCommand6 = "select design.SubmitTime  from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID ";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        designSubmitTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                    }
                    backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"state\":\"" + reader["treatstate"].ToString() +
                         "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + groupname
                         + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"LoadCTTime\":\"" + LoadCTTime + "\",\"designSubmitTime\":\"" + designSubmitTime + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\",\"hasfirst\":\"" + "" + "\"}");

                    if (i < Count)
                    {
                        backText.Append(",");
                    }
                    i++;
                }
                reader.Close();
            }
            if (count2 != 0 && Count != 0)
            {
                backText.Append(",");
            }
            string command3 = "select treatment.State as treatstate,treatment.ID as treatid,patient.*,State,Progress,iscommon,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and treatment.State=2 and treatment.Belongingdoctor=user.ID and treatment.Group_ID is NULL and treatment.Belongingdoctor=@userid  order by patient.ID desc";
            MySql.Data.MySqlClient.MySqlDataReader reader3 = sqlOperation2.ExecuteReader(command3);
            int temp = 0;
            while (reader3.Read())
            {
                
                string progress = reader3["Progress"].ToString();
                string[] strArray = progress.Split(',');
                string LoadCTTime = "";
                string designSubmitTime = "";
                string result = "";
                if (reader3["DiagnosisRecord_ID"] is DBNull)
                {
                    result = "";
                }
                else
                {
                    string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                    sqlOperation1.AddParameterWithValue("@ID", reader3["DiagnosisRecord_ID"].ToString());
                    result = sqlOperation1.ExecuteScalar(sqlCommand3);
                }
                if (Array.LastIndexOf(strArray, "6") > 0 && Array.LastIndexOf(strArray, "7") < 0)
                {
                    string sqlCommand6 = "select ct.OperateTime  from location,treatment,ct where location.ID=treatment.Location_ID and treatment.ID =@treatID and location.CT_ID=ct.ID";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    LoadCTTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                    
                }
                if (Array.LastIndexOf(strArray, "9") > 0 && Array.LastIndexOf(strArray, "10") < 0)
                {
                    string sqlCommand6 = "select design.SubmitTime  from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID ";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    designSubmitTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                }
                backText.Append("{\"Name\":\"" + reader3["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"state\":\"" + reader3["treatstate"].ToString() +
                     "\",\"Radiotherapy_ID\":\"" + reader3["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader3["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + ""
                     + "\",\"Progress\":\"" + reader3["Progress"].ToString() + "\",\"doctor\":\"" + reader3["doctor"].ToString() + "\",\"treatID\":\"" + reader3["treatid"].ToString() + "\",\"LoadCTTime\":\"" + LoadCTTime + "\",\"designSubmitTime\":\"" + designSubmitTime + "\",\"iscommon\":\"" + reader3["iscommon"].ToString() + "\",\"hasfirst\":\"" + "" + "\"}");

                if (temp < count2 - 1)
                {
                    backText.Append(",");
                }
                temp++;
            }

            backText.Append("]}");
            return backText.ToString();

        }
        else
        {

            string sqlCommand1 = "SELECT Group_ID from groups2user where User_ID=@userid and identity<>0";
            sqlOperation.AddParameterWithValue("@userid", userID);
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlCommand1);
            ArrayList array = new ArrayList();
            ArrayList array2 = new ArrayList();
            while (reader1.Read())
            {
                array.Add(reader1["Group_ID"].ToString());
            }
            reader1.Close();
            foreach (string element in array)
            {
                string sqlcommand2 = "select ID from groups2user where identity<>0 and Group_ID=@groupid";
                sqlOperation1.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                MySql.Data.MySqlClient.MySqlDataReader reader2 = sqlOperation1.ExecuteReader(sqlcommand2);
                while (reader2.Read())
                {
                    array2.Add(reader2["ID"].ToString());
                }
                reader2.Close();
            }

            int Count = 0;
            int count = 0;
            foreach (string element in array2)
            {
                string sqlCommand = "SELECT count(*) from treatment where Group_ID=@groupid and treatment.State<>2 and treatment.Progress not like '%12%'";
                sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
                Count = Count + count;
            }
            string sql = "select count(*) from treatment where Group_ID is NULL and Belongingdoctor=@userid and  treatment.State<>2 and treatment.Progress not like '%12%'";
            sqlOperation2.AddParameterWithValue("@userid", Convert.ToInt32(userID));
            int count2 = int.Parse(sqlOperation2.ExecuteScalar(sql));
            int i = 1;
            StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
            foreach (string element in array2)
            {
                string sqlCommand11 = "select groups.groupName as groupname from groups,groups2user where groups.ID=groups2user.Group_ID and groups2user.ID=@groupid";
                sqlOperation.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                string groupname = sqlOperation.ExecuteScalar(sqlCommand11);
                string sqlCommand2 = "select treatment.State as treatstate,treatment.Group_ID as groupID,treatment.ID as treatid,patient.*,State,Progress,iscommon,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where treatment.State<>2 and treatment.Progress not like '%12%' and patient.ID=treatment.Patient_ID and treatment.Belongingdoctor=user.ID and treatment.Group_ID=@groupid  order by patient.ID desc";
                sqlOperation2.AddParameterWithValue("@groupid", Convert.ToInt32(element));
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
                while (reader.Read())
                {
                    string progress = reader["Progress"].ToString();
                    string[] strArray = progress.Split(',');
                    string LoadCTTime = "";
                    string designSubmitTime = "";
                    string result = "";
                    if (reader["DiagnosisRecord_ID"] is DBNull)
                    {
                        result = "";
                    }
                    else
                    {
                        string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                        sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                        result = sqlOperation1.ExecuteScalar(sqlCommand3);

                    }
                    if (Array.LastIndexOf(strArray, "6") > 0 && Array.LastIndexOf(strArray, "7") < 0)
                    {
                        string sqlCommand6 = "select ct.OperateTime  from location,treatment,ct where location.ID=treatment.Location_ID and treatment.ID =@treatID and location.CT_ID=ct.ID";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        LoadCTTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                        double differ = computeDay(Convert.ToDateTime(LoadCTTime), DateTime.Now);
                        string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
                        sqlOperation1.AddParameterWithValue("@enddate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));
                        sqlOperation1.AddParameterWithValue("@begindate", Convert.ToDateTime(LoadCTTime).ToString("yyyy-MM-dd"));
                        int result2 = int.Parse(sqlOperation1.ExecuteScalar(command));
                        string comm = "select warningcase.* from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@progress", 6);
                        reader1 = sqlOperation1.ExecuteReader(comm);
                        double stoplength = 0;
                        while (reader1.Read())
                        {
                            if (reader1["StopTime"].ToString() != "")
                            {
                                stoplength = stoplength + computeDay(Convert.ToDateTime(reader1["StopTime"]), Convert.ToDateTime(reader1["RestartTime"]));

                            }

                        }
                        reader1.Close();
                        double finaltime = differ - stoplength - result2 * 24;
                        string timetask = "SELECT WarningLightTime,WarningSeriousTime FROM warning where Progress=6";
                        reader1 = sqlOperation1.ExecuteReader(timetask);
                        double light = 0;
                        double serious = 0;
                        if (reader1.Read())
                        {
                            light = double.Parse(reader1["WarningLightTime"].ToString());
                            serious = double.Parse(reader1["WarningSeriousTime"].ToString());

                        }
                        reader1.Close();

                        if (finaltime > light)
                        {
                            if (finaltime < serious)
                            {
                                string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                                sqlOperation1.ExecuteNonQuery(recordcommand);

                                string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                                sqlOperation1.AddParameterWithValue("@type", "黄色预警");
                                sqlOperation1.AddParameterWithValue("@time", finaltime);
                                sqlOperation1.ExecuteNonQuery(recordcommand2);
                            }
                            else
                            {
                                string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                                sqlOperation1.ExecuteNonQuery(recordcommand);

                                string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                                sqlOperation1.AddParameterWithValue("@type", "红色预警");
                                sqlOperation1.AddParameterWithValue("@time", finaltime);
                                sqlOperation1.ExecuteNonQuery(recordcommand2);

                            }

                        }
                        
                    }
                    if (Array.LastIndexOf(strArray, "9") > 0 && Array.LastIndexOf(strArray, "10") < 0)
                    {
                        string sqlCommand6 = "select design.SubmitTime  from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID ";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        designSubmitTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                        double differ = computeDay(Convert.ToDateTime(designSubmitTime), DateTime.Now);
                        string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
                        sqlOperation1.AddParameterWithValue("@enddate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));
                        sqlOperation1.AddParameterWithValue("@begindate", Convert.ToDateTime(designSubmitTime).ToString("yyyy-MM-dd"));
                        int result2 = int.Parse(sqlOperation1.ExecuteScalar(command));
                        string comm = "select warningcase.* from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
                        sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@progress", 9);
                        reader1 = sqlOperation1.ExecuteReader(comm);
                        double stoplength = 0;
                        while (reader1.Read())
                        {
                            if (reader1["StopTime"].ToString() != "")
                            {
                                stoplength = stoplength + computeDay(Convert.ToDateTime(reader1["StopTime"]), Convert.ToDateTime(reader1["RestartTime"]));

                            }

                        }
                        reader1.Close();
                        double finaltime = differ - stoplength - result2 * 24;
                        string timetask = "SELECT WarningLightTime,WarningSeriousTime FROM warning where Progress=9";
                        reader1 = sqlOperation1.ExecuteReader(timetask);
                        double light = 0;
                        double serious = 0;
                        if (reader1.Read())
                        {
                            light = double.Parse(reader1["WarningLightTime"].ToString());
                            serious = double.Parse(reader1["WarningSeriousTime"].ToString());

                        }
                        reader1.Close();

                        if (finaltime > light)
                        {
                            if (finaltime < serious)
                            {
                                string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                                sqlOperation1.ExecuteNonQuery(recordcommand);

                                string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                                sqlOperation1.AddParameterWithValue("@type", "黄色预警");
                                sqlOperation1.AddParameterWithValue("@time", finaltime);
                                sqlOperation1.ExecuteNonQuery(recordcommand2);
                            }
                            else
                            {
                                string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                                sqlOperation1.ExecuteNonQuery(recordcommand);

                                string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                                sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                                sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                                sqlOperation1.AddParameterWithValue("@type", "红色预警");
                                sqlOperation1.AddParameterWithValue("@time", finaltime);
                                sqlOperation1.ExecuteNonQuery(recordcommand2);

                            }

                        }
                    }
                    backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"state\":\"" + reader["treatstate"].ToString() +
                         "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + groupname
                         + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"LoadCTTime\":\"" + LoadCTTime + "\",\"designSubmitTime\":\"" + designSubmitTime + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\",\"hasfirst\":\"" + "" + "\"}");

                    if (i < Count)
                    {
                        backText.Append(",");
                    }
                    i++;
                }
                reader.Close();
            }
            if (count2 != 0 && Count != 0)
            {
                backText.Append(",");
            }
            string command3 = "select treatment.State as treatstate,treatment.ID as treatid,patient.*,State,Progress,iscommon,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and treatment.State<>2 and treatment.Progress not like '%12%' and treatment.Belongingdoctor=user.ID and treatment.Group_ID is NULL and treatment.Belongingdoctor=@userid  order by patient.ID desc";
            MySql.Data.MySqlClient.MySqlDataReader reader3 = sqlOperation2.ExecuteReader(command3);
            int temp = 0;
            while (reader3.Read())
            {
                string progress = reader3["Progress"].ToString();
                string[] strArray = progress.Split(',');
                string LoadCTTime = "";
                string designSubmitTime = "";
                string result = "";
                if (reader3["DiagnosisRecord_ID"] is DBNull)
                {
                    result = "";
                }
                else
                {
                    string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                    sqlOperation1.AddParameterWithValue("@ID", reader3["DiagnosisRecord_ID"].ToString());
                    result = sqlOperation1.ExecuteScalar(sqlCommand3);
                }
                if (Array.LastIndexOf(strArray, "6") > 0 && Array.LastIndexOf(strArray, "7") < 0)
                {
                    string sqlCommand6 = "select ct.OperateTime  from location,treatment,ct where location.ID=treatment.Location_ID and treatment.ID =@treatID and location.CT_ID=ct.ID";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    LoadCTTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                    double differ = computeDay(Convert.ToDateTime(LoadCTTime), DateTime.Now);
                    string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
                    sqlOperation1.AddParameterWithValue("@enddate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begindate", Convert.ToDateTime(LoadCTTime).ToString("yyyy-MM-dd"));
                    int result2 = int.Parse(sqlOperation1.ExecuteScalar(command));
                    string comm = "select warningcase.* from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    sqlOperation1.AddParameterWithValue("@progress", 6);
                    reader1 = sqlOperation1.ExecuteReader(comm);
                    double stoplength = 0;
                    while (reader1.Read())
                    {
                        if (reader1["StopTime"].ToString() != "")
                        {
                            stoplength = stoplength + computeDay(Convert.ToDateTime(reader1["StopTime"]), Convert.ToDateTime(reader1["RestartTime"]));

                        }

                    }
                    reader1.Close();
                    double finaltime = differ - stoplength - result2 * 24;
                    string timetask = "SELECT WarningLightTime,WarningSeriousTime FROM warning where Progress=6";
                    reader1 = sqlOperation1.ExecuteReader(timetask);
                    double light = 0;
                    double serious = 0;
                    if (reader1.Read())
                    {
                        light = double.Parse(reader1["WarningLightTime"].ToString());
                        serious = double.Parse(reader1["WarningSeriousTime"].ToString());

                    }
                    reader1.Close();

                    if (finaltime > light)
                    {
                        if (finaltime < serious)
                        {
                            string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                            sqlOperation1.ExecuteNonQuery(recordcommand);

                            string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                            sqlOperation1.AddParameterWithValue("@type", "黄色预警");
                            sqlOperation1.AddParameterWithValue("@time", finaltime);
                            sqlOperation1.ExecuteNonQuery(recordcommand2);
                        }
                        else
                        {
                            string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                            sqlOperation1.ExecuteNonQuery(recordcommand);

                            string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 6);
                            sqlOperation1.AddParameterWithValue("@type", "红色预警");
                            sqlOperation1.AddParameterWithValue("@time", finaltime);
                            sqlOperation1.ExecuteNonQuery(recordcommand2);

                        }

                    }
                }
                if (Array.LastIndexOf(strArray, "9") > 0 && Array.LastIndexOf(strArray, "10") < 0)
                {
                    string sqlCommand6 = "select design.SubmitTime  from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID ";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    designSubmitTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                    double differ = computeDay(Convert.ToDateTime(designSubmitTime), DateTime.Now);
                    string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
                    sqlOperation1.AddParameterWithValue("@enddate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begindate", Convert.ToDateTime(designSubmitTime).ToString("yyyy-MM-dd"));
                    int result2 = int.Parse(sqlOperation1.ExecuteScalar(command));
                    string comm = "select warningcase.* from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
                    sqlOperation1.AddParameterWithValue("@treatID", reader3["treatid"].ToString());
                    sqlOperation1.AddParameterWithValue("@progress", 9);
                    reader1 = sqlOperation1.ExecuteReader(comm);
                    double stoplength = 0;
                    while (reader1.Read())
                    {
                        if (reader1["StopTime"].ToString() != "")
                        {
                            stoplength = stoplength + computeDay(Convert.ToDateTime(reader1["StopTime"]), Convert.ToDateTime(reader1["RestartTime"]));

                        }

                    }
                    reader1.Close();
                    double finaltime = differ - stoplength - result2 * 24;
                    string timetask = "SELECT WarningLightTime,WarningSeriousTime FROM warning where Progress=9";
                    reader1 = sqlOperation1.ExecuteReader(timetask);
                    double light = 0;
                    double serious = 0;
                    if (reader1.Read())
                    {
                        light = double.Parse(reader1["WarningLightTime"].ToString());
                        serious = double.Parse(reader1["WarningSeriousTime"].ToString());

                    }
                    reader1.Close();

                    if (finaltime > light)
                    {
                        if (finaltime < serious)
                        {
                            string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                            sqlOperation1.ExecuteNonQuery(recordcommand);

                            string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                            sqlOperation1.AddParameterWithValue("@type", "黄色预警");
                            sqlOperation1.AddParameterWithValue("@time", finaltime);
                            sqlOperation1.ExecuteNonQuery(recordcommand2);
                        }
                        else
                        {
                            string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                            sqlOperation1.ExecuteNonQuery(recordcommand);

                            string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                            sqlOperation1.AddParameterWithValue("@treat", reader3["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 9);
                            sqlOperation1.AddParameterWithValue("@type", "红色预警");
                            sqlOperation1.AddParameterWithValue("@time", finaltime);
                            sqlOperation1.ExecuteNonQuery(recordcommand2);

                        }

                    }
                }
                backText.Append("{\"Name\":\"" + reader3["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"state\":\"" + reader3["treatstate"].ToString() +
                     "\",\"Radiotherapy_ID\":\"" + reader3["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader3["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + ""
                     + "\",\"Progress\":\"" + reader3["Progress"].ToString() + "\",\"doctor\":\"" + reader3["doctor"].ToString() + "\",\"treatID\":\"" + reader3["treatid"].ToString() + "\",\"LoadCTTime\":\"" + LoadCTTime + "\",\"designSubmitTime\":\"" + designSubmitTime + "\",\"iscommon\":\"" + reader3["iscommon"].ToString() + "\",\"hasfirst\":\"" + "" + "\"}");

                if (temp < count2 - 1)
                {
                    backText.Append(",");
                }
                temp++;
            }

            backText.Append("]}");
            return backText.ToString();

            
            
        }
        
        
        
        
        
        
        
        
        
    }
    private double computeDay(DateTime date1, DateTime date2)
    {
        int countdays = 0;
        double prevtime = 0;
        double nexttime = 0;
        DateTime temp = date1.AddDays(1);
        while ((temp.Day < date2.Day && temp.Month == date2.Month) || temp.Month < date2.Month)
        {
            countdays++;
            /*if (temp≠后台配置日期) {
                countdays++;
                //该函数增加参数：后台配置日期数组
            }*/
            temp = temp.AddDays(1);
        }
        if (countdays > 0)
        {
            if (date1.DayOfWeek.ToString() != "Saturday" && date1.DayOfWeek.ToString() != "Sunday")
            {
                int hour = date1.Hour;
                int min = date1.Minute;
                int rest = 24 - hour - 1;
                prevtime = Math.Round((rest * 60 + (60 - min)) / 60.0, 1);

            }
            if (date2.DayOfWeek.ToString() != "Saturday" && date2.DayOfWeek.ToString() != "Sunday")
            {
                int hour = date2.Hour;
                int min = date2.Minute;
                nexttime = Math.Round((hour * 60 + min) / 60.0, 1);
            }
        }
        else
        {
            if (date2.Day != date1.Day)
            {
                int hour = date1.Hour;
                int min = date1.Minute;
                int rest = 24 - hour - 1;
                int hour2 = date2.Hour;
                int min2 = date2.Minute;
                nexttime = Math.Round((hour2 * 60 + min2) / 60.0, 1) + Math.Round((rest * 60 + (60 - min)) / 60.0, 1);
            }
            else
            {
                int hour = date1.Hour;
                int min = date1.Minute;
                int hour2 = date2.Hour;
                int min2 = date2.Minute;
                nexttime = Math.Round(((hour2 - hour - 1) * 60.0 + (60 - min) + min2) / 60.0, 1);
            }

        }
        return countdays * 24 + prevtime + nexttime;
    }
    
}