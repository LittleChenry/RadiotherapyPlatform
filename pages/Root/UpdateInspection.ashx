<%@ WebHandler Language="C#" Class="UpdateInspection" %>

using System;
using System.Web;
using System.Web.Script.Serialization;

public class UpdateInspection : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        //context.Response.ContentType = "text/plain";
        context.Response.ContentType = "application/x-www-form-urlencoded";
        update(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void update(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "";
        var jsonStr = context.Request.Form["date"];
        JavaScriptSerializer js = new JavaScriptSerializer();
        LitJson.JsonData[] obj = js.Deserialize<LitJson.JsonData[]>(jsonStr);
        
        for (int i = 0; i < obj.Length; i++)
        {
            string id = obj[i]["ID"].ToString();
            string UIMRTReference = obj[i]["UIMRTReference"].ToString();
            string UIMRTError = obj[i]["UIMRTError"].ToString();
            string UIMRTUnit = "";
            if(UIMRTError == "NA" || UIMRTError == "IsOK"){
                UIMRTUnit = UIMRTError;   
            }else{
                UIMRTUnit = "write";   
            }
            
            string IMRTReference = obj[i]["IMRTReference"].ToString();
            string IMRTError = obj[i]["IMRTError"].ToString();
            string IMRTUnit = "";
            if(IMRTError == "NA" || IMRTError == "IsOK"){
                IMRTUnit = IMRTError;   
            }else{
                IMRTUnit = "write";   
            }
            
            string SRSReference = obj[i]["SRSReference"].ToString();
            string SRSError = obj[i]["SRSError"].ToString();
            string SRSUnit = "";
            if(SRSError == "NA" || SRSError == "IsOK"){
                SRSUnit = SRSError;   
            }else{
                SRSUnit = "write";   
            }
            sqlCommand = "UPDATE inspection set UIMRTReference=@UIMRTReference,UIMRTError=@UIMRTError,"
                + "UIMRTUnit=@UIMRTUnit,IMRTReference=@IMRTReference,IMRTError=@IMRTError,IMRTUnit=@IMRTUnit,"
                + "SRSReference=@SRSReference,SRSError=@SRSError,SRSUnit=@SRSUnit WHERE ID=@ID";
            sqlOperation.AddParameterWithValue("@UIMRTReference", UIMRTReference);
            sqlOperation.AddParameterWithValue("@UIMRTError", UIMRTError);
            sqlOperation.AddParameterWithValue("@UIMRTUnit", UIMRTUnit);
            sqlOperation.AddParameterWithValue("@IMRTReference",IMRTReference);
            sqlOperation.AddParameterWithValue("@IMRTError",IMRTError);
            sqlOperation.AddParameterWithValue("@IMRTUnit",IMRTUnit);
            sqlOperation.AddParameterWithValue("@SRSReference",SRSReference);
            sqlOperation.AddParameterWithValue("@SRSError",SRSError);
            sqlOperation.AddParameterWithValue("@SRSUnit",SRSUnit);
            sqlOperation.AddParameterWithValue("@ID",id);
            sqlOperation.ExecuteNonQuery(sqlCommand);
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
}