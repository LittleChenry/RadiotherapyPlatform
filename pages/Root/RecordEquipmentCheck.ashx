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
        DateTime date = DateTime.Now;
        int people = (context.Session["loginUser"] as UserInformation).GetUserID();
        JavaScriptSerializer js = new JavaScriptSerializer();
        LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);

        string sqlCommand = "INSERT INTO checkRecord(checkCycle,checkPeople,checkDate,Equipment_ID,result) VALUES(@cycle,@people,@date,@eid,@result)";
        sqlOperation.AddParameterWithValue("@cycle", cycle);
        sqlOperation.AddParameterWithValue("@people", people);
        sqlOperation.AddParameterWithValue("@date", date);
        sqlOperation.AddParameterWithValue("@eid", equipmentID);
        sqlOperation.AddParameterWithValue("@result", int.Parse(functionState));
        sqlOperation.ExecuteNonQuery(sqlCommand);

        sqlCommand = "SELECT ID FROM checkRecord WHERE checkPeople=@people AND Equipment_ID=@eid AND checkCycle=@cycle order by ID desc";
        int Record_ID = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));

        //sqlCommand = "INSERT INTO checkresult(Inspection_ID,UIMRTRealValue,UIMRTState,IMRTRealValue,IMRTState,SRSRealValue,SRSState,FunctionalStatus,Record_ID) VALUES(@Iid,@UIMRTRealValue,@UIMRTState,@IMRTRealValue,@IMRTState,@SRSRealValue,@SRSState,@FunctionalStatus,@Record_ID)";
        string sql = "INSERT INTO checkresult(Inspection_ID,UIMRTRealValue";
        string add = " VALUES(@Iid,@UIMRTRealValue";
        
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Record_ID", Record_ID);
        for (int i = 0; i < obj.Length; i++)
        {
            StringBuilder command = new StringBuilder(sql);
            StringBuilder addstr = new StringBuilder(add);
            sqlOperation.AddParameterWithValue("@Iid", int.Parse(obj[i]["ID"].ToString()));
            sqlOperation.AddParameterWithValue("@UIMRTRealValue", obj[i]["UIMRTRealValue"].ToString());
            if (obj[i]["UIMRTState"].ToString() != "0")
            {
                command.Append(",UIMRTState");
                addstr.Append(",@UIMRTState");
            }
            sqlOperation.AddParameterWithValue("@UIMRTState", obj[i]["UIMRTState"].ToString());
            command.Append(",IMRTRealValue");
            addstr.Append(",@IMRTRealValue");
            sqlOperation.AddParameterWithValue("@IMRTRealValue", obj[i]["IMRTRealValue"].ToString());
            if (obj[i]["IMRTState"].ToString() != "0")
            {
                command.Append(",IMRTState");
                addstr.Append(",@IMRTState");
            }
            
            sqlOperation.AddParameterWithValue("@IMRTState", obj[i]["IMRTState"].ToString());
            
            command.Append(",SRSRealValue");
            addstr.Append(",@SRSRealValue");
            
            sqlOperation.AddParameterWithValue("@SRSRealValue", obj[i]["SRSRealValue"].ToString());
            sqlOperation.AddParameterWithValue("@SRSState", obj[i]["SRSState"].ToString());
            sqlOperation.AddParameterWithValue("@FunctionalStatus", int.Parse(obj[i]["FunctionalStatus"].ToString()));
            if (obj[i]["FunctionalStatus"].ToString() != "-1")
            {
                command.Append(",FunctionalStatus");
                addstr.Append(",@FunctionalStatus");
            }

            command.Append(",Record_ID)");
            addstr.Append(",@Record_ID)");
            
            command.Append(addstr);

            sqlOperation.ExecuteNonQuery(command.ToString());
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}