<%@ WebHandler Language="C#" Class="patientInfoForJLS" %>

using System;
using System.Web;
using System.Text;
public class patientInfoForJLS : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
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
    private string getfixrecordinfo(HttpContext context)
    {
        String userid = context.Request.QueryString["userID"];
        string sqlCommand = "SELECT count(*) from treatment where (Progress like '%5%' and Progress not in(select Progress from treatment where Progress like '%7%'))or ((Progress like '%8%' or Progress like '%7%') and Progress not in (select Progress from treatment where Progress like '%10%')) and state=0";       
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"PatientInfo\":false}";
        }
        
        int i = 1;
        string sqlCommand2 = "select treatment.State as treatstate,treatment.ID as treatid,patient.*,user.Name as doctor,isback,Progress,iscommon,treatment.Treatmentdescribe,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and treatment.Belongingdoctor=user.ID and ((Progress like '%5%' and Progress not in(select Progress from treatment where Progress like '%7%'))or ((Progress like '%8%' or Progress like '%7%') and Progress not in (select Progress from treatment where Progress like '%10%'))) and treatment.state=0 order by patient.ID desc";   
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");

        while (reader.Read())
        {
            string progress = reader["Progress"].ToString();
            string[] strArray = progress.Split(',');
            string locationTime = "";
            string designApplyTime = "";
            string receiveTime = "";
            string advice = "";
            if (Array.LastIndexOf(strArray, "8") > 0)
            {
                string sqlCommand5 = "select Receive_User_ID from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                string receiveID = sqlOperation1.ExecuteScalar(sqlCommand5);
                //if (receiveID != userid)
                //{
                //    count--;
                //    continue;
                //}
                string sqlCommand8 = "select ReceiveTime from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                receiveTime = sqlOperation1.ExecuteScalar(sqlCommand8);
                if (Array.LastIndexOf(strArray, "9") < 0)
                {
                    double differ = computeDay(Convert.ToDateTime(receiveTime), DateTime.Now);
                    string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
                    sqlOperation1.AddParameterWithValue("@enddate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));
                    sqlOperation1.AddParameterWithValue("@begindate", Convert.ToDateTime(receiveTime).ToString("yyyy-MM-dd"));
                    int result2 = int.Parse(sqlOperation1.ExecuteScalar(command));
                    string comm = "select warningcase.* from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
                    sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                    sqlOperation1.AddParameterWithValue("@progress", 8);
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(comm);
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
                    string timetask = "SELECT WarningLightTime,WarningSeriousTime FROM warning where Progress=8";
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
                            sqlOperation1.AddParameterWithValue("@currentprogress", 8);
                            sqlOperation1.ExecuteNonQuery(recordcommand);

                            string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                            sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 8);
                            sqlOperation1.AddParameterWithValue("@type", "黄色预警");
                            sqlOperation1.AddParameterWithValue("@time", finaltime);
                            sqlOperation1.ExecuteNonQuery(recordcommand2);
                        }
                        else
                        {
                            string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                            sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 8);
                            sqlOperation1.ExecuteNonQuery(recordcommand);

                            string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                            sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                            sqlOperation1.AddParameterWithValue("@currentprogress", 8);
                            sqlOperation1.AddParameterWithValue("@type", "红色预警");
                            sqlOperation1.AddParameterWithValue("@time", finaltime);
                            sqlOperation1.ExecuteNonQuery(recordcommand2);

                        }

                    }
                }

            }
            if (Array.LastIndexOf(strArray, "5") > 0 && Array.LastIndexOf(strArray, "6") < 0)
            {
                string sqlCommand6 = "select OperateTime from location,treatment where location.ID=treatment.Location_ID and treatment.ID =@treatID";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                locationTime = sqlOperation1.ExecuteScalar(sqlCommand6);
                double differ=computeDay(Convert.ToDateTime(locationTime),DateTime.Now);
                string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
                sqlOperation1.AddParameterWithValue("@enddate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));
                sqlOperation1.AddParameterWithValue("@begindate", Convert.ToDateTime(locationTime).ToString("yyyy-MM-dd"));
                int result2 =int.Parse(sqlOperation1.ExecuteScalar(command));
                string comm = "select warningcase.* from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                sqlOperation1.AddParameterWithValue("@progress", 5);
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(comm);
                double stoplength=0;
                while (reader1.Read())
                {
                    if (reader1["StopTime"].ToString() != "")
                    {
                        stoplength = stoplength + computeDay(Convert.ToDateTime(reader1["StopTime"]), Convert.ToDateTime(reader1["RestartTime"]));
                        
                    }
 
                }
                reader1.Close();
                double finaltime = differ - stoplength - result2 * 24;
                string timetask = "SELECT WarningLightTime,WarningSeriousTime FROM warning where Progress=5";
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
                        sqlOperation1.AddParameterWithValue("@currentprogress", 5);
                        sqlOperation1.ExecuteNonQuery(recordcommand);

                        string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                        sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@currentprogress", 5);
                        sqlOperation1.AddParameterWithValue("@type", "黄色预警");
                        sqlOperation1.AddParameterWithValue("@time", finaltime);
                        sqlOperation1.ExecuteNonQuery(recordcommand2);
                    }
                    else
                    {
                        string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                        sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@currentprogress", 5);
                        sqlOperation1.ExecuteNonQuery(recordcommand);

                        string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                        sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@currentprogress", 5);
                        sqlOperation1.AddParameterWithValue("@type", "红色预警");
                        sqlOperation1.AddParameterWithValue("@time", finaltime);
                        sqlOperation1.ExecuteNonQuery(recordcommand2);
                        
                    }
                    
                }
            }
            if (Array.LastIndexOf(strArray, "7") > 0 && Array.LastIndexOf(strArray, "8") < 0)
            {
                string sqlCommand7 = "select ApplicationTime from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                designApplyTime = sqlOperation1.ExecuteScalar(sqlCommand7);
                if (reader["isback"].ToString() == "1")
                {
                    string sqlCommand8 = "select Checkadvice from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                    sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                    advice = sqlOperation1.ExecuteScalar(sqlCommand8);
                }

                double differ = computeDay(Convert.ToDateTime(designApplyTime), DateTime.Now);
                string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
                sqlOperation1.AddParameterWithValue("@enddate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));
                sqlOperation1.AddParameterWithValue("@begindate", Convert.ToDateTime(designApplyTime).ToString("yyyy-MM-dd"));
                int result2 = int.Parse(sqlOperation1.ExecuteScalar(command));
                string comm = "select warningcase.* from warningcase where TreatID=@treatID and progress=@progress and (Type=0 or Type=2)";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                sqlOperation1.AddParameterWithValue("@progress", 7);
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(comm);
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
                string timetask = "SELECT WarningLightTime,WarningSeriousTime FROM warning where Progress=7";
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
                        sqlOperation1.AddParameterWithValue("@currentprogress", 7);
                        sqlOperation1.ExecuteNonQuery(recordcommand);

                        string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                        sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@currentprogress", 7);
                        sqlOperation1.AddParameterWithValue("@type", "黄色预警");
                        sqlOperation1.AddParameterWithValue("@time", finaltime);
                        sqlOperation1.ExecuteNonQuery(recordcommand2);
                    }
                    else
                    {
                        string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
                        sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@currentprogress", 7);
                        sqlOperation1.ExecuteNonQuery(recordcommand);

                        string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
                        sqlOperation1.AddParameterWithValue("@treat", reader["treatid"].ToString());
                        sqlOperation1.AddParameterWithValue("@currentprogress", 7);
                        sqlOperation1.AddParameterWithValue("@type", "红色预警");
                        sqlOperation1.AddParameterWithValue("@time", finaltime);
                        sqlOperation1.ExecuteNonQuery(recordcommand2);

                    }

                }
            }
            string result="";
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
            backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"state\":\"" + reader["treatstate"].ToString() +
                    "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"isback\":\"" + reader["isback"].ToString() + "\",\"advice\":\"" + advice
                    + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"locationTime\":\"" + locationTime + "\",\"receiveTime\":\"" + receiveTime + "\",\"designApplyTime\":\"" + designApplyTime + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\"}");

            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        reader.Close();       
        // backText.Remove(backText.Length - 1, 1);                
        backText.Append("]}");
        return backText.ToString();
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