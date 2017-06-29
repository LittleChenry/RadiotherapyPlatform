<%@ WebHandler Language="C#" Class="fixedApplyRecord" %>

using System;
using System.Web;

public class fixedApplyRecord : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    DataLayer sqlOperation3 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddFixRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
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
        string appoint = context.Request.QueryString["id"];
        string treatid = context.Request.QueryString["treatid"];
        string model = context.Request.QueryString["model"];
        string fixreq = context.Request.QueryString["fixreq"];
        string user = context.Request.QueryString["user"];
        string fixequip = context.Request.QueryString["fixequip"];
        string bodypost = context.Request.QueryString["bodypost"];

        string strcommand = "select State from appointment where ID=@appointid";
        sqlOperation.AddParameterWithValue("@appointid", Convert.ToInt32(appoint));
        string count = sqlOperation.ExecuteScalar(strcommand);
        if (count == "1")
        {
            return "busy";
        }
        else
        {
            string strcommand1 = "update appointment set State=1 where ID=@appointid and State=0";
            int intSuccess = sqlOperation.ExecuteNonQuery(strcommand1);
            if (intSuccess == 0)
            {
                return "busy";
            }
            else
            {
                string strcommand2 = "select Patient_ID from treatment where ID=@treat";
                sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                string patient_ID = sqlOperation.ExecuteScalar(strcommand2);

                string finishappoint = "update appointment set Patient_ID=@Patient,Treatment_ID=@treat where ID=@appointid";
                sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
                int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);
               //将信息写入数据库，并返回是否成功
                string strSqlCommand = "INSERT INTO fixed(Appointment_ID,Model_ID,FixedRequirements_ID,Application_User_ID,ApplicationTime,BodyPosition,FixedEquipment_ID) " +
                                        "VALUES(@Appointment_ID,@Model_ID,@FixedRequirements_ID,@Application_User_ID,@ApplicationTime,@BodyPosition,@FixedEquipment_ID)";
                sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                sqlOperation1.AddParameterWithValue("@Model_ID", Convert.ToInt32(model));
                sqlOperation1.AddParameterWithValue("@FixedRequirements_ID", Convert.ToInt32(fixreq));
                sqlOperation1.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                sqlOperation1.AddParameterWithValue("@ApplicationTime", DateTime.Now);
                sqlOperation1.AddParameterWithValue("@BodyPosition", bodypost);
                sqlOperation1.AddParameterWithValue("@FixedEquipment_ID", fixequip);
                int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);

                string maxnumber = "select ID from fixed where Appointment_ID=@appointid and Application_User_ID=@Application_User_ID order by ID desc";
                sqlOperation.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
                string maxfixid = sqlOperation.ExecuteScalar(maxnumber);

                //将诊断ID填入treatment表
                string inserttreat = "update treatment set Fixed_ID=@fix_ID,Progress=3 where ID=@treat";
                sqlOperation.AddParameterWithValue("@fix_ID", Convert.ToInt32(maxfixid));
                int Success = sqlOperation.ExecuteNonQuery(inserttreat);
                if (Success > 0 && Success2 > 0 && Success1>0)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
            }
        }
        
    }
        

}