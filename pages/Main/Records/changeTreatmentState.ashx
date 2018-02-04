<%@ WebHandler Language="C#" Class="changeTreatmentState" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class changeTreatmentState : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;   
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
               string childdesignlistcommand = "select DISTINCT(ID) from childdesign where Treatment_ID=@treat";
               sqlOperation2.AddParameterWithValue("@treat", treatID);
               reader = sqlOperation2.ExecuteReader(childdesignlistcommand);
               ArrayList childdesignlist = new ArrayList();
               while (reader.Read())
               {
                   childdesignlist.Add(reader["ID"].ToString());
               }
               reader.Close();
               for (int k = 0; k < childdesignlist.Count; k++)
               {
                   string chid = childdesignlist[k].ToString();
                   string updatecommand = "update childdesign set State=0 where ID=@chid";
                   sqlOperation.AddParameterWithValue("@chid", chid);
                   sqlOperation.ExecuteNonQuery(updatecommand);
                   string selectcommand = "select treatmentrecord.Appointment_ID as appointid,treatmentrecord.ID as treatmentrecordid from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and ChildDesign_ID=@chid and Treat_User_ID is NULL and Date>=@nowdate";
                   sqlOperation.AddParameterWithValue("@chid", chid);
                   sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
                   sqlOperation.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
                   reader = sqlOperation.ExecuteReader(selectcommand);
                   ArrayList arrayforapp = new ArrayList();
                   ArrayList arrayforapp2 = new ArrayList();
                   ArrayList treatmentarray = new ArrayList();
                   while (reader.Read())
                   {
                       arrayforapp.Add(reader["appointid"].ToString());
                       treatmentarray.Add(reader["treatmentrecordid"].ToString());
                   }
                   reader.Close();
                   for (int i = 0; i < arrayforapp.Count; i++)
                   {
                       string isexists = "select count(*) from treatmentrecord where ChildDesign_ID<>@chid and Appointment_ID=@appoint";
                       sqlOperation.AddParameterWithValue("@chid", chid);
                       sqlOperation.AddParameterWithValue("@appoint", arrayforapp[i]);
                       int count = int.Parse(sqlOperation.ExecuteScalar(isexists));
                       if (count == 0)
                       {
                           arrayforapp2.Add(arrayforapp[i]);
                       }
                   }
                   for (int i = 0; i < arrayforapp2.Count; i++)
                   {
                       string deletecommand = "delete from appointment_accelerate where ID=@appoint";
                       sqlOperation.AddParameterWithValue("@appoint", arrayforapp2[i]);
                       sqlOperation.ExecuteNonQuery(deletecommand);
                   }
                   for (int i = 0; i < treatmentarray.Count; i++)
                   {
                       string deletecommand2 = "delete from treatmentrecord where ID=@tretmentid";
                       sqlOperation.AddParameterWithValue("@tretmentid", treatmentarray[i]);
                       sqlOperation.ExecuteNonQuery(deletecommand2);
                   }
               }
            }
            string childdesignlistcommand1 = "select DISTINCT(ID) from childdesign where Treatment_ID=@treat";
            sqlOperation2.AddParameterWithValue("@treat", treatID);
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation2.ExecuteReader(childdesignlistcommand1);
            ArrayList childdesignlist1 = new ArrayList();
            while (reader1.Read())
            {
                childdesignlist1.Add(reader1["ID"].ToString());
            }
            if (state == "0")
            {
                for (int k = 0; k < childdesignlist1.Count; k++)
                {
                    string chid = childdesignlist1[k].ToString();
                    string updatecommand = "update childdesign set State=2 WHERE ID=@chid and Totalnumber is null";
                    sqlOperation.AddParameterWithValue("@chid", chid);
                    sqlOperation.ExecuteNonQuery(updatecommand);
                    string updatecommand1 = "update childdesign set State=3 WHERE ID=@chid and Totalnumber is not null";
                    sqlOperation.AddParameterWithValue("@chid", chid);
                    sqlOperation.ExecuteNonQuery(updatecommand1);

                }
            }
            else
            {
                for (int k = 0; k < childdesignlist1.Count; k++)
                {
                    string chid = childdesignlist1[k].ToString();
                    string updatecommand = "update childdesign set State=0 WHERE ID=@chid";
                    sqlOperation.AddParameterWithValue("@chid", chid);
                    sqlOperation.ExecuteNonQuery(updatecommand);

                }
            }
            if (state == "2")
            {
                string changecommand = "update treatment set Progress='0,1,2,3,4,5,6,7,8,9,10,11,12,13,14' where ID=@treatID";
                sqlOperation1.AddParameterWithValue("@treatID", Convert.ToInt32(treatID));
                sqlOperation1.ExecuteNonQuery(changecommand);
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