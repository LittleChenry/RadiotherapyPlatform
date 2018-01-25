<%@ WebHandler Language="C#" Class="geteuqipmenttype" %>

using System;
using System.Web;

public class geteuqipmenttype : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getprinItem(HttpContext context)
    {
        string treatid = context.Request.QueryString["treatmentID"];
        string equip = "";
        string selectequipmentcommand = "select fieldinfomation.equipment as equip from childdesign,fieldinfomation,treatment where fieldinfomation.ChildDesign_ID=childdesign.ID and childdesign.Treatment_ID=treatment.ID and  treatment.ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectequipmentcommand);
        if (reader.Read())
        {
            equip = reader["equip"].ToString();
        }
        reader.Close();
        string euipid = "";
        if (equip != "")
        {
            string sqlCommand = "SELECT ID from equipmenttype where Type like @equip";
            sqlOperation.AddParameterWithValue("@equip", '%'+equip+'%');
            euipid = sqlOperation.ExecuteScalar(sqlCommand);
        }

        return euipid;
    }

}