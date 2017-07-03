<%@ WebHandler Language="C#" Class="handlerEquipment" %>

using System;
using System.Web;

public class handlerEquipment : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        string type = context.Request.Form["formType"];
        if (type == "update")
        {
            Update(context);
        }
        else if (type == "insert")
        {
            Insert(context);
        }
        
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    /// <summary>
    /// 获取前台传来的设备信息修改，更新数据库equipment
    /// </summary>
    private void Update(HttpContext context)
    {
        //获取相应信息
        string equipmentID = context.Request.Form["equipID"];
        string equipmentName = context.Request.Form["equipmentName"];
        string equipmentState = context.Request.Form["equipmentState"];
        string onceTime = context.Request.Form["onceTime"];
        string AMbeg = context.Request.Form["AMbeg"];
        string AMEnd = context.Request.Form["AMEnd"];
        string PMBeg = context.Request.Form["PMBeg"];
        string PMEnd = context.Request.Form["PMEnd"];
        string type = context.Request.Form["equipmentType"];
        string treatmentItem = context.Request.Form["changeTreatmentItem"];
        //sql语句
        string sqlCommand = "UPDATE equipment SET Name=@Name,State=@State,Timelength=@Timelength," +
                            "BeginTimeAM=@BeginTimeAM,EndTimeAM=@EndTimeAM,BegTimePM=@BegTimePM," +
                            "EndTimeTPM=@EndTimeTPM,TreatmentItem=@TreatmentItem,EquipmentType=@type WHERE ID=@ID";
        //添加参数
        sqlOperation.AddParameterWithValue("@ID", Convert.ToInt32(equipmentID));
        sqlOperation.AddParameterWithValue("@Name", equipmentName);
        sqlOperation.AddParameterWithValue("@State", equipmentState);
        sqlOperation.AddParameterWithValue("@Timelength", Convert.ToInt32(onceTime));
        sqlOperation.AddParameterWithValue("@BeginTimeAM", TimeStringToInt(AMbeg));
        sqlOperation.AddParameterWithValue("@EndTimeAM", TimeStringToInt(AMEnd));
        sqlOperation.AddParameterWithValue("@BegTimePM", TimeStringToInt(PMBeg));
        sqlOperation.AddParameterWithValue("@EndTimeTPM", TimeStringToInt(PMEnd));
        sqlOperation.AddParameterWithValue("@TreatmentItem", treatmentItem);
        sqlOperation.AddParameterWithValue("@type", type);
        //执行
        sqlOperation.ExecuteNonQuery(sqlCommand);
        //成功提示
        MessageBox.Message("修改成功!");
    }

    private void Insert(HttpContext context)
    {
        string equipmentName = context.Request.Form["equipmentName"];
        string equipmentState = context.Request.Form["equipmentState"];
        string onceTime = context.Request.Form["onceTime"];
        string AMbeg = context.Request.Form["AMbeg"];
        string AMEnd = context.Request.Form["AMEnd"];
        string PMBeg = context.Request.Form["PMBeg"];
        string PMEnd = context.Request.Form["PMEnd"];
        string type = context.Request.Form["equipmentType"];
        string treatmentItem = context.Request.Form["changeTreatmentItem"];

        string sqlCommand = "INSERT INTO equipment(Name,State,Timelength,BeginTimeAM,EndTimeAM,BegTimePM,EndTimeTPM,TreatmentItem,EquipmentType)"
            + " VALUES(@Name,@State,@Timelength,@BeginTimeAM,@EndTimeAM,@BegTimePM,@EndTimeTPM,@TreatmentItem,@type)";
        sqlOperation.AddParameterWithValue("@Name", equipmentName);
        sqlOperation.AddParameterWithValue("@State", equipmentState);
        sqlOperation.AddParameterWithValue("@Timelength", Convert.ToInt32(onceTime));
        sqlOperation.AddParameterWithValue("@BeginTimeAM", TimeStringToInt(AMbeg));
        sqlOperation.AddParameterWithValue("@EndTimeAM", TimeStringToInt(AMEnd));
        sqlOperation.AddParameterWithValue("@BegTimePM", TimeStringToInt(PMBeg));
        sqlOperation.AddParameterWithValue("@EndTimeTPM", TimeStringToInt(PMEnd));
        sqlOperation.AddParameterWithValue("@TreatmentItem", treatmentItem);
        sqlOperation.AddParameterWithValue("@type", type);

        sqlOperation.ExecuteNonQuery(sqlCommand);
        //if (int.Parse(equipmentState) == 1)
        //{
        CreateAppointment(equipmentName, onceTime, AMbeg, AMEnd, PMBeg, PMEnd, treatmentItem);
        //}
        MessageBox.Message("新增成功!");
    }

    private void CreateAppointment(string name, string OnceTime, string AMbeg, string AMEnd, string PMBeg, string PMEnd, string treatmentItem)
    {
        sqlOperation.clearParameter();
        string sqlCommand = "SELECT ID FROM equipment WHERE Name=@name ORDER BY ID DESC";
        sqlOperation.AddParameterWithValue("@name", name);
        int id = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        int intAMBeg = TimeStringToInt(AMbeg);
        int intAMEnd = TimeStringToInt(AMEnd);
        int intPMBeg = TimeStringToInt(PMBeg);
        int intPMEnd = TimeStringToInt(PMEnd);

        int AMTime = intAMEnd - intAMBeg;
        int PMTime = intPMEnd - intPMBeg;

        int AMFrequency = AMTime / int.Parse(OnceTime);
        int PMFrequency = PMTime / int.Parse(OnceTime);

        sqlCommand = "INSERT INTO appointment(Task,Date,Equipment_ID,Begin,End,State) VALUES(@task,@date,@id,@begin,@end,0)";
        sqlOperation.AddParameterWithValue("@task", treatmentItem);
        sqlOperation.AddParameterWithValue("@id", id);
        for (int i = 0; i < 2; i++)
        {
            string Date = DateTime.Today.AddDays(i + 1).ToString();
            string day = Date.Split(' ')[0];
            sqlOperation.AddParameterWithValue("@date", day);
            for (int j = 0; j < AMFrequency; j++)
            {
                int begin = intAMBeg + (j * int.Parse(OnceTime));
                int end = begin + int.Parse(OnceTime);
                sqlOperation.AddParameterWithValue("@begin", begin);
                sqlOperation.AddParameterWithValue("@end", end);
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }

            for (int k = 0; k < PMFrequency; k++)
            {
                int Pbegin = intPMBeg + (k * int.Parse(OnceTime));
                int PEnd = intPMEnd + (k * int.Parse(OnceTime));
                sqlOperation.AddParameterWithValue("@begin", Pbegin);
                sqlOperation.AddParameterWithValue("@end", PEnd);
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
        }
    }
    
    /// <summary>
    /// 将时间转化成int，方便存入数据库
    /// </summary>
    /// <param name="time"></param>
    /// <returns></returns>
    public int TimeStringToInt(string time)
    {
        string[] timeArray = time.Split(':');
        int timeInt = Convert.ToInt32(timeArray[0]) * 60 + Convert.ToInt32(timeArray[1]);
        return timeInt;
    }

}