<%@ WebHandler Language="C#" Class="DesignReviewInfo" %>

using System;
using System.Web;
using System.Text;
using System.Collections.Generic;
public class DesignReviewInfo : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
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
    private string getfixrecordinfo(HttpContext context)
    {
        String designID = context.Request.QueryString["treatID"];

        int treatID = Convert.ToInt32(designID);
        string sqlCommand4 = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand4));
        string sqlCommand10 = "select Nameping from patient where patient.ID=@ID";
        sqlOperation.AddParameterWithValue("@ID", patientid);
        string pinyin = sqlOperation.ExecuteScalar(sqlCommand10);
        string sqlCommand11 = "select Radiotherapy_ID from patient where patient.ID=@ID";
        sqlOperation.AddParameterWithValue("@ID", patientid);
        string Radiotherapy_ID = sqlOperation.ExecuteScalar(sqlCommand11);
        string sqlCommand6 = "select bodyposition.Name from treatment,fixed,bodyposition where bodyposition.ID=fixed.BodyPosition and treatment.Fixed_ID =fixed.ID and treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        string posit = sqlOperation.ExecuteScalar(sqlCommand6);
        string sqlcommand5 = "select count(*) from childdesign where treatment_ID=@treatID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand5));
        int i = 1;
        string sqlCommand = "select design.ID as designid,Treatmentname,technology.name as tname,equipmenttype.type as eqname,raytype.Name as raytypename,plansystem.Name as planname,DosagePriority,childdesign.ID as childID,childdesign.* from technology,equipmenttype,design,childdesign,treatment,plansystem,raytype where raytype.ID=design.Raytype_ID and plansystem.ID=design.PlanSystem_ID and technology.ID=design.Technology_ID and equipmenttype.ID=design.Equipment_ID and design.ID=treatment.Design_ID and treatment.ID=childdesign.treatment_ID and treatment.ID=@treatid order by childdesign.ID desc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        StringBuilder backText = new StringBuilder("{\"designInfo\":[");
        //backText.Append(reader.Read());

        while (reader.Read())
        {
           
            
            string IRR = null;
            if (reader["Irradiation_ID"] is DBNull)
            {

                IRR = null;
            }
            else
            {
                string sqlCommand3 = "select Name from irradiation where ID=@Irradiation_ID";
                sqlOperation2.AddParameterWithValue("@Irradiation_ID", Convert.ToInt32(reader["Irradiation_ID"]).ToString());
                IRR = sqlOperation2.ExecuteScalar(sqlCommand3);
            }
            string energy = null;
            if (reader["energy"] is DBNull)
            {

                energy = null;
            }
            else
            {
                string sqlCommand3 = "select Name from energy where ID=@energy_ID";
                sqlOperation2.AddParameterWithValue("@energy_ID", Convert.ToInt32(reader["energy"]).ToString());
                energy = sqlOperation2.ExecuteScalar(sqlCommand3);
            }
            string left = "";
            string right = "";
            string rise = "";
            string drop = "";
            string enter = "";
            string out1 = "";
            if (!(reader["parameters"] is DBNull))
            {
                string parameters = reader["parameters"].ToString();
                string a1 = parameters.Split(new char[1] { ';' })[0];
                string a2 = parameters.Split(new char[1] { ';' })[1];
                string a3 = parameters.Split(new char[1] { ';' })[2];
                if (Convert.ToDouble(a1) >= 0 && a1 != "-0")
                {
                    left = a1;
                }
                else
                {
                    right = a1.Substring(1);
                }
                if (Convert.ToDouble(a2) >= 0 && a2 != "-0")
                {
                    rise = a2;
                }
                else
                {
                    drop = a2.Substring(1);
                }
                if (Convert.ToDouble(a3) >= 0 && a3 != "-0")
                {
                    enter = a3;
                }
                else
                {
                    out1 = a3.Substring(1);
                }
            }
            string Do = reader["DosagePriority"].ToString();
            string Priority = Do.Split(new char[1] { '&' })[0];
            string Dosage = Do.Split(new char[1] { '&' })[1];
            backText.Append("{\"technology\":\"" + reader["tname"].ToString() + "\",\"equipment\":\"" + reader["eqname"].ToString() + "\",\"PlanSystem\":\"" + reader["planname"].ToString() + "\",\"designID\":\"" + reader["designid"].ToString() + "\",\"DosagePriority\":\"" + Priority +
                  "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"Raytype\":\"" + reader["raytypename"].ToString() + "\",\"Coplanar1\":\"" + reader["Coplanar"].ToString() + "\",\"Irradiation1\":\"" + IRR + "\",\"energy1\":\"" + energy + "\",\"childDesign_ID\":\"" + reader["childID"].ToString() +
                   "\",\"IlluminatedNumber1\":\"" + reader["IlluminatedNumber"].ToString() + "\",\"Illuminatedangle1\":\"" + reader["Illuminatedangle"].ToString() + "\",\"item\":\"" + reader["item"].ToString() + "\",\"DesignName\":\"" + reader["DesignName"].ToString() +
                   "\",\"MU1\":\"" + reader["MachineNumbe"].ToString() + "\",\"ControlPoint1\":\"" + reader["ControlPoint"].ToString() + "\",\"positioninfomation1\":\"" + posit + "\",\"pinyin1\":\"" + pinyin + "\",\"radioID1\":\"" + Radiotherapy_ID +
                   "\",\"left\":\"" + left + "\",\"right\":\"" + right + "\",\"rise\":\"" + rise + "\",\"drop\":\"" + drop + "\",\"enter\":\"" + enter + "\",\"out\":\"" + out1 + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }

        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}