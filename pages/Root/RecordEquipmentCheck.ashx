<%@ WebHandler Language="C#" Class="RecordEquipmentCheck" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using System.Text;

public class RecordEquipmentCheck : IHttpHandler, IRequiresSessionState{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        insert(context);
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void insert(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string jsonStr = context.Request.Form["date"];
        string cycle = context.Request.Form["cycle"];
        string equipmentID = context.Request.Form["equipment"];
        string functionState = context.Request.Form["functionState"];
        int model = int.Parse(context.Request.Form["model"]);
        DateTime date = DateTime.Now;
        int people = (context.Session["loginUser"] as UserInformation).GetUserID();
        JavaScriptSerializer js = new JavaScriptSerializer();
        LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);

        string sqlCommand = "INSERT INTO checkRecord(checkCycle,checkPeople,checkDate,Equipment_ID,result) VALUES(@cycle,@people,@date,@eid,@result);SELECT @@IDENTITY;";
        sqlOperation.AddParameterWithValue("@cycle", cycle);
        sqlOperation.AddParameterWithValue("@people", people);
        sqlOperation.AddParameterWithValue("@date", date);
        sqlOperation.AddParameterWithValue("@eid", equipmentID);
        sqlOperation.AddParameterWithValue("@result", int.Parse(functionState));
        int Record_ID = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));

        //sqlCommand = "INSERT INTO checkresult(Inspection_ID,UIMRTRealValue,UIMRTState,IMRTRealValue,IMRTState,SRSRealValue,SRSState,FunctionalStatus,Record_ID) VALUES(@Iid,@UIMRTRealValue,@UIMRTState,@IMRTRealValue,@IMRTState,@SRSRealValue,@SRSState,@FunctionalStatus,@Record_ID)";
        string sql = "INSERT INTO checkresults(Inspections_ID,RealValue";
        string add = " VALUES(@Iid,@RealValue";
        
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Record_ID", Record_ID);
        for (int i = 0; i < obj.Length; i++)
        {
            StringBuilder command = new StringBuilder(sql);
            StringBuilder addstr = new StringBuilder(add);
            sqlOperation.AddParameterWithValue("@Iid", int.Parse(obj[i]["ID"].ToString()));
            sqlOperation.AddParameterWithValue("@RealValue", obj[i]["RealValue"].ToString());
            
            sqlOperation.AddParameterWithValue("@FunctionalStatus", int.Parse(obj[i]["FunctionalStatus"].ToString()));
            if (obj[i]["FunctionalStatus"].ToString() != "-1")
            {
                command.Append(",FunctionStatus");
                addstr.Append(",@FunctionalStatus");
            }

            command.Append(",Record_ID)");
            addstr.Append(",@Record_ID)");
            
            command.Append(addstr);
            try
            {
                sqlOperation.ExecuteNonQuery(command.ToString());
            }
            catch (Exception ex)
            {
                string msg = ex.ToString();
            }
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}