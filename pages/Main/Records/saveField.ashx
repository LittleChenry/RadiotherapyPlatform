<%@ WebHandler Language="C#" Class="saveField" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class saveField : IHttpHandler {
    
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = RecordPatientInformation(context);
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
    private string RecordPatientInformation(HttpContext context)
    {
        try
        {
            string treatid = context.Request.Form["hidetreatID"];
            int treatID = Convert.ToInt32(treatid);
            //string userID = "1";
            string userID = context.Request.Form["userID"];
            int userid = Convert.ToInt32(userID);
            DateTime datetime = DateTime.Now;
            string date1 = datetime.ToString();
            string aa = context.Request.Form["aa"];
            int a=Convert.ToInt32(aa);
            /*
            string maxnumber = "select max(ID) from design";
            string count = sqlOperation1.ExecuteScalar(maxnumber);
            int Count;
            if (count == "")
            {
                Count = 1;
            }
            else
            {
                Count = Convert.ToInt32(count) + 1;
            }
             */          
            string select1 = "select Progress from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatID);
            string progress1 = sqlOperation.ExecuteScalar(select1);
            string[] group = progress1.Split(',');
            bool exists = ((IList)group).Contains("11");
            //if (!exists)
            //{
                int intSuccess = 0;
                for (int i = 0; i < a; i++)
                {
                    string strSqlCommand = "INSERT INTO fieldinfomation(code,mu,equipment,radiotechnique,radiotype,energy,wavedistance,angleframe,noseangle,bedrotation,subfieldnumber,User_ID,Operate_Time,treatmentid) " +
                                            "VALUES(@code,@mu,@equipment,@radiotechnique,@radiotype,@energy,@wavedistance,@angleframe,@noseangle,@bedrotation,@subfieldnumber,@User_ID,@Operate_Time,@treatmentid)";
                    // sqlOperation.AddParameterWithValue("@ID", Count);
                    sqlOperation.AddParameterWithValue("@code", context.Request.Form["a1"+i]);
                    sqlOperation.AddParameterWithValue("@mu", context.Request.Form["mu"+i]);
                    sqlOperation.AddParameterWithValue("@equipment", Convert.ToInt32(context.Request.Form["equipment"+i]));
                    sqlOperation.AddParameterWithValue("@radiotechnique", context.Request.Form["technology"+i]);
                    sqlOperation.AddParameterWithValue("@radiotype", context.Request.Form["type" + i]);
                    sqlOperation.AddParameterWithValue("@energy", context.Request.Form["energyField" + i]);
                    sqlOperation.AddParameterWithValue("@wavedistance", context.Request.Form["ypj" + i]);
                    sqlOperation.AddParameterWithValue("@angleframe", context.Request.Form["jjj" + i]);
                    sqlOperation.AddParameterWithValue("@noseangle", context.Request.Form["jtj" + i]);
                    sqlOperation.AddParameterWithValue("@bedrotation", context.Request.Form["czj" + i]);
                    sqlOperation.AddParameterWithValue("@subfieldnumber", context.Request.Form["childs" + i]);
                    sqlOperation.AddParameterWithValue("@Operate_Time", date1);
                    sqlOperation.AddParameterWithValue("@treatmentid", treatID);
                    sqlOperation.AddParameterWithValue("@User_ID", userid);
                    intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
                    if (intSuccess == 0) { break; }
                }
                string select = "select Progress from treatment where ID=@treat";
                sqlOperation.AddParameterWithValue("@treat", treatID);
                string progress = sqlOperation.ExecuteScalar(select);

                int Success = 0;

                string inserttreat = "update treatment set Progress=@progress,TPS=@TPS,positioninfomation=@positioninfomation where ID=@treat";
                sqlOperation2.AddParameterWithValue("@progress", progress + ",11");
                sqlOperation2.AddParameterWithValue("@TPS", context.Request.Form["tps"]);
                sqlOperation2.AddParameterWithValue("@positioninfomation", context.Request.Form["pos"]);
                sqlOperation2.AddParameterWithValue("@treat", treatID);
                Success = sqlOperation2.ExecuteNonQuery(inserttreat);

                if (intSuccess > 0 && Success > 0)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
            //}
            //else
            //{
            //    string select = "select design.ID from treatment,design where treatment.ID=@treat and design.ID=treatment.Design_ID";
            //    sqlOperation.AddParameterWithValue("@treat", treatID);
            //    string design = sqlOperation.ExecuteScalar(select);
            //    string strSqlCommand = "update Design set RadiotherapyHistory=@RadiotherapyHistory,DosagePriority=@DosagePriority,Technology_ID=@Technology_ID,Equipment_ID=@Equipment_ID,Application_User_ID=@Application_User_ID,ApplicationTime=@ApplicationTime where design.ID=@designid"; 
            //    // sqlOperation.AddParameterWithValue("@ID", Count);
            //    sqlOperation.AddParameterWithValue("@designid", Convert.ToInt32(design));
            //    sqlOperation.AddParameterWithValue("@RadiotherapyHistory", context.Request.Form["Remarks"]);
            //    sqlOperation.AddParameterWithValue("@Technology_ID", Convert.ToInt32(context.Request.Form["technology"]));
            //    sqlOperation.AddParameterWithValue("@Equipment_ID", Convert.ToInt32(context.Request.Form["equipment"]));
            //    sqlOperation.AddParameterWithValue("@DosagePriority", DosagePriority);
            //    sqlOperation.AddParameterWithValue("@ApplicationTime", date1);
            //    sqlOperation.AddParameterWithValue("@Application_User_ID", userid);
            //    int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            //    if (intSuccess > 0)
            //    {
            //        return "success";
            //    }
            //    else
            //    {
            //        return "failure";
            //    }
            //}
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }
    }
}
