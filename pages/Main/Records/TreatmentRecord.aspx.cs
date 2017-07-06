using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_TreatmentRecord : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    protected void Page_Load(object sender, EventArgs e)
    {
        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
     
        //不是第一次加载页面进行录入
        if (myispostback != null && myispostback == "true")
        {
            if (RecordtreatmentInformation())
            {
                MessageBox.Message("保存成功!");
                sqlOperation.Close();
                sqlOperation.Dispose();
                sqlOperation = null;


            }

            else
            {
                MessageBox.Message("保存失败");
            }
        }

    }
    private bool RecordtreatmentInformation()
    {
        string treatid = Request.Form["hidetreatID"];
        string sqlcommand = "select max(id) from treatmentrecord where Treatment_ID=@treatid and TreatTime is NULL and TreatedDays is NULL";
        sqlOperation.AddParameterWithValue("@treatid", treatid);
        string id = sqlOperation.ExecuteScalar(sqlcommand);
        int intSuccess = 0;
        if (id.ToString() != "")
        {
            string sqlcommand2 = "select id from user where name=@name";
            sqlOperation.AddParameterWithValue("name", Request.Form["assistoperator1"]);
            string userid = sqlOperation.ExecuteScalar(sqlcommand2);
            string sqlcommand1 = "update  treatmentrecord set Treatment_ID=@treatid,TreatTime=@treattime,TreatedDays=@TreatedDays,TreatedTimes=@TreatedTimes,Treat_User_ID=@Treat_User_ID,Check_User_ID=1,IlluminatedNumber=@IlluminatedNumber,MachineNumbe=@MachineNumbe,Assist_User_ID=@Assist_User_ID,Singlenumber=@Singlenumber,X_System=@X_System,Y_System=@Y_System,Z_System=@Z_System where ID=@id";
            sqlOperation.AddParameterWithValue("@id", Convert.ToInt32(id));
            sqlOperation.AddParameterWithValue("@Z_System", Convert.ToInt32(Request.Form["SIcount1"]));
            sqlOperation.AddParameterWithValue("@Y_System", Convert.ToInt32(Request.Form["APcount1"]));
            sqlOperation.AddParameterWithValue("@X_System", Convert.ToInt32(Request.Form["RLcount1"]));
            sqlOperation.AddParameterWithValue("@Singlenumber", Convert.ToInt32(Request.Form["Number5"]));
            sqlOperation.AddParameterWithValue("@Assist_User_ID", Convert.ToInt32(userid));
            sqlOperation.AddParameterWithValue("@Treat_User_ID", Convert.ToInt32(Request.Form["userID"]));
            sqlOperation.AddParameterWithValue("@IlluminatedNumber", Convert.ToInt32(Request.Form["Number3"]));
            sqlOperation.AddParameterWithValue("@MachineNumbe", Convert.ToInt32(Request.Form["Number4"]));
            sqlOperation.AddParameterWithValue("@TreatedDays", Convert.ToInt32(Request.Form["treateddays1"]));
            sqlOperation.AddParameterWithValue("@treattime", DateTime.Now);
            sqlOperation.AddParameterWithValue("@TreatedTimes", Convert.ToInt32(Request.Form["treatdatetime1"]));
            intSuccess = sqlOperation.ExecuteNonQuery(sqlcommand1);
            string sqlcommand3 = "insert into igrt(Tool,Algorithm,Range,Operate_User_ID,OperateTime,TreatmentRecord_ID) values(@Tool,@Algorithm,@Range,@Operate_User_ID,@OperateTime,@id)";
            sqlOperation.AddParameterWithValue("@Tool", Request.Form["equip"]);
            sqlOperation.AddParameterWithValue("@Algorithm", Request.Form["peizhun"]);
            sqlOperation.AddParameterWithValue("@Range", Request.Form["range"]);
            sqlOperation.AddParameterWithValue("@Operate_User_ID", Convert.ToInt32(Request.Form["userID"]));
            sqlOperation.AddParameterWithValue("@OperateTime", DateTime.Now);
            int success = sqlOperation.ExecuteNonQuery(sqlcommand3);
            string x = Request.Form["live"];
            string[] group = x.Split(new Char[] { ',' });
            int k = 1;
            for (; k <= group.Length-1;k++)
            {
                string temp = group[k];
                string xvalue = Request.Form["Number" + temp + "1"];
                string yvalue = Request.Form["Number" + temp + "2"];
                string zvalue = Request.Form["Number" + temp + "3"];
                string sqlcommandtemp = "insert into locaterecord(X,Y,Z,TreatmentRecord_ID) values(@X,@Y,@Z,@TreatmentRecord_ID)";
                sqlOperation.AddParameterWithValue("@X", Convert.ToDouble(xvalue));
                sqlOperation.AddParameterWithValue("@Y", Convert.ToDouble(yvalue));
                sqlOperation.AddParameterWithValue("@Z", Convert.ToDouble(zvalue));
                sqlOperation.AddParameterWithValue("@TreatmentRecord_ID", Convert.ToInt32(id));
                sqlOperation.ExecuteNonQuery(sqlcommandtemp);

            }

        }

        else
        {
            string sqlcommand2 = "select id from user where name=@name";
            sqlOperation.AddParameterWithValue("name", Request.Form["assistoperator1"]);
            string userid = sqlOperation.ExecuteScalar(sqlcommand2);
            string insert = "insert into treatmentrecord(Treatment_ID,TreatTime,TreatedDays,TreatedTimes,Treat_User_ID,Check_User_ID,IlluminatedNumber,MachineNumbe,Assist_User_ID,Singlenumber,X_System,Y_System,Z_System) values(@treatid,@treattime,@TreatedDays,@TreatedTimes,@Treat_User_ID,1,@IlluminatedNumber,@MachineNumbe,@Assist_User_ID,@Singlenumber,@X_System,@Y_System,@Z_System)";
            sqlOperation.AddParameterWithValue("@Z_System", Request.Form["SIcount1"]);
            sqlOperation.AddParameterWithValue("@Y_System", Request.Form["APcount1"]);
            sqlOperation.AddParameterWithValue("@X_System", Request.Form["RLcount1"]);
            sqlOperation.AddParameterWithValue("@Singlenumber", Request.Form["Number5"]);
            sqlOperation.AddParameterWithValue("@Assist_User_ID", Convert.ToInt32(userid));
            sqlOperation.AddParameterWithValue("@Treat_User_ID", Convert.ToInt32(Request.Form["userID"]));
            sqlOperation.AddParameterWithValue("@IlluminatedNumber", Convert.ToInt32(Request.Form["Number3"]));
            sqlOperation.AddParameterWithValue("@MachineNumbe", Convert.ToInt32(Request.Form["Number4"]));
            sqlOperation.AddParameterWithValue("@TreatedDays", Convert.ToInt32(Request.Form["treateddays1"]));
            sqlOperation.AddParameterWithValue("@treattime", DateTime.Now);
            sqlOperation.AddParameterWithValue("@TreatedTimes", Convert.ToInt32(Request.Form["treatdatetime1"]));
            intSuccess = sqlOperation.ExecuteNonQuery(insert);
            string command = "select max(id) from treatmentrecord where Treatment_ID=@treatid and TreatedDays=@TreatedDays";
            string treatrecord = sqlOperation.ExecuteScalar(command);
            string sqlcommand3 = "insert into igrt(Tool,Algorithm,IGRTRange,Operate_User_ID,OperateTime,TreatmentRecord_ID) values(@Tool,@Algorithm,@Range,@Operate_User_ID,@OperateTime,@id)";
            sqlOperation.AddParameterWithValue("@Tool", Request.Form["equip"]);
            sqlOperation.AddParameterWithValue("@Algorithm", Request.Form["peizhun"]);
            sqlOperation.AddParameterWithValue("@Range", Request.Form["range"]);
            sqlOperation.AddParameterWithValue("@Operate_User_ID", Convert.ToInt32(Request.Form["userID"]));
            sqlOperation.AddParameterWithValue("@OperateTime", DateTime.Now);
            sqlOperation.AddParameterWithValue("@id", Convert.ToInt32(treatrecord));
            int success = sqlOperation.ExecuteNonQuery(sqlcommand3);
            string x = Request.Form["live"];
            string[] group = x.Split(new Char[] { ',' });
            int k = 1;
            for (; k <= group.Length - 1; k++)
            {
                string temp = group[k];
                string xvalue = Request.Form["Number" + temp + "1"];
                string yvalue = Request.Form["Number" + temp + "2"];
                string zvalue = Request.Form["Number" + temp + "3"];
                string sqlcommandtemp = "insert into locaterecord(X,Y,Z,TreatmentRecord_ID) values(@X,@Y,@Z,@TreatmentRecord_ID)";
                sqlOperation.AddParameterWithValue("@X", Convert.ToDouble(xvalue));
                sqlOperation.AddParameterWithValue("@Y", Convert.ToDouble(yvalue));
                sqlOperation.AddParameterWithValue("@Z", Convert.ToDouble(zvalue));
                sqlOperation.AddParameterWithValue("@TreatmentRecord_ID", Convert.ToInt32(treatrecord));
                sqlOperation.ExecuteNonQuery(sqlcommandtemp);

            }

        }
        if (Request.Form["complete"] =="1")
        {
            string strSqlCommand3 = "UPDATE  treatment  SET Progress=16 where Treatment.ID=@tr";
            sqlOperation.AddParameterWithValue("@tr", treatid);
            int intSuccess3 = sqlOperation.ExecuteNonQuery(strSqlCommand3);
            if (intSuccess > 0 && intSuccess3 > 0)
            {
                return true;
            }
            else
            {
                return false;
            }

        }
        else
        {
            if (intSuccess > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

    }


}
 