<%@ WebHandler Language="C#" Class="saveField" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class saveField : IHttpHandler {
    
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = RecordPatientInformation(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;           
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
        try
        {
            string treatid = context.Request.Form["hidetreatID"];
            int treatID = Convert.ToInt32(treatid);
            //string userID = "1";
            string userID = context.Request.Form["userID"];
            int userid = Convert.ToInt32(userID);
            DateTime datetime = DateTime.Now;
            string date1 = datetime.ToString();
            string item = context.Request.Form["item"];//获取子计划序号
            int item1 = Convert.ToInt32(item);
            string aa = context.Request.Form["aa"+item1];
            
            int a=Convert.ToInt32(aa);
            /*
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
             */          
            string select1 = "select Progress from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatID);
            string progress1 = sqlOperation.ExecuteScalar(select1);
            string[] group = progress1.Split(',');
            bool exists = ((IList)group).Contains("11");
            string select = "select Progress from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", treatID);
            string progress = sqlOperation.ExecuteScalar(select);
            string common = "select iscommon from treatment where ID=@treat";
            int iscommon = Convert.ToInt32(sqlOperation.ExecuteScalar(common));
            int Success = 0;
            int successs = 0;
            string childdesigns = "select count(*) from childdesign where treatment_ID=@treat and item=@item";
            sqlOperation.AddParameterWithValue("@item", item1);
            int count = int.Parse(sqlOperation.ExecuteScalar(childdesigns));
            bool existdesign = true;
            if (count == 0)
            {
                existdesign = false;
            }
            int intSuccess = 0;
            if (iscommon == 1)
            {
                string select5 = "select Design_ID from treatment where ID=@treat";
                sqlOperation.AddParameterWithValue("@treat", treatID);
                string designid = sqlOperation.ExecuteScalar(select5);
                
                string lr = "";
                string rd = "";
                string eo = "";
                if (context.Request.Form["left" + item] == "" || context.Request.Form["left" + item] == null)
                {
                    lr = "-" + context.Request.Form["right" + item];
                }
                else
                {
                    lr = context.Request.Form["left" + item];
                }
                if (context.Request.Form["rise" + item] == "" || context.Request.Form["rise" + item] == null)
                {
                    rd = "-" + context.Request.Form["drop" + item];
                }
                else
                {
                    rd = context.Request.Form["rise" + item];
                }
                if (context.Request.Form["enter" + item] == "" || context.Request.Form["enter" + item] == null)
                {
                    eo = "-" + context.Request.Form["out" + item];
                }
                else
                {
                    eo = context.Request.Form["enter" + item];
                }
                string para = lr + ";" + rd + ";" + eo;

                int number = Convert.ToInt32(context.Request.Form["IlluminatedNumber" + item]);
                string angle = "";
                for (int j = 1; j < number; j++)
                {
                    angle = angle + context.Request.Form["angle" + j+"_"+item] + ",";
                }
                angle = angle + context.Request.Form["angle" + number + "_" + item];
                if (existdesign)
                {
                    string childid = "select ID from childdesign where Treatment_ID=@Treatment_ID and item=@item";
                    sqlOperation.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation.AddParameterWithValue("@item", item1);
                    childid = sqlOperation.ExecuteScalar(childid);
                    string delete = "delete from fieldinfomation where childdesign_ID=@childdesign_ID";
                    sqlOperation1.AddParameterWithValue("@childdesign_ID", childid);
                    sqlOperation1.ExecuteNonQuery(delete);
                    string delete1 = "update childdesign set DesignName=@DesignName,Treatment_ID=@Treatment_ID,IlluminatedNumber=@IlluminatedNumber, Coplanar=@Coplanar,MachineNumbe=@MachineNumbe,ControlPoint=@ControlPoint,parameters=@parameters,Illuminatedangle=@Illuminatedangle,Irradiation_ID=@Irradiation_ID,energy=@energy,item=@item where ID=@childdesign_ID";
                    sqlOperation1.AddParameterWithValue("@childdesign_ID", childid);
                    sqlOperation1.AddParameterWithValue("@Irradiation_ID", Convert.ToInt32(context.Request.Form["Irradiation" + item]));
                    sqlOperation1.AddParameterWithValue("@IlluminatedNumber", Convert.ToInt32(context.Request.Form["IlluminatedNumber" + item]));
                    sqlOperation1.AddParameterWithValue("@Coplanar", Convert.ToInt32(context.Request.Form["Coplanar" + item]));
                    sqlOperation1.AddParameterWithValue("@energy", Convert.ToInt32(context.Request.Form["ener" + item]));
                    sqlOperation1.AddParameterWithValue("@MachineNumbe", Convert.ToDouble(context.Request.Form["MachineNumbe" + item]));
                    sqlOperation1.AddParameterWithValue("@Illuminatedangle", angle);
                    sqlOperation1.AddParameterWithValue("@parameters", para);
                    sqlOperation1.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation1.AddParameterWithValue("@item", item1);
                    sqlOperation1.AddParameterWithValue("@DesignName", context.Request.Form["DesignName" + item]);
                    sqlOperation1.AddParameterWithValue("@ControlPoint", Convert.ToInt32(context.Request.Form["ControlPoint" + item]));
                    successs = sqlOperation1.ExecuteNonQuery(delete1);
                }
                else
                {
                    string insert = "insert into childdesign (DesignName,Treatment_ID,IlluminatedNumber,Coplanar,MachineNumbe,ControlPoint,parameters,Illuminatedangle,Irradiation_ID,energy,item)values(@DesignName,@Treatment_ID,@IlluminatedNumber,@Coplanar,@MachineNumbe,@ControlPoint,@parameters,@Illuminatedangle,@Irradiation_ID,@energy,@item)";

                    sqlOperation1.AddParameterWithValue("@Irradiation_ID", Convert.ToInt32(context.Request.Form["Irradiation" + item]));
                    sqlOperation1.AddParameterWithValue("@IlluminatedNumber", Convert.ToInt32(context.Request.Form["IlluminatedNumber" + item]));
                    sqlOperation1.AddParameterWithValue("@Coplanar", Convert.ToInt32(context.Request.Form["Coplanar" + item]));
                    sqlOperation1.AddParameterWithValue("@energy", Convert.ToInt32(context.Request.Form["ener" + item]));
                    sqlOperation1.AddParameterWithValue("@MachineNumbe", Convert.ToDouble(context.Request.Form["MachineNumbe" + item]));
                    sqlOperation1.AddParameterWithValue("@Illuminatedangle", angle);
                    sqlOperation1.AddParameterWithValue("@parameters", para);
                    sqlOperation1.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation1.AddParameterWithValue("@item", item1);
                    sqlOperation1.AddParameterWithValue("@DesignName", context.Request.Form["DesignName" + item]);
                    sqlOperation1.AddParameterWithValue("@ControlPoint", Convert.ToInt32(context.Request.Form["ControlPoint" + item]));
                    successs = sqlOperation1.ExecuteNonQuery(insert);
                    string childid2 = "select ID from childdesign where Treatment_ID=@Treatment_ID and item=@item";
                    sqlOperation.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation.AddParameterWithValue("@item", item1);
                    childid2 = sqlOperation.ExecuteScalar(childid2);
                    string selec = "select Splitway_ID from treatment where ID=@treatID";
                    sqlOperation.AddParameterWithValue("@treatID", treatID);
                    string Splitway = sqlOperation.ExecuteScalar(selec);
                    string update1 = "update childdesign set Splitway_ID=@Splitway_ID where ID=@ID";
                    sqlOperation.AddParameterWithValue("@ID", childid2);
                    sqlOperation.AddParameterWithValue("@Splitway_ID", Splitway);
                    sqlOperation.ExecuteNonQuery(update1);
                }
                string childid1 = "select ID from childdesign where Treatment_ID=@Treatment_ID and item=@item";
                sqlOperation.AddParameterWithValue("@Treatment_ID", treatID);
                sqlOperation.AddParameterWithValue("@item", item1);
                childid1 = sqlOperation.ExecuteScalar(childid1);
                
               
                for (int i = 0; i < a; i++)
                {
                    string strSqlCommand = "INSERT INTO fieldinfomation(code,mu,equipment,radiotechnique,radiotype,energy,wavedistance,angleframe,noseangle,bedrotation,subfieldnumber,User_ID,Operate_Time,treatmentid,Singledose,Totaldose,guangxianLeft,guangxianRight,childdesign_ID) " +
                                            "VALUES(@code,@mu,@equipment,@radiotechnique,@radiotype,@energy,@wavedistance,@angleframe,@noseangle,@bedrotation,@subfieldnumber,@User_ID,@Operate_Time,@treatmentid,@Singledose,@Totaldose,@guangxianLeft,@guangxianRight,@childdesign_ID)";
                    // sqlOperation.AddParameterWithValue("@ID", Count);
                    sqlOperation.AddParameterWithValue("@code", context.Request.Form["a1" + i+"_"+item]);
                    sqlOperation.AddParameterWithValue("@mu", context.Request.Form["mu" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@equipment", context.Request.Form["equipment" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@radiotechnique", context.Request.Form["technology" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@radiotype", context.Request.Form["type" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@energy", context.Request.Form["energyField" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@wavedistance", context.Request.Form["ypj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@angleframe", context.Request.Form["jjj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@noseangle", context.Request.Form["jtj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@bedrotation", context.Request.Form["czj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@subfieldnumber", context.Request.Form["childs" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@Singledose", Convert.ToInt32(context.Request.Form["Graded" + item]));
                    sqlOperation.AddParameterWithValue("@Totaldose", Convert.ToInt32(context.Request.Form["total" + item]));
                    sqlOperation.AddParameterWithValue("@guangxianLeft", context.Request.Form["xianLeft" + item]);
                    sqlOperation.AddParameterWithValue("@guangxianRight", context.Request.Form["xianRight" + item]);
                    sqlOperation.AddParameterWithValue("@Operate_Time", date1);
                    sqlOperation.AddParameterWithValue("@treatmentid", treatID);
                    sqlOperation.AddParameterWithValue("@User_ID", userid);
                    sqlOperation.AddParameterWithValue("@childdesign_ID", childid1);
                    intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
                    if (intSuccess == 0) { break; }
                }
            }
            else
            {
                string lr = "";
                string rd = "";
                string eo = "";
                if (context.Request.Form["left" + item] == "" || context.Request.Form["left" + item] == null)
                {
                    lr = "-" + context.Request.Form["right" + item];
                }
                else
                {
                    lr = context.Request.Form["left" + item];
                }
                if (context.Request.Form["rise" + item] == "" || context.Request.Form["rise" + item] == null)
                {
                    rd = "-" + context.Request.Form["drop" + item];
                }
                else
                {
                    rd = context.Request.Form["rise" + item];
                }
                if (context.Request.Form["enter" + item] == "" || context.Request.Form["enter" + item] == null)
                {
                    eo = "-" + context.Request.Form["out" + item];
                }
                else
                {
                    eo = context.Request.Form["enter" + item];
                }
                string para = lr + ";" + rd + ";" + eo;
                if (existdesign)
                {
                    string childid = "select ID from childdesign where Treatment_ID=@Treatment_ID and item=@item";
                    sqlOperation.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation.AddParameterWithValue("@item", item1);
                    childid = sqlOperation.ExecuteScalar(childid);
                    string delete = "delete from fieldinfomation where childdesign_ID=@childdesign_ID";
                    sqlOperation1.AddParameterWithValue("@childdesign_ID", childid);
                    sqlOperation1.ExecuteNonQuery(delete);
                    string delete1 = "update childdesign set DesignName=@DesignName,Treatment_ID=@Treatment_ID,parameters=@parameters,item=@item where ID=@childdesign_ID";
                    sqlOperation1.AddParameterWithValue("@childdesign_ID", childid);
                    sqlOperation1.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation1.AddParameterWithValue("@item", item1);
                    sqlOperation1.AddParameterWithValue("@parameters", para);
                    sqlOperation1.AddParameterWithValue("@DesignName", context.Request.Form["DesignName" + item]);
                    successs = sqlOperation1.ExecuteNonQuery(delete1);
                }
                else
                {
                    string insert = "insert into childdesign (state,DesignName,Treatment_ID,item,parameters)values(@state,@DesignName,@Treatment_ID,@item,@parameters)";
                    sqlOperation1.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation1.AddParameterWithValue("@item", item1);
                    sqlOperation1.AddParameterWithValue("@state", 2);
                    sqlOperation1.AddParameterWithValue("@parameters", para);
                    sqlOperation1.AddParameterWithValue("@DesignName", context.Request.Form["DesignName" + item]);
                    successs = sqlOperation1.ExecuteNonQuery(insert);
                    string childid2 = "select ID from childdesign where Treatment_ID=@Treatment_ID and item=@item";
                    sqlOperation.AddParameterWithValue("@Treatment_ID", treatID);
                    sqlOperation.AddParameterWithValue("@item", item1);
                    childid2 = sqlOperation.ExecuteScalar(childid2);
                    string selec = "select Splitway_ID from treatment where ID=@treatID";
                    sqlOperation.AddParameterWithValue("@treatID", treatID);
                    string Splitway = sqlOperation.ExecuteScalar(selec);
                    string update1 = "update childdesign set Splitway_ID=@Splitway_ID where ID=@ID";
                    sqlOperation.AddParameterWithValue("@ID", childid2);
                    sqlOperation.AddParameterWithValue("@Splitway_ID", Splitway);
                    sqlOperation.ExecuteNonQuery(update1);
                }
                string childid1 = "select ID from childdesign where Treatment_ID=@Treatment_ID and item=@item";
                sqlOperation.AddParameterWithValue("@Treatment_ID", treatID);
                sqlOperation.AddParameterWithValue("@item", item1);
                childid1 = sqlOperation.ExecuteScalar(childid1);
                for (int i = 0; i < a; i++)
                {
                    string strSqlCommand = "INSERT INTO fieldinfomation(code,mu,equipment,radiotechnique,radiotype,energy,wavedistance,angleframe,noseangle,bedrotation,subfieldnumber,User_ID,Operate_Time,treatmentid,Singledose,Totaldose,guangxianLeft,guangxianRight,childdesign_ID) " +
                                            "VALUES(@code,@mu,@equipment,@radiotechnique,@radiotype,@energy,@wavedistance,@angleframe,@noseangle,@bedrotation,@subfieldnumber,@User_ID,@Operate_Time,@treatmentid,@Singledose,@Totaldose,@guangxianLeft,@guangxianRight,@childdesign_ID)";
                    // sqlOperation.AddParameterWithValue("@ID", Count);
                    sqlOperation.AddParameterWithValue("@code", context.Request.Form["a1" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@mu", context.Request.Form["mu" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@equipment", context.Request.Form["equipment" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@radiotechnique", context.Request.Form["technology" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@radiotype", context.Request.Form["type" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@energy", context.Request.Form["energyField" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@wavedistance", context.Request.Form["ypj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@angleframe", context.Request.Form["jjj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@noseangle", context.Request.Form["jtj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@bedrotation", context.Request.Form["czj" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@subfieldnumber", context.Request.Form["childs" + i + "_" + item]);
                    sqlOperation.AddParameterWithValue("@Singledose", Convert.ToInt32(context.Request.Form["Graded" + item]));
                    sqlOperation.AddParameterWithValue("@Totaldose", Convert.ToInt32(context.Request.Form["total" + item]));
                    sqlOperation.AddParameterWithValue("@guangxianLeft", context.Request.Form["xianLeft" + item]);
                    sqlOperation.AddParameterWithValue("@guangxianRight", context.Request.Form["xianRight" + item]);
                    sqlOperation.AddParameterWithValue("@Operate_Time", date1);
                    sqlOperation.AddParameterWithValue("@treatmentid", treatID);
                    sqlOperation.AddParameterWithValue("@User_ID", userid);
                    sqlOperation.AddParameterWithValue("@childdesign_ID", childid1);
                    intSuccess = sqlOperation.ExecuteNonQuery(strSqlCommand);
                    if (intSuccess == 0) { break; }
                }
                
            }
            if (!exists)
            {
                string inserttreat = "update treatment set Progress=@progress,TPS=@TPS,positioninfomation=@positioninfomation,pinyin=@pinyin,radioID=@radioid where ID=@treat";
                if (iscommon == 1)
                {
                    sqlOperation2.AddParameterWithValue("@progress", progress + ",11");
                }
                else
                {
                    sqlOperation2.AddParameterWithValue("@progress", progress + ",11,12");
                }
                sqlOperation2.AddParameterWithValue("@TPS", context.Request.Form["tps" + item]);
                sqlOperation2.AddParameterWithValue("@pinyin", context.Request.Form["pingyin" + item]);
                sqlOperation2.AddParameterWithValue("@radioid", context.Request.Form["id" + item]);
                sqlOperation2.AddParameterWithValue("@positioninfomation", context.Request.Form["pos" + item]);
                sqlOperation2.AddParameterWithValue("@treat", treatID);
                Success = sqlOperation2.ExecuteNonQuery(inserttreat);
            }
            else
            {
                string inserttreat = "update treatment set TPS=@TPS,positioninfomation=@positioninfomation,pinyin=@pinyin,radioID=@radioid where ID=@treat";
                string ppp = context.Request.Form["id" + item];
                if (ppp == "")
                {
                    ppp = "0";
                }
                       
                sqlOperation2.AddParameterWithValue("@TPS", context.Request.Form["tps" + item]);
                sqlOperation2.AddParameterWithValue("@pinyin", context.Request.Form["pingyin" + item]);
                sqlOperation2.AddParameterWithValue("@radioid", ppp);
                sqlOperation2.AddParameterWithValue("@positioninfomation", context.Request.Form["pos" + item]);
                sqlOperation2.AddParameterWithValue("@treat", treatID);
                Success = sqlOperation2.ExecuteNonQuery(inserttreat);
            }                
            if (intSuccess>0&& Success > 0 && successs > 0)
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
