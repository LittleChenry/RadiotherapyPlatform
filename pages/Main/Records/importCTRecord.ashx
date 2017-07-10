<%@ WebHandler Language="C#" Class="importCTRecord" %>

using System;
using System.Web;
using System.Text;
public class importCTRecord : IHttpHandler {
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
    
        try{
            string treatid = context.Request.Form["treatmentID"];
            int treat = Convert.ToInt32(treatid);
            string userID = context.Request.Form["userID"];
            int userid = Convert.ToInt32(userID);
            DateTime datetime = DateTime.Now;

            string strSqlCommand1 = "select ct.ID  from ct,treatment,location where treatment.ID=@treat and treatment.Location_ID=location.ID and location.CT_ID=ct.ID";
            sqlOperation.AddParameterWithValue("@treat", treat);
            string CTID = sqlOperation.ExecuteScalar(strSqlCommand1);
            string strSqlCommand = "UPDATE  ct  SET DensityConversion_ID=@densityconversion,SequenceNaming=@sequencenaming,Thickness=@Thickness,Number=@Number,ReferenceScale=@ReferenceScale,MultimodalImage=@MultimodalImage,Remarks=@Remarks,OperateTime=@datetime,Operate_User_ID=@userid where ct.ID=@ctID";
            //各参数赋予实际值
            sqlOperation.AddParameterWithValue("@ctID", CTID);
            sqlOperation.AddParameterWithValue("@densityconversion", Convert.ToInt32(context.Request.Form["DensityConversion"]));
            sqlOperation.AddParameterWithValue("@sequencenaming", context.Request.Form["SequenceNaming"]);
            sqlOperation.AddParameterWithValue("@Remarks", context.Request.Form["Remarks"]);
            sqlOperation.AddParameterWithValue("@datetime", datetime);
            sqlOperation.AddParameterWithValue("@userid", userid);
            sqlOperation.AddParameterWithValue("@Thickness", context.Request.Form["Thickness"]);
            sqlOperation.AddParameterWithValue("Number", context.Request.Form["Number"]);
            sqlOperation.AddParameterWithValue("ReferenceScale", context.Request.Form["ReferenceScale"]);
            sqlOperation.AddParameterWithValue("MultimodalImage", context.Request.Form["MultimodalImage"]);
            int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
            string strSqlCommand2 = "UPDATE  treatment  SET Progress=7 where treatment.ID=@treat";
            int intSuccess2 = sqlOperation.ExecuteNonQuery(strSqlCommand2);
            if (intSuccess > 0 & intSuccess2 > 0)
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