<%@ WebHandler Language="C#" Class="HandlerDate" %>

using System;
using System.Web;
using System.Text;
using System.Collections;
public class HandlerDate : IHttpHandler {

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
                  
            string design = "select count(*) from design where energy is not null";
            int count = Convert.ToInt32(sqlOperation.ExecuteScalar(design));
            string designdetial = "select design.* from design where energy is not null";
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(designdetial);
            //if (receiver != userid)
            //{
            //    return "message";
            //}
            while (reader.Read())
            {
                int id = Convert.ToInt32(reader["ID"].ToString());
                string treatid = "select ID from treatment where design_ID=@ID";
                sqlOperation2.AddParameterWithValue("@ID", id);
                string treatID = sqlOperation2.ExecuteScalar(treatid);
                if (treatID == "")
                {
                    continue;
                }
                string insert = "insert into childdesign (Treatment_ID,IlluminatedNumber,Coplanar,MachineNumbe,ControlPoint,parameters,Illuminatedangle,Irradiation_ID,energy,DesignName,item) " +
                                "values(@Treatment_ID,@IlluminatedNumber,@Coplanar,@MachineNumbe,@ControlPoint,@parameters,@Illuminatedangle,@Irradiation_ID,@energy,@DesignName,@item)";
                sqlOperation1.AddParameterWithValue("@Treatment_ID", treatID);
                sqlOperation1.AddParameterWithValue("@IlluminatedNumber", reader["IlluminatedNumber"].ToString());
                sqlOperation1.AddParameterWithValue("@Coplanar", Convert.ToInt32(reader["Coplanar"].ToString()));
                sqlOperation1.AddParameterWithValue("@MachineNumbe", reader["MachineNumbe"].ToString());
                sqlOperation1.AddParameterWithValue("@ControlPoint", reader["ControlPoint"].ToString());
                sqlOperation1.AddParameterWithValue("@parameters", reader["parameters"].ToString());
                sqlOperation1.AddParameterWithValue("@Illuminatedangle", reader["Illuminatedangle"].ToString());
                sqlOperation1.AddParameterWithValue("@Irradiation_ID", reader["Irradiation_ID"].ToString());
                sqlOperation1.AddParameterWithValue("@energy", reader["energy"].ToString());
                sqlOperation1.AddParameterWithValue("@DesignName", "计划1");
                sqlOperation1.AddParameterWithValue("@item", 0);
                sqlOperation1.ExecuteNonQuery(insert);
                string childdesign = "select ID from childdesign where Treatment_ID=@Treatment_ID and item=0";
                childdesign = sqlOperation1.ExecuteScalar(childdesign);
                string update = " update fieldinfomation set childdesign_ID=@childdesign_ID where treatmentid=@Treatment_ID";
                sqlOperation1.AddParameterWithValue("@childdesign_ID", childdesign);
                sqlOperation1.ExecuteNonQuery(update);
                string review = "select review_ID from treatment where ID=@Treatment_ID";
                review = sqlOperation1.ExecuteScalar(review);
                if (review!="")
                {
                    string update2 = "update childdesign set state=2 where ID=@childdesign_ID";
                    sqlOperation1.AddParameterWithValue("@childdesign_ID", childdesign);
                    sqlOperation1.ExecuteNonQuery(update2);
                    string update1 = " update review set childdesign_ID=@childdesign_ID, Treatment_ID=@Treatment_ID,SelectDose=@SelectDose where ID=@reviewID";
                    sqlOperation1.AddParameterWithValue("@childdesign_ID", childdesign);
                    sqlOperation1.AddParameterWithValue("@reviewID", review);
                    sqlOperation1.AddParameterWithValue("@SelectDose", "--剂量选择--");
                    sqlOperation1.ExecuteNonQuery(update1);
                }
            }
            
                return "success";
            
       


    }
}