using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_DesignApply : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    
    protected void Page_Load(object sender, EventArgs e)
    {

     
        string myispostback = Request["ispostback"];//隐藏字段来标记是否为提交
        //不是第一次加载页面进行录入

        if (myispostback != null && myispostback == "true")
        {

            if (RecordPatientInformation())
            {
                sqlOperation.Close();
                sqlOperation.Dispose();
                sqlOperation = null;
                sqlOperation1.Close();
                sqlOperation1.Dispose();
                sqlOperation1 = null;
                sqlOperation2.Close();
                sqlOperation2.Dispose();
                sqlOperation2 = null;
                MessageBox.Message("保存成功!");

            }

            else
            {
                MessageBox.Message("保存失败");
            }
        }

    }

    private bool RecordPatientInformation()
    {

        string treatid = Request.Form["hidetreatID"];
        int treatID = Convert.ToInt32(treatid);
        //string userID = "1";
        string userID = Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;
        string aa = Request.Form["aa"]; 
        string bb = Request.Form["bb"];
        string maxnumber = "select max(ID) from design";
         string count = sqlOperation1.ExecuteScalar(maxnumber);
        int Count;
        if (count == "")
        {
            Count = 1;
        }
        else
        {
            Count = Convert.ToInt32(count) + 1;
        }
        string DosagePriority = "";
        int a1 = Convert.ToInt32(aa);
        int i = 0;
        while (i <= a1)
        {
            string ii = Convert.ToString(i);
            string Prioritytype = Request.Form["Prioritytype" + ii];
            string Priorityout = Request.Form["Priorityout" + ii];
            string Prioritptv = Request.Form["Prioritptv" + ii];
            string Prioritcgy = Request.Form["Prioritcgy" + ii];
            string Priorittime = Request.Form["Priorittime" + ii];
            string Prioritsum = Request.Form["Prioritsum" + ii];
            string Prioritremark = Request.Form["Prioritremark" + ii];
            string Priorit = Request.Form["Priorit" + ii];
            DosagePriority = DosagePriority + Prioritytype + "," + Priorityout + "," + Prioritptv + "," + Prioritcgy + "," + Priorittime + "," + Prioritsum + "," + Prioritremark + "," + Priorit + ";";
            i++;
        }
        int b1 = Convert.ToInt32(bb);
        int j = 0;
        DosagePriority = DosagePriority + "&";
        while (j <= b1)
        {
            string jj = Convert.ToString(j);
            string type = Request.Form["type" + jj];
            string dv = Request.Form["dv" + jj];
            string number = Request.Form["number" + jj];
            string prv = Request.Form["prv" + jj];
            string numbers = Request.Form["numbers" + jj];
            string pp = Request.Form["pp" + jj];
            DosagePriority = DosagePriority + type + "," + dv + "," + number + "," + prv + "," + numbers + "," + pp + ";";
            j++;
        }
        string strSqlCommand = "INSERT INTO Design(ID,RadiotherapyHistory,DosagePriority,Technology_ID,Equipment_ID,Application_User_ID,ApplicationTime) " +
                                "VALUES(@ID,@RadiotherapyHistory,@DosagePriority,@Technology_ID,@Equipment_ID,@Application_User_ID,@ApplicationTime)";
        sqlOperation.AddParameterWithValue("@ID", Count);
        sqlOperation.AddParameterWithValue("@RadiotherapyHistory", Request.Form["Remarks"]);
        sqlOperation.AddParameterWithValue("@Technology_ID", Convert.ToInt32(Request.Form["technology"]));
        sqlOperation.AddParameterWithValue("@Equipment_ID", Convert.ToInt32(Request.Form["equipment"]));
        sqlOperation.AddParameterWithValue("@DosagePriority", DosagePriority);
        sqlOperation.AddParameterWithValue("@ApplicationTime", datetime);
        sqlOperation.AddParameterWithValue("@Application_User_ID", userid);


        int intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);



        string inserttreat = "update treatment set Design_ID=@Design_ID,Progress=8 where ID=@treat";
        sqlOperation2.AddParameterWithValue("@Design_ID", Count);
        sqlOperation2.AddParameterWithValue("@treat", treatID);
        int Success = sqlOperation2.ExecuteNonQuery(inserttreat);

        if (intSuccess > 0 && Success > 0)
        {

            return true;
        }
        else
        {
            return false;
        }

    }
}