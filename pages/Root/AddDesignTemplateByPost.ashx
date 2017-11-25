<%@ WebHandler Language="C#" Class="AddDesignTemplateByPost" %>

using System;
using System.Web;

public class AddDesignTemplateByPost : IHttpHandler {
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

            string userID = "0";
            int userid = Convert.ToInt32(userID);
            DateTime datetime = DateTime.Now;
            string date1 = datetime.ToString();
            string aa = context.Request.Form["aa"];
            string bb = context.Request.Form["bb"];
            string name = context.Request.Form["templateName_design"];
            if(aa=="NaN"){
                aa = "-1";
            }
            if (bb == "NaN")
            {
                bb = "-1";
            }
            string DosagePriority = "";
            int a1 = Convert.ToInt32(aa);
            int i = 0;
            while (i <= a1)
            {
                string ii = Convert.ToString(i);
                string Prioritytype = context.Request.Form["Prioritytype" + ii];
                string Priorityout = context.Request.Form["Priorityout" + ii];
                string Prioritptv = context.Request.Form["Prioritptv" + ii];
                string Prioritcgy = context.Request.Form["Prioritcgy" + ii];
                string Priorittime = context.Request.Form["Priorittime" + ii];
                string Prioritsum = context.Request.Form["Prioritsum" + ii];
                string Prioritremark = context.Request.Form["Prioritremark" + ii];
                string Priorit = context.Request.Form["Priorit" + ii];
                DosagePriority = DosagePriority + Prioritytype + "," + Priorityout + "," + Prioritptv + "," + Prioritcgy + "," + Priorittime + "," + Prioritsum + "," + Prioritremark + "," + Priorit + ";";
                i++;
            }
            int b1 = Convert.ToInt32(bb);
            int j = 0;
            DosagePriority = DosagePriority + "&";
            while (j <= b1)
            {
                string jj = Convert.ToString(j);
                string type = context.Request.Form["type" + jj];
                string dv = context.Request.Form["dv" + jj];
                string number = context.Request.Form["number" + jj];
                string outt = context.Request.Form["out" + jj];
                string prv = context.Request.Form["prv" + jj];
                string num = context.Request.Form["num" + jj];
                string numbers = context.Request.Form["numbers" + jj];
                string pp = context.Request.Form["pp" + jj];
                DosagePriority = DosagePriority + type + "," + dv + ",<," + number + "," + outt + "," + prv + "," + num + ",<," + numbers + "," + pp + ";";
                j++;
            }
            string strSqlCommand = "INSERT INTO Design(RadiotherapyHistory,DosagePriority,Technology_ID,Equipment_ID,Application_User_ID,ApplicationTime) " +
                                    "VALUES(@RadiotherapyHistory,@DosagePriority,@Technology_ID,@Equipment_ID,@Application_User_ID,@ApplicationTime)";
            // sqlOperation.AddParameterWithValue("@ID", Count);
            sqlOperation.AddParameterWithValue("@RadiotherapyHistory", context.Request.Form["Remarks_design"]);
            sqlOperation.AddParameterWithValue("@Technology_ID", Convert.ToInt32(context.Request.Form["technology_design"]));
            sqlOperation.AddParameterWithValue("@Equipment_ID", Convert.ToInt32(context.Request.Form["equipment_design"]));
            sqlOperation.AddParameterWithValue("@DosagePriority", DosagePriority);
            sqlOperation.AddParameterWithValue("@ApplicationTime", date1);
            sqlOperation.AddParameterWithValue("@Application_User_ID", userid);
            int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            string maxnumber = "select ID from design where Application_User_ID=@Application_User_ID and ApplicationTime=@ApplicationTime order by ID desc";
            sqlOperation1.AddParameterWithValue("@ApplicationTime", date1);
            sqlOperation1.AddParameterWithValue("@Application_User_ID", userid);
            string count = sqlOperation1.ExecuteScalar(maxnumber);
            int Count = Convert.ToInt32(count);

            string inserttreat = "INSERT INTO doctortemplate(Name,TemplateID,Type,User_ID) " +
                                "VALUES(@Name,@TemplateID,@Type,@User_ID)";
            sqlOperation2.AddParameterWithValue("@Type", 7);
            sqlOperation2.AddParameterWithValue("@TemplateID", Count);
            sqlOperation2.AddParameterWithValue("@User_ID", userid);
            sqlOperation2.AddParameterWithValue("@Name", name);
            int Success = sqlOperation2.ExecuteNonQuery(inserttreat);

            if (intSuccess > 0 && Success > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }


    }
}