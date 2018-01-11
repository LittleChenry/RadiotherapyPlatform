<%@ WebHandler Language="C#" Class="Gettreatmentreviewapply" %>

using System;
using System.Web;
using System.Text;

public class Gettreatmentreviewapply : IHttpHandler {
     DataLayer sqlOperation = new DataLayer("sqlStr");
     public void ProcessRequest(HttpContext context)
     {
         context.Response.ContentType = "text/plain";
         string backString = gettreatmentreview(context);
         sqlOperation.Close();
         sqlOperation.Dispose();
         sqlOperation = null;
         context.Response.Write(backString);
     }

     public bool IsReusable
     {
         get
         {
             return false;
         }
     }
     private string gettreatmentreview(HttpContext context)
     {
         string treatid = context.Request.QueryString["treatmentID"];
         string appointid = context.Request.QueryString["appointid"];

         string sqlCommand = "SELECT operateuser,equipment.Name as equipname,Begin,End,appointment.Date as appointdate,scanpart,scanmethod,up,down,enhance,enhancemethod,specialrequest,applyremark from treatmentreview,equipment,appointment where treatmentreview.appoint_ID=appointment.ID and appointment.Equipment_ID and treatmentid=@treatmentid and appoint_ID=@appoint";
         sqlOperation.AddParameterWithValue("@treatmentid", treatid);
         sqlOperation.AddParameterWithValue("@appoint", appointid);
         MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
         StringBuilder backText = new StringBuilder("{\"Item\":[");
         if(reader.Read())
         {
             backText.Append("{\"scanpart\":\"" + reader["scanpart"].ToString() + "\",\"scanmethod\":\"" + reader["scanmethod"].ToString() + "\",\"operateuser\":\"" + reader["operateuser"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Date\":\"" + reader["appointdate"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"up\":\"" + reader["up"].ToString() + "\",\"down\":\"" + reader["down"].ToString() + "\",\"enhance\":\"" + reader["enhance"].ToString() + "\",\"enhancemethod\":\"" + reader["enhancemethod"].ToString() + "\",\"specialrequest\":\"" + reader["specialrequest"].ToString() + "\",\"applyremark\":\"" + reader["applyremark"].ToString() + "\"}");
            
         }
         backText.Append("]}");
         return backText.ToString();
     }

}