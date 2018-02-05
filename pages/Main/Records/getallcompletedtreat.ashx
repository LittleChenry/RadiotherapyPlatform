<%@ WebHandler Language="C#" Class="getallcompletedtreat" %>

using System;
using System.Web;
using System.Text;

public class getallcompletedtreat : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = patientfixInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string patientfixInformation(HttpContext context)
    {
        int radiotherapyid = Convert.ToInt32(context.Request["Radiotherapy_ID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        string sqlCommand = "select ID from patient where Radiotherapy_ID=@radio";
        sqlOperation.AddParameterWithValue("@radio", radiotherapyid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));

        string sqlcommand2 = "select count(*) from treatment where Patient_ID=@patient";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));

        StringBuilder backText = new StringBuilder("{\"treatinfo\":[");
        int i = 1;
        string sqlCommand2 = "select * from treatment where Patient_ID=@patient";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand2);
        while (reader.Read())
        {
            string fix="";
            string location = "";
            string design = "";
            string replace = "";
            string diagnosecomplete = "";
            string fixcomplete = "";
            string locationcomplete = "";
            string designcomplete = "";
            string replacecomplete = "";
            string rigester = "";
            string sqlCommand6 = "select patient.*,user.Name as username from user,patient where patient.RegisterDoctor=user.ID and patient.Radiotherapy_ID=@radio";
            sqlOperation1.AddParameterWithValue("@radio", radiotherapyid);
            MySql.Data.MySqlClient.MySqlDataReader reader4 = sqlOperation1.ExecuteReader(sqlCommand6);
            if (reader4.Read())
            {
                string sex="";
                if(reader4["Gender"].ToString()=="M")
                {
                    sex="男";
                }else
                {
                    sex="女";
                }
                rigester = "姓名：" + reader4["Name"].ToString() + "。性别：" + sex + "。年龄：" + reader4["Age"].ToString() + "。所属医生：" + reader4["username"].ToString();

            }
            reader4.Close();
            if(reader["DiagnosisRecord_ID"].ToString() != "")
            {  
                string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                string result = sqlOperation1.ExecuteScalar(sqlCommand3);
                string sqlCommand4 = "select Groupfirst from diagnosisrecord,morphol where diagnosisrecord.ID=@ID and diagnosisrecord.PathologyResult =morphol.ID";
                string result1 = sqlOperation1.ExecuteScalar(sqlCommand4);
                string commandtemp = "select user.Name as username,Part_ID,LightPart_ID,treataim.Aim as aim,DiagnosisResult_ID,Remarks from user,diagnosisrecord,treataim where treataim.ID=diagnosisrecord.TreatAim_ID  and diagnosisrecord.Diagnosis_User_ID=user.ID and diagnosisrecord.ID=@diag";
                sqlOperation1.AddParameterWithValue("@diag",Convert.ToInt32(reader["DiagnosisRecord_ID"].ToString()));
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(commandtemp);
                if(reader1.Read())
                {
                    diagnosecomplete = "患病部位：" + reader1["Part_ID"].ToString() + "。病情诊断结果：" + result + "。病理诊断结果：" + result1 + "。照射部位：" + reader1["LightPart_ID"].ToString() + "。治疗目标：" + reader1["aim"].ToString() + "。诊断备注：" + reader1["Remarks"].ToString(); 
                }
                reader1.Close();
            }
            
            if (reader["Fixed_ID"].ToString() != "")
            {
                string sqlCommand3 = "select Operate_User_ID from fixed where ID=@fix";
                sqlOperation1.AddParameterWithValue("@fix", Convert.ToInt32(reader["Fixed_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                if (user == "")
                {
                    fix = "";
                }
                else
                {
                    fix = reader["Fixed_ID"].ToString();
                    string commandtemp = "select material.Name as mname,fixedequipment.Name as fename,fixedrequirements.Requirements as requirements,BodyPosition,fixed.Remarks as remark from material,fixedrequirements,fixed,fixedequipment where fixedequipment.ID=fixed.FixedEquipment_ID and fixed.Model_ID=material.ID and fixed.FixedRequirements_ID=fixedrequirements.ID and fixed.ID=@fix";
                    sqlOperation1.AddParameterWithValue("@fix",Convert.ToInt32(reader["Fixed_ID"].ToString()));
                     MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(commandtemp);
                    if(reader1.Read())
                   {
                       fixcomplete = "模具：" + reader1["mname"].ToString() + "。特殊要求：" + reader1["requirements"].ToString() + "。固定装置：" + reader1["fename"].ToString() + "。体位：" + reader1["BodyPosition"].ToString() + "。备注：" + reader1["remark"].ToString(); 
                  }
                   reader1.Close(); 
                }
            }
            if (reader["Location_ID"].ToString() != "")
            {
                string sqlCommand3 = "select Operate_User_ID from location where ID=@location";
                sqlOperation1.AddParameterWithValue("@location", Convert.ToInt32(reader["Location_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                string sqlCommand4 = "select CT_ID from location where ID=@location";
                string ct = sqlOperation1.ExecuteScalar(sqlCommand4);
                if (user == "" || ct=="")
                {
                    location = "";
                }
                else
                {
                    location = reader["Location_ID"].ToString();
                    string commandtemp = "select ScanPart_ID,scanmethod.Method as scanmethod,locationrequirements.Requirements as locationrequire,UpperBound,LowerBound,Enhance,location.EnhanceMethod_ID as enhancemethod,location.Remarks as remarklocate,location.Thickness as Thick,location.Number as num,location.ReferenceNumber as refer1,location.ReferenceScale as refer2,densityconversion.Name as ctdes,ct.SequenceNaming as ctseq,ct.MultimodalImage as ctmul,ct.Remarks as ctremarks from location,scanmethod,locationrequirements,enhancemethod,ct,densityconversion where location.CT_ID=ct.ID and location.ID=@locateid and ct.DensityConversion_ID=densityconversion.ID and location.ScanMethod_ID=scanmethod.ID  and location.LocationRequirements_ID=locationrequirements.ID";
                     sqlOperation1.AddParameterWithValue("@locateid",Convert.ToInt32(reader["Location_ID"].ToString()));
                     MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(commandtemp);
                    if(reader1.Read())
                   {
                        string enmethod="";
                        string zengqiang="是";
                        if (reader1["Enhance"].ToString() == "0")
                       {

                             enmethod = "无";
                            zengqiang="否";
                        }
                        else
                      {
                            string sqlCommand5= "select Method from enhancemethod where ID=@enhancemethod";
                            sqlOperation2.AddParameterWithValue("@enhancemethod", Convert.ToInt32(reader1["enhancemethod"].ToString()));
                            enmethod = sqlOperation2.ExecuteScalar(sqlCommand5);

                       }
                        locationcomplete = "扫描部位：" + reader1["ScanPart_ID"].ToString() + "。扫描方式：" + reader1["scanmethod"].ToString() + "。特殊要求：" + reader1["locationrequire"].ToString() + "。扫描上界：" + reader1["UpperBound"].ToString() + "。扫描下界：" + reader1["LowerBound"].ToString() + "。是否增强：" + zengqiang + "。增强方式：" + enmethod + "。定位备注：" + reader1["remarklocate"].ToString() + "。层厚：" + reader1["Thick"].ToString() + "。层数：" + reader1["num"].ToString() + "。参考中心层面：" + reader1["refer1"].ToString() + "。体表参考刻度：" + reader1["refer2"].ToString() + "。CT密度转换方式：" + reader1["ctseq"].ToString() + "。CT序列命名：" + reader1["ctseq"].ToString() + "。CT多模态图像：" + reader1["ctmul"].ToString() + "。CT备注：" + reader1["ctremarks"].ToString(); 
                  }
                   reader1.Close();     
                }
            }
            if (reader["Review_ID"].ToString() != "")
            {
                string sqlCommand3 = "select _User_ID from review where ID=@review";
                sqlOperation1.AddParameterWithValue("@review", Convert.ToInt32(reader["Review_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                if (user == "")
                {
                    design = "";
                }
                else
                {
                     design = reader["Design_ID"].ToString();
                    string commandtemp = "select design.*,technology.Name as tename,equipmenttype.Type as eqname,plansystem.Name as planname,algorithm.Name as alname,grid.Name as gridname,review.* from design,algorithm,grid,equipmenttype,plansystem,technology,review where design.ID=@designid and algorithm.ID=design.Algorithm_ID and grid.ID=design.Grid_ID and equipmenttype.ID=design.Equipment_ID and plansystem.ID=design.Plansystem_ID and technology.ID=design.Technology_ID and review.ID=@reviewid";
                    sqlOperation1.AddParameterWithValue("@reviewid", Convert.ToInt32(reader["Review_ID"].ToString()));
                    sqlOperation1.AddParameterWithValue("@designid", Convert.ToInt32(reader["Design_ID"].ToString()));
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(commandtemp);
                    if (reader1.Read())
                    {
                       string Do = reader1["DosagePriority"].ToString();
                       string Priority = Do.Split(new char[1] { '&' })[0];
                       string Dosage = Do.Split(new char[1] { '&' })[1];
                        designcomplete ="特殊情况放疗史：" +reader1["RadiotherapyHistory"].ToString()+"。靶区处方剂量：" +Priority+"。危及器官限量：" +Dosage+"。治疗技术：" +reader1["tename"].ToString()+"。放疗设备：" +reader1["eqname"].ToString() 
                            +"。计划系统：" +reader1["planname"].ToString()+"。射野数量：" +reader1["IlluminatedNumber"].ToString()+"。非共面照射：" +reader1["Coplanar"].ToString()+"。机器跳数：" +reader1["MachineNumbe"].ToString()+"。控制点数量：" +reader1["ControlPoint"].ToString()+"。计算网络：" +reader1["gridname"].ToString()              
                            +"。优化算法：" +reader1["alname"].ToString()+"。计划可执行度：" +reader1["Feasibility"].ToString();
                    
                  } 
                    reader1.Close(); 
                }
            }
            if (reader["Replacement_ID"].ToString() != "")
            {
                string sqlCommand3 = "select Operate_User_ID from replacement where ID=@replace";
                sqlOperation1.AddParameterWithValue("@replace", Convert.ToInt32(reader["Replacement_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                if (user == "")
                {
                    replace = "";
                }
                else
                {
                    replace = reader["Replacement_ID"].ToString();
                     string commandtemp = "select replacementrequirements.Requirements as replacerequire,replacement.* from replacement,replacementrequirements where replacement.ReplacementRequirements_ID=replacementrequirements.ID and replacement.ID=@replace";
                    sqlOperation1.AddParameterWithValue("@replace", Convert.ToInt32(reader["Replacement_ID"].ToString()));
                    MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(commandtemp);
                    if (reader1.Read())
                    {
                       
                        replacecomplete ="复位要求：" +reader1["replacerequire"].ToString()+"。原始中心：" +reader1["OriginCenter"].ToString() 
                            +"。计划中心：" +reader1["PlanCenter"].ToString()+"。移床参数：" +reader1["Movement"].ToString()+"。复位结果：" +reader1["Result"].ToString()+"。复位差值：" +reader1["Distance"].ToString();
              
                  } 
                    reader1.Close(); 
   
                }
            }

            backText.Append("{\"diagnose\":\"" + reader["DiagnosisRecord_ID"].ToString() + "\",\"fixed\":\"" + fix + "\",\"fixed\":\"" + fix + "\",\"location\":\"" + location + "\",\"design\":\"" + "" + "\",\"replace\":\"" + replace + "\",\"treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"review\":\"" + "" + "\",\"group\":\"" + reader["Group_ID"].ToString() + "\",\"diagnosecomplete\":\"" + diagnosecomplete + "\",\"fixcomplete\":\"" + fixcomplete + "\",\"locationcomplete\":\"" + locationcomplete + "\",\"designcomplete\":\"" + designcomplete + "\",\"replacecomplete\":\"" + replacecomplete + "\",\"rigester\":\"" + rigester + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1= null;
         sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2= null;
        return backText.ToString();
    }

}