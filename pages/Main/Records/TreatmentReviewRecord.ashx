<%@ WebHandler Language="C#" Class="TreatmentReviewRecord" %>

using System;
using System.Web;
using System.Text;
using System.Collections;

public class TreatmentReviewRecord : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = RecordPatientInformation(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;

   
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

                string treatid = context.Request["treatmentid"];
                string appointid = context.Request["appointid"];
                string scanpart = context.Request["scanpart"];
                string scanmethod = context.Request["scanmethod"];
                string userid = context.Request["user"];
                string addmethod = context.Request["addmethod"];
                string up = context.Request["up"];
                string down = context.Request["down"];
                string remark = context.Request["remark"];
                string requirement = context.Request["requirement"];
                string add = context.Request["add"];
                string thickness = context.Request["thickness"];
                string number = context.Request["number"];
                string ReferenceNumber = context.Request["ReferenceNumber"];
                string ReferenceScale = context.Request["ReferenceScale"];
                string newremark = context.Request["newremark"];
                string strSqlCommand = "UPDATE  treatmentreview  SET scanpart=@ScanPart_ID,scanmethod=@ScanMethod_ID,enhancemethod=@EnhanceMethod_ID,enhance=@Enhance,applyremark=@applyremark,down=@LowerBound,up=@UpperBound,specialrequest=@LocationRequirements_ID,remark=@remark,thick=@thickness,number=@number,ReferenceNumber=@ReferenceNumber,ReferenceScale=@ReferenceScale,operatetime=@datetime,operateuser=@userid where appoint_ID=@appoint";
                //各参数赋予实际值
                sqlOperation.AddParameterWithValue("@appoint", appointid);
                sqlOperation.AddParameterWithValue("@thickness", thickness);
                sqlOperation.AddParameterWithValue("@ScanPart_ID", scanpart);
                sqlOperation.AddParameterWithValue("@ScanMethod_ID", Convert.ToInt32(scanmethod));
                sqlOperation.AddParameterWithValue("@LocationRequirements_ID", Convert.ToInt32(requirement));
                sqlOperation.AddParameterWithValue("@Enhance", Convert.ToInt32(add));
                if (Convert.ToInt32(add) == 1)
                {
                    sqlOperation.AddParameterWithValue("@EnhanceMethod_ID", Convert.ToInt32(addmethod));
                }
                else
                {
                    sqlOperation.AddParameterWithValue("@EnhanceMethod_ID", null);
                }
                sqlOperation.AddParameterWithValue("@applyremark", remark);
                sqlOperation.AddParameterWithValue("@UpperBound", up);
                sqlOperation.AddParameterWithValue("@LowerBound", down);
                sqlOperation.AddParameterWithValue("@remark", newremark);
                sqlOperation.AddParameterWithValue("@number", number);
                sqlOperation.AddParameterWithValue("@ReferenceNumber", ReferenceNumber);
                sqlOperation.AddParameterWithValue("@ReferenceScale", ReferenceScale);
                sqlOperation.AddParameterWithValue("@datetime", DateTime.Now);
                sqlOperation.AddParameterWithValue("@userid", userid);
                int intSuccess1 = sqlOperation.ExecuteNonQuery(strSqlCommand);

                string command = "update appointment set State=1,Completed=1 where ID=@appoint";
                sqlOperation.AddParameterWithValue("@appoint", appointid);
                int success = sqlOperation.ExecuteNonQuery(command);
        
        
                if (intSuccess1 > 0 && success>0)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
          
    }

}