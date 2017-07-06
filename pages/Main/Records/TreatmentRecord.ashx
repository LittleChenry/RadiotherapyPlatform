<%@ WebHandler Language="C#" Class="TreatmentRecord" %>

using System;
using System.Web;
 using System.Text;
public class TreatmentRecord : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getpatientFixinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
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
    private string getpatientFixinfo(HttpContext context)
    {

        int treatID = Convert.ToInt32(context.Request.QueryString["treatID"]);
        int i = 1;
        string countCompute = "select count(ID) from treatmentrecord where TreatTime is not NULL and TreatedDays is not NULL and TreatedTimes is not NULL and Treat_User_ID is not NULL and Assist_User_ID is not NULL and Treatment_ID=@treatid";
        sqlOperation.AddParameterWithValue("@treatid", treatID);
        int count = int.Parse(sqlOperation.ExecuteScalar(countCompute));

        string sqlCommand = "select treatmentrecord.*,user.Name as username from treatmentrecord,user where treatmentrecord.TreatTime is not NULL and treatmentrecord.TreatedDays is not NULL and treatmentrecord.TreatedTimes is not NULL and treatmentrecord.Treat_User_ID is not NULL and treatmentrecord.Treat_User_ID=user.ID and treatmentrecord.Treatment_ID=@treatid and treatmentrecord.Assist_User_ID is not NULL order by TreatTime desc";
        sqlOperation.AddParameterWithValue("@treatid", treatID);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"treatmentRecordInfo\":[");
        //reader.Read();
        //backText.Append(count);
        while (reader.Read())
        {
            string date = reader["TreatTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd");
            int ID = Convert.ToInt32(reader["ID"].ToString());
            string operate = null;
            string sqlCommand1 = "select user.Name from user,treatmentrecord where treatmentrecord.Assist_User_ID=user.ID and treatmentrecord.ID = @id";
            sqlOperation1.AddParameterWithValue("@id", ID);
            string assist = sqlOperation1.ExecuteScalar(sqlCommand1);
            if (reader["Check_User_ID"] is DBNull)
            {

                operate = null;
            }
            else
            {
                string sqlCommand2 = "select user.Name from user,treatmentrecord where treatmentrecord.Check_User_ID=user.ID and treatmentrecord.ID = @treatid";
                sqlOperation1.AddParameterWithValue("@treatid",ID);
                operate = sqlOperation1.ExecuteScalar(sqlCommand2);

            }
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Treatment_ID\":\"" + reader["Treatment_ID"].ToString() +
                 "\",\"Illuminated\":\"" + reader["Illuminated"].ToString() + "\",\"Equipment_ID\":\"" + reader["Equipment_ID"].ToString() +
                  "\",\"TreatTime\":\"" + date1 + "\",\"TreatPicture\":\"" + reader["TreatPicture"].ToString() +
                   "\",\"TreatedDays\":\"" + reader["TreatedDays"].ToString() + "\",\"TreatedTimes\":\"" + reader["TreatedTimes"].ToString() +
                    "\",\"Rest\":\"" + reader["Rest"].ToString() + "\",\"Treat_User_ID\":\"" + reader["username"].ToString() +
                     "\",\"Check_User_ID\":\"" + operate + "\",\"Appointment_ID\":\"" + reader["Appointment_ID"].ToString() +
                     "\",\"IlluminatedNumber\":\"" + reader["IlluminatedNumber"].ToString() + "\",\"Singlenumber\":\"" + reader["Singlenumber"].ToString() + "\",\"X_System\":\"" + reader["X_System"].ToString() + "\",\"Y_System\":\"" + reader["Y_System"].ToString() + "\",\"Z_System\":\"" + reader["Z_System"].ToString() + "\",\"MachineNumbe\":\"" + reader["MachineNumbe"].ToString() +
                     "\",\"Assist_User_ID\":\"" + assist + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        return backText.ToString();

    }
}