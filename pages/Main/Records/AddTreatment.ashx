<%@ WebHandler Language="C#" Class="AddTreatment" %>

using System;
using System.Web;
using System.Text;

public class AddTreatment : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(Addtreat(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string Addtreat(HttpContext context)
    {
        int diagid=0;
        int fixid=0;
        int location=0;
        int design=0;
        int replace=0;
        int review=0;
        int group = 0;
        int step=0;
        int common = 0;
        if(context.Request["diagnose"].ToString()!="")
        {
          diagid=Convert.ToInt32(context.Request["diagnose"]);
          string commandstring = "select iscommon from treatment where DiagnosisRecord_ID=@diagid";
           DataLayer sqlOperation3 = new DataLayer("sqlStr");
           sqlOperation3.AddParameterWithValue("@diagid", diagid);
          common=int.Parse(sqlOperation3.ExecuteScalar(commandstring));
          sqlOperation3.Close();
          sqlOperation3.Dispose();
          sqlOperation3 = null;
          if (context.Request["group"].ToString()!= "")
          {
              group = Convert.ToInt32(context.Request["group"]);
          }
          step=1;
        if(context.Request["fixed"].ToString()!="")
        {
            fixid=Convert.ToInt32(context.Request["fixed"]); 
            step=2;
        if(context.Request["location"].ToString()!="")
        {
            location=Convert.ToInt32(context.Request["location"]);
            step=3;
        if(context.Request["design"].ToString()!="")
        {
             step=4;
            design=Convert.ToInt32(context.Request["design"]);
            review=Convert.ToInt32(context.Request["review"]);
           if(context.Request["replace"].ToString()!="")
           {
              step=5;
            replace=Convert.ToInt32(context.Request["replace"]);
           }
        }  
        }    
        }
        }
        int treatname = Convert.ToInt32(context.Request["treatmentname"]);
        string treatmentdescribe = context.Request["Treatmentdescribe"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        int radio = Convert.ToInt32(context.Request["Radiotherapy_ID"]);
        string sqlcommand = "select ID from patient where Radiotherapy_ID=@radio";
        sqlOperation.AddParameterWithValue("@radio", radio);
        int patientid = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand));
        string sqlcommand2 = "select RegisterDoctor from patient where Radiotherapy_ID=@radio";
        int doctor= Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        if (step == 0)
        {
            string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@doc,@Treatmentdescribe)";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            sqlOperation.AddParameterWithValue("@treatname", treatname);
            sqlOperation.AddParameterWithValue("@doc", doctor);
            sqlOperation.AddParameterWithValue("@progress", "0");
            sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
            int success = sqlOperation.ExecuteNonQuery(insert);

            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        if (step == 1)
        {
            int success=0;
            if (group != 0)
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,Belongingdoctor,Group_ID,Treatmentdescribe,iscommon,DiagnosisRecord_ID) values(@patient,0,@progress,@treatname,@doc,@group,@Treatmentdescribe,@iscommon,@diag)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@group", group);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                if (common == 0)
                {
                    sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6,7,8,9,10");
                    
                }
                else {

                    sqlOperation.AddParameterWithValue("@progress", "0,1");
                }

                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                sqlOperation.AddParameterWithValue("@iscommon", common);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            else
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,Belongingdoctor,Treatmentdescribe,iscommon,DiagnosisRecord_ID) values(@patient,0,@progress,@treatname,@doc,@Treatmentdescribe,@iscommon,@diag)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                if (common != 0)
                {
                    sqlOperation.AddParameterWithValue("@progress", "0,1");
                }
                else
                {

                    sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6,7,8,9,10");
                }
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                sqlOperation.AddParameterWithValue("@iscommon", common);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        if (step == 2)
        {
            int success = 0;
            if (group != 0)
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@group,@fix,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@group", group);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,4");
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            else
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Fixed_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@fix,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,4");
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        if (step == 3)
        {
            int success=0;
            if (group != 0)
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID,Location_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@group,@fix,@locate,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@group", group);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@locate", location);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6");
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            else
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Fixed_ID,Location_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@fix,@locate,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@locate", location);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6");
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        if (step == 4)
        {
            int success = 0;
            if (group != 0)
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID,Location_ID,Design_ID,Review_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@group,@fix,@locate,@design,@review,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@group", group);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@locate", location);
                sqlOperation.AddParameterWithValue("@design", design);
                sqlOperation.AddParameterWithValue("@review", review);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6,7,8,9,10");
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            else
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Fixed_ID,Location_ID,Design_ID,Review_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@fix,@locate,@design,@review,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@locate", location);
                sqlOperation.AddParameterWithValue("@design", design);
                sqlOperation.AddParameterWithValue("@review", review);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6,7,8,9,10");
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        if (step == 5)
        {
            int success = 0;
            if (group != 0)
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID,Location_ID,Design_ID,Review_ID,Replacement_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@group,@fix,@locate,@design,@review,@replace,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@group", group);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@locate", location);
                sqlOperation.AddParameterWithValue("@design", design);
                sqlOperation.AddParameterWithValue("@review", review);
                sqlOperation.AddParameterWithValue("@replace", replace);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6,7,8,9,10,11,12,13");
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            else
            {
                string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Fixed_ID,Location_ID,Design_ID,Review_ID,Replacement_ID,Belongingdoctor,Treatmentdescribe) values(@patient,0,@progress,@treatname,@diag,@fix,@locate,@design,@review,@replace,@doc,@Treatmentdescribe)";
                sqlOperation.AddParameterWithValue("@patient", patientid);
                sqlOperation.AddParameterWithValue("@treatname", treatname);
                sqlOperation.AddParameterWithValue("@diag", diagid);
                sqlOperation.AddParameterWithValue("@fix", fixid);
                sqlOperation.AddParameterWithValue("@locate", location);
                sqlOperation.AddParameterWithValue("@design", design);
                sqlOperation.AddParameterWithValue("@review", review);
                sqlOperation.AddParameterWithValue("@replace", replace);
                sqlOperation.AddParameterWithValue("@doc", doctor);
                sqlOperation.AddParameterWithValue("@Treatmentdescribe", treatmentdescribe);
                sqlOperation.AddParameterWithValue("@progress", "0,1,2,3,4,5,6,7,8,9,10,11,12,13");
                success = sqlOperation.ExecuteNonQuery(insert);
            }
            if (success > 0)
            {
                return "success";
            }
            else
            {
                return "error";
            }
        }
        return "success";
    }    
}
