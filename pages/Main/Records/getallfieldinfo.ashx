<%@ WebHandler Language="C#" Class="getallfieldinfo" %>


using System;
using System.Web;
using System.Text;

public class getallfieldinfo : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = gettreatmentreview(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
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
        //try
        //{
            string treatid = context.Request.QueryString["treatmentID"];
            string countcommand = "select count(*) from fieldinfomation where treatmentid=@treatmentid ";
            sqlOperation.AddParameterWithValue("@treatmentid", treatid);
            int count = int.Parse(sqlOperation.ExecuteScalar(countcommand));
            string countcommand1 = "select TPS from treatment where ID=@treatmentid ";
            string tps = sqlOperation.ExecuteScalar(countcommand1);
            string radio = "select radioID from treatment where ID=@treatmentid ";
            string radioID = sqlOperation.ExecuteScalar(radio);
            string pinyin = "select pinyin from treatment where ID=@treatmentid ";
            string pingyin = sqlOperation.ExecuteScalar(pinyin);
            string countcommand2 = "select positioninfomation from treatment where ID=@treatmentid ";
            string pos = sqlOperation.ExecuteScalar(countcommand2);
            string countcommand3 = "select iscommon from treatment where ID=@treatmentid ";
            int iscommon = Convert.ToInt32(sqlOperation.ExecuteScalar(countcommand3));
            
            string sqlCommand = "SELECT code,mu,equipment,User_ID,radiotechnique,radiotype,fieldinfomation.energy as energy1,childdesign.energy as energy2,wavedistance,angleframe,noseangle,bedrotation,subfieldnumber,Singledose,Totaldose,Operate_Time,Name,childdesign.* from fieldinfomation,user,childdesign where User_ID=user.ID and childdesign.treatment_ID=@treatmentid and childdesign.ID=childdesign_ID and treatmentid=@treatmentid ";
            sqlOperation1.AddParameterWithValue("@treatmentid", treatid);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation1.ExecuteReader(sqlCommand);
            StringBuilder backText = new StringBuilder("{\"Item\":[");
            int i = 0;
            while (reader.Read())
            {
                string date = reader["Operate_Time"].ToString();
                DateTime dt1 = Convert.ToDateTime(date);
                string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
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
                backText.Append("{\"code\":\"" + reader["code"].ToString() + "\",\"mu\":\"" + reader["mu"].ToString() + "\",\"equipment\":\"" + reader["equipment"].ToString() + "\",\"radiotechnique\":\"" + reader["radiotechnique"].ToString() + "\",\"radiotype\":\"" + reader["radiotype"].ToString() + "\",\"energy\":\"" + reader["energy1"].ToString() + "\",\"wavedistance\":\"" + reader["wavedistance"].ToString() +
                    "\",\"angleframe\":\"" + reader["angleframe"].ToString() + "\",\"noseangle\":\"" + reader["noseangle"].ToString() + "\",\"bedrotation\":\"" + reader["bedrotation"].ToString() + "\",\"subfieldnumber\":\"" + reader["subfieldnumber"].ToString() + "\",\"tps\":\"" + tps + "\",\"pos\":\"" + pos +
                    "\",\"Singledose\":\"" + reader["Singledose"].ToString() + "\",\"Totaldose\":\"" + reader["Totaldose"].ToString() + "\",\"Illuminatedangle\":\"" + reader["Illuminatedangle"].ToString() + "\",\"IlluminatedNumber\":\"" + reader["IlluminatedNumber"].ToString() +
                    "\",\"Irradiation\":\"" + reader["Irradiation_ID"].ToString() + "\",\"energy2\":\"" + reader["energy2"].ToString() + "\",\"time\":\"" + date1 + "\",\"Name\":\"" + reader["Name"].ToString() + "\",\"item\":\"" + reader["item"].ToString() + "\",\"DesignName\":\"" + reader["DesignName"].ToString() +
                    "\",\"Coplanar\":\"" + reader["Coplanar"].ToString() + "\",\"MachineNumbe\":\"" + reader["MachineNumbe"].ToString() + "\",\"userID\":\"" + reader["User_ID"].ToString() + "\",\"left\":\"" + left + "\",\"right\":\"" + right + "\",\"rise\":\"" + rise + "\",\"drop\":\"" + drop + "\",\"enter\":\"" + enter + "\",\"out\":\"" + out1 +
                    "\",\"ControlPoint\":\"" + reader["ControlPoint"].ToString() + "\",\"pinyin\":\"" + pingyin + "\",\"radioID\":\"" + radioID + "\"}");
                if (i < count - 1)
                {
                    backText.Append(",");
                    i++;
                }

            }
            backText.Append("]}");
            return backText.ToString();
        //}
        //catch (System.Exception Ex1)
        //{
        //    return "error";
        //}
}

}