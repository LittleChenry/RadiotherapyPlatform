<%@ WebHandler Language="C#" Class="FieldConfirmInfo" %>

using System;
using System.Web;
using System.Text;
using System.Collections.Generic;
public class FieldConfirmInfo : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
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
    private string getfixrecordinfo(HttpContext context)
    {
        String designID = context.Request.QueryString["treatID"];

        int treatID = Convert.ToInt32(designID);
        
        string sqlCommand6 = "select positioninfomation from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        string posit = sqlOperation.ExecuteScalar(sqlCommand6);
        string sqlCommand7 = "select TPS from treatment where treatment.ID=@treatID";
        string tps = sqlOperation.ExecuteScalar(sqlCommand7);
        string sqlCommand11 = "select pinyin from treatment where treatment.ID=@treatID";
        string pinyin = sqlOperation.ExecuteScalar(sqlCommand11);
        string sqlCommand12 = "select radioID from treatment where treatment.ID=@treatID";
        string radioID = sqlOperation.ExecuteScalar(sqlCommand12);
        string sqlCommand8 = "select max(ID) from review";
        int review = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlCommand8));
        string remark="";
        if (review > 0)
        {
            string sqlCommand9 = "select Remark from review where ID=@review";
            sqlOperation.AddParameterWithValue("@review", review);
            remark = sqlOperation.ExecuteScalar(sqlCommand9);
        }
        string sqlcommand5 = "select count(*) from fieldinfomation where treatmentid=@treatID";
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand5));
        int i = 1;
        string sqlCommand = "select fieldinfomation.* from fieldinfomation where treatmentid=@treatID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        StringBuilder backText = new StringBuilder("{\"designInfo\":[");
        //backText.Append(reader.Read());

        while (reader.Read())
        {
            if (reader["radiotechnique"].ToString() == "Setup")
            {
                continue;
            }
            backText.Append("{\"plansystem2\":\"" + tps + "\",\"positioninfomation2\":\"" + posit + "\",\"dose2\":\"" + reader["Singledose"].ToString() + "/" + reader["Totaldose"].ToString() +
                   "\",\"Raytype2\":\"" + reader["radiotype"].ToString() + "\",\"Coplanar2\":\"" + reader["bedrotation"].ToString() + "\",\"Irradiation2\":\"" + reader["radiotechnique"].ToString() + "\",\"energy2\":\"" + reader["energy"].ToString() +
                   "\",\"IlluminatedNumber2\":\"" + count + "\",\"Illuminatedangle2\":\"" + reader["angleframe"].ToString() + "\",\"Equipment2\":\"" + reader["equipment"].ToString() +
                   "\",\"MU2\":\"" + reader["mu"].ToString() + "\",\"ControlPoint2\":\"" + reader["subfieldnumber"].ToString() + "\",\"remark\":\"" + remark + "\",\"pinyin2\":\"" + pinyin + "\",\"radioID2\":\"" + radioID + "\"}");
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