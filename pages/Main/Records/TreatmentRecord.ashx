<%@ WebHandler Language="C#" Class="TreatmentRecord" %>

using System;
using System.Web;
 using System.Text;
public class TreatmentRecord : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = treatrecord(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
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
    private string treatrecord(HttpContext context)
    {

        int chid = Convert.ToInt32(context.Request["chid"]);
        int appointid = Convert.ToInt32(context.Request["appoint"]);
        int totalnumber = Convert.ToInt32(context.Request["totalnumber"]);
        int user = Convert.ToInt32(context.Request["user"]);
        string assistant = context.Request["assistant"];
        int treatdays = Convert.ToInt32(context.Request["treatdays"]);
        int patient = Convert.ToInt32(context.Request["patientid"]);
        int singlenumber = Convert.ToInt32(context.Request["singlenumber"]);
        double machinenumber = Convert.ToDouble(context.Request["machinenumber"]);
        int Illuminated = Convert.ToInt32(context.Request["IlluminatedNumber"]);
        string remark = context.Request["remark"];

        string sqlcommand2 = "select count(*) from treatmentrecord where ChildDesign_ID=@chid and Treat_User_ID is not NULL";
        sqlOperation.AddParameterWithValue("@chid", chid);
        int finishedtimes = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        string insert = "update treatmentrecord set TreatTime=@time,TreatedDays=@treatdays,TreatedTimes=@treattimes,Rest=@rest,Treat_User_ID=@user,IlluminatedNumber=@number1,MachineNumber=@number2,Assist_User=@assist,Singlenumber=@single,Remarks=@remarks where Appointment_ID=@appoint and ChildDesign_ID=@chid";
        sqlOperation.AddParameterWithValue("@time", DateTime.Now);
        sqlOperation.AddParameterWithValue("@treatdays", treatdays);
        sqlOperation.AddParameterWithValue("@treattimes", finishedtimes + 1);
        sqlOperation.AddParameterWithValue("@rest", totalnumber - finishedtimes - 1);
        sqlOperation.AddParameterWithValue("@user", user);
        sqlOperation.AddParameterWithValue("@number1", Illuminated);
        sqlOperation.AddParameterWithValue("@number2", machinenumber);
        sqlOperation.AddParameterWithValue("@assist", assistant);
        sqlOperation.AddParameterWithValue("@single", singlenumber);
        sqlOperation.AddParameterWithValue("@appoint", appointid);
        sqlOperation.AddParameterWithValue("@remarks", remark);
        int success = sqlOperation.ExecuteNonQuery(insert);

        //计算此病人是否结束治疗
        string sqlcommand3 = "select max(treatmentrecord.Rest) from treatmentrecord,childdesign,treatment where treatmentrecord.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID  and treatment.ID=(select Treatment_ID from childdesign where ID=@chid) and treatmentrecord.Treat_User_ID is not NULL";
        sqlOperation.AddParameterWithValue("@chid",chid);
        string restres = sqlOperation.ExecuteScalar(sqlcommand3);
        int res=0;
        if(restres!="")
        {
            res=int.Parse(restres);
        }
        //如果结束跳到总结随访
        //if (res == 0)
        //{
        //    string updatecomm = "UPDATE treatment set Progress='0,1,2,3,4,5,6,7,8,9,10,11,12,13,14' where ID=(select Treatment_ID from childdesign where ID=@chid)";
        //    sqlOperation.AddParameterWithValue("@chid", chid);
        //    sqlOperation.ExecuteNonQuery(updatecomm);
        //}
        
        if (success > 0)
        {

            return "success";

        }
        return "fail";
        
    }
}