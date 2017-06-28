<%@ WebHandler Language="C#" Class="AddnewItem" %>

using System;
using System.Web;
using System.Web.Script.Serialization;

public class AddnewItem : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/x-www-form-urlencoded";
        Insert(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void Insert(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "";
        var jsonStr = context.Request.Form["date"];
        JavaScriptSerializer js = new JavaScriptSerializer();
        LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);

        string MainItem = obj[0]["MainItem"].ToString();
        string ChildItem = obj[0]["ChildItem"].ToString();
        string UIMRTReference = obj[0]["UIMRTReference"].ToString();
        string UIMRTError = obj[0]["UIMRTError"].ToString();
        string UIMRTUnit = obj[0]["UIMRTUnit"].ToString();
        string IMRTReference = obj[0]["IMRTReference"].ToString();
        string IMRTError = obj[0]["IMRTError"].ToString();
        string IMRTUnit = obj[0]["IMRTUnit"].ToString();
        string SRSReference = obj[0]["SRSReference"].ToString();
        string SRSError = obj[0]["SRSError"].ToString();
        string SRSUnit = obj[0]["SRSUnit"].ToString();
        string Cycle = obj[0]["Cycle"].ToString();

        sqlCommand = "INSERT INTO inspection (MainItem,ChildItem,UIMRTReference,UIMRTUnit,UIMRTError,"
                    + "IMRTReference,IMRTUnit,IMRTError,SRSReference,SRSUnit,SRSError,Cycle) VALUES ("
                    + " @MainItem,@ChildItem,@UIMRTReference,@UIMRTUnit,@UIMRTError,@IMRTReference,@IMRTUnit,"
                    + "@IMRTError,@SRSReference,@SRSUnit,@SRSError,@Cycle)";
        sqlOperation.AddParameterWithValue("@MainItem",MainItem);
        sqlOperation.AddParameterWithValue("@ChildItem",ChildItem);
        sqlOperation.AddParameterWithValue("@UIMRTReference", UIMRTReference);
        sqlOperation.AddParameterWithValue("@UIMRTUnit", UIMRTUnit);
        sqlOperation.AddParameterWithValue("@UIMRTError", UIMRTError);
        sqlOperation.AddParameterWithValue("@IMRTReference", IMRTReference);
        sqlOperation.AddParameterWithValue("@IMRTUnit", IMRTUnit);
        sqlOperation.AddParameterWithValue("@IMRTError", IMRTError);
        sqlOperation.AddParameterWithValue("@SRSReference", SRSReference);
        sqlOperation.AddParameterWithValue("@SRSUnit", SRSUnit);
        sqlOperation.AddParameterWithValue("@SRSError", SRSError);
        sqlOperation.AddParameterWithValue("@Cycle", Cycle);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
    
}