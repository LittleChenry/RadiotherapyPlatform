<%@ WebHandler Language="C#" Class="RecordEquipmentCheck" %>

using System;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

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

        string sqlCommand = "INSERT INTO checkRecord(checkCycle,checkPeople,checkDate,Equipment_ID) VALUES(@cycle,@people,@date,@eid)";
        sqlOperation.AddParameterWithValue("@cycle", cycle);
        sqlOperation.AddParameterWithValue("@people", people);
        sqlOperation.AddParameterWithValue("@date", date);
        sqlOperation.AddParameterWithValue("@eid", equipmentID);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        sqlCommand = "SELECT ID FROM checkRecord WHERE checkPeople=@people AND Equipment_ID=@eid AND checkCycle=@cycle order by ID desc";
        int Record_ID = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));

        sqlCommand = "INSERT INTO checkresult(Inspection_ID,UIMRTRealValue,UIMRTState,IMRTRealValue,IMRTState,SRSRealValue,SRSState,FunctionalStatus,Record_ID) VALUES(@Iid,@UIMRTRealValue,@UIMRTState,@IMRTRealValue,@IMRTState,@SRSRealValue,@SRSState,@FunctionalStatus,@Record_ID)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Record_ID", Record_ID);
        for (int i = 0; i < obj.Length; i++)
        {
            sqlOperation.AddParameterWithValue("@Iid", int.Parse(obj[i]["ID"].ToString()));
            sqlOperation.AddParameterWithValue("@UIMRTRealValue", obj[i]["UIMRTRealValue"].ToString());
            sqlOperation.AddParameterWithValue("@UIMRTState", obj[i]["UIMRTState"].ToString());
            sqlOperation.AddParameterWithValue("@IMRTRealValue", obj[i]["IMRTRealValue"].ToString());
            sqlOperation.AddParameterWithValue("@IMRTState", obj[i]["IMRTState"].ToString());
            sqlOperation.AddParameterWithValue("@SRSRealValue", obj[i]["SRSRealValue"].ToString());
            sqlOperation.AddParameterWithValue("@SRSState", obj[i]["SRSState"].ToString());
            sqlOperation.AddParameterWithValue("@FunctionalStatus", int.Parse(functionState));
            sqlOperation.ExecuteNonQuery(sqlCommand);
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}