<%@ WebHandler Language="C#" Class="changeAccerateAppoint" %>

using System;
using System.Web;

public class changeAccerateAppoint : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddFixRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(result);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string AddFixRecord(HttpContext context)
    {
        //获取表单信息
        string oldappoint = context.Request["oldappoint"];
        string newdate = context.Request["newdate"];
        string newbegin = context.Request["newbegin"];
        string newend = context.Request["newend"];
        string equipidcommand = "select Equipment_ID from appointment_accelerate where ID=@oldappoint";
        sqlOperation.AddParameterWithValue("@oldappoint", oldappoint);
        string equipmentid = sqlOperation.ExecuteScalar(equipidcommand);
        string countcommand = "select count(*) from appointment_accelerate where Equipment_ID=@equip and ((Begin<=@begin and End>@begin) or (Begin<@end and End>=@end)) and Date=@date";
        sqlOperation.AddParameterWithValue("@equip", equipmentid);
        sqlOperation.AddParameterWithValue("@begin", newbegin);
        sqlOperation.AddParameterWithValue("@end", newend);
        sqlOperation.AddParameterWithValue("@date", newdate);
        int count = int.Parse(sqlOperation.ExecuteScalar(countcommand));
        if (count == 0)
        {
            string updateappoint = "update appointment_accelerate set Date=@date,Begin=@begin,End=@end where ID=@oldappoint";
            int success=sqlOperation.ExecuteNonQuery(updateappoint);
            if (success == 0)
            {
                return "failure";
            }
            else
            {
                return "success";
            }
            
        }
        else
        {
            return "busy";
        }
    }
   

}