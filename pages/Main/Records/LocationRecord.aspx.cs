using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class pages_Main_Records_LocationRecord : System.Web.UI.Page
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation3 = new DataLayer("sqlStr");
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
        string savePath = "";
        string savepath1 = "";

        HttpFileCollection files = HttpContext.Current.Request.Files;
        savePath = Server.MapPath("~/upload/LocationRecord");

        if (!System.IO.Directory.Exists(savePath))
        {
            System.IO.Directory.CreateDirectory(savePath);
        }
        savePath = savePath + "\\";
        try
        {
            for (int i = 0; i < files.Count; i++)
            {
                System.Web.HttpPostedFile postedFile = files[i];
                string fileName = postedFile.FileName;//完整的路径
                fileName = System.IO.Path.GetFileName(postedFile.FileName); //获取到名称
                string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
                string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
                if (files[i].ContentLength > 0)
                {
                    files[i].SaveAs(savePath + DateTime.Now.ToString("yyyyMMdd") + fileName);
                    savepath1 = savepath1 + "," + "../../../upload/LocationRecord/" + DateTime.Now.ToString("yyyyMMdd") + fileName;

                }
            }
        }
        catch (System.Exception Ex)
        {
            Response.Write(Ex);
        }
        string treatid = Request.Form["hidetreatID"];
        int treatID = Convert.ToInt32(treatid);
        string locationid = "select Location_ID from treatment where treatment.ID=@treatid";
        sqlOperation.AddParameterWithValue("@treatid", treatID);
        int LocationID = int.Parse(sqlOperation.ExecuteScalar(locationid));
        //string userID = "1";
        string userID = Request.Form["userID"];
        int userid = Convert.ToInt32(userID);
        DateTime datetime = DateTime.Now;
        //bool state = false;
        string strSqlCommand = "UPDATE  location  SET CT_ID=@locationID,CTPictures=@picture,Thickness=@thickness,Number=@number,ReferenceNumber=@ReferenceNumber,ReferenceScale=@ReferenceScale,OperateTime=@datetime,Operate_User_ID=@userid where location.ID=@locationID";
        //各参数赋予实际值
        sqlOperation.AddParameterWithValue("@locationID", LocationID);
        sqlOperation.AddParameterWithValue("@thickness", Request.Form["Thickness"]);
        sqlOperation.AddParameterWithValue("@number", Request.Form["Number"]);
        sqlOperation.AddParameterWithValue("@ReferenceNumber", Request.Form["ReferenceNumber"]);
        sqlOperation.AddParameterWithValue("@ReferenceScale", Request.Form["ReferenceScale"]);
        sqlOperation.AddParameterWithValue("@datetime", datetime);
        sqlOperation.AddParameterWithValue("@userid", userid);
        sqlOperation.AddParameterWithValue("@picture", savepath1);
        int intSuccess1 = sqlOperation.ExecuteNonQuery(strSqlCommand);
        string strSqlCommand1 = "UPDATE  appointment  SET Completed=@state where Treatment_ID=@treat and Task='模拟定位'";
        sqlOperation1.AddParameterWithValue("@state", 1);
        sqlOperation1.AddParameterWithValue("@treat", treatID);
        int intSuccess2 = sqlOperation1.ExecuteNonQuery(strSqlCommand1);
        string strSqlCommand2 = "INSERT INTO ct(ID) VALUES(@loc)";
        sqlOperation2.AddParameterWithValue("@loc", LocationID);
        int intSuccess = sqlOperation2.ExecuteNonQuery(strSqlCommand2);
        string strSqlCommand3 = "UPDATE  treatment  SET Progress=@Progress where Treatment.ID=@tr";
        sqlOperation3.AddParameterWithValue("@Progress", 6);
        sqlOperation3.AddParameterWithValue("@tr", treatID);
        int intSuccess3 = sqlOperation3.ExecuteNonQuery(strSqlCommand3);
        if (intSuccess > 0 && intSuccess1 > 0 && intSuccess2 > 0 && intSuccess3 > 0)
        {            
            return true;
        }
        else
        {
            return false;
        }

    }
}