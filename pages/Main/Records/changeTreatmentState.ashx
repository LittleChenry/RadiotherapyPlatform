<%@ WebHandler Language="C#" Class="changeTreatmentState" %>

using System;
using System.Web;
using System.Text;
public class changeTreatmentState : IHttpHandler {
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);      
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
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
            String state = context.Request.QueryString["state"];
            String treatID = context.Request.QueryString["treatID"];
            if (state != "0")
            {
                string selectallappoint = "select ID,Task,ischecked from appointment where Treatment_ID=@treat and Completed is NULL";
                sqlOperation2.AddParameterWithValue("@treat", treatID);
                MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(selectallappoint);
               while(reader.Read())
                {
                    if (reader["Task"].ToString() == "体位固定")
                    {
                        string changestate = "update appointment set Patient_ID=@Patient_ID,State=0,Treatment_ID=@Treatment_ID where ID=@appoint";
                        sqlOperation1.AddParameterWithValue("@appoint", reader["ID"].ToString());
                        sqlOperation1.AddParameterWithValue("@Treatment_ID",null);
                        sqlOperation1.AddParameterWithValue("@Patient_ID", null);
                        sqlOperation1.ExecuteNonQuery(changestate);
                        string deletefix = "update fixed set Appointment_ID=@empappoint where Appointment_ID=@appoint";
                        sqlOperation1.AddParameterWithValue("@empappoint", null);
                        sqlOperation1.ExecuteNonQuery(deletefix);
                        
                    }
                    if (reader["Task"].ToString() == "模拟定位" && reader["ischecked"].ToString() == "0")
                    {
                        string changestate = "update appointment set Patient_ID=@Patient_ID,State=0,Treatment_ID=@Treatment_ID where ID=@appoint";
                        sqlOperation1.AddParameterWithValue("@appoint", reader["ID"].ToString());
                        sqlOperation1.AddParameterWithValue("@Treatment_ID", null);
                        sqlOperation1.AddParameterWithValue("@Patient_ID", null);
                        sqlOperation1.ExecuteNonQuery(changestate);
                        string deletelocation = "update location set Appointment_ID=@empappoint where Appointment_ID=@appoint";
                        sqlOperation1.AddParameterWithValue("@empappoint", null);
                        sqlOperation1.ExecuteNonQuery(deletelocation);

                    }
                    if (reader["Task"].ToString() == "模拟定位" && reader["ischecked"].ToString() == "1")
                    {
                        string changestate = "update appointment set Patient_ID=@Patient_ID,State=0,ischecked=0,Treatment_ID=@Treatment_ID where ID=@appoint";
                        sqlOperation1.AddParameterWithValue("@appoint", reader["ID"].ToString());
                        sqlOperation1.AddParameterWithValue("@Treatment_ID", null);
                        sqlOperation1.AddParameterWithValue("@Patient_ID", null);
                        sqlOperation1.ExecuteNonQuery(changestate);
                        string deletetreatreview = "delete from treatmentreview where appoint_ID=@appoint";
                        sqlOperation1.ExecuteNonQuery(deletetreatreview);

                    }
                   
                }
               reader.Close();
               string selectallaccerappoint = "select ID from appointment_accelerate where Treatment_ID=@treat and Completed=0";
               sqlOperation2.AddParameterWithValue("@treat", treatID);
               reader = sqlOperation2.ExecuteReader(selectallaccerappoint);
                while (reader.Read())
                {
                    string deletecommand = "delete from appointment_accelerate where ID=@appointid";
                    sqlOperation1.AddParameterWithValue("@appointid", reader["ID"].ToString());
                    sqlOperation1.ExecuteNonQuery(deletecommand);
                    string deletecommand2 = "delete from treatmentrecord where Appointment_ID=@appointid";
                    sqlOperation1.ExecuteNonQuery(deletecommand2);
                }
                reader.Close();
            }
            string change = "update treatment set State=@state where ID=@treatID";
            sqlOperation1.AddParameterWithValue("@treatID", Convert.ToInt32(treatID));
            sqlOperation1.AddParameterWithValue("@state", Convert.ToInt32(state));
            int Success1 = sqlOperation1.ExecuteNonQuery(change);
            if ( Success1 > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }

    }

}