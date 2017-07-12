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
        if(context.Request["diagnose"].ToString()!="")
        {
          diagid=Convert.ToInt32(context.Request["diagnose"]);
          group =Convert.ToInt32(context.Request["group"]);
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
        DataLayer sqlOperation = new DataLayer("sqlStr");
        int radio = Convert.ToInt32(context.Request["Radiotherapy_ID"]);
        string sqlcommand = "select ID from patient where Radiotherapy_ID=@radio";
        sqlOperation.AddParameterWithValue("@radio", radio);
        int patientid = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand));   
        if (step == 0)
        {
            string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname) values(@patient,1,1,@treatname)";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            sqlOperation.AddParameterWithValue("@treatname", treatname);
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
            string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID) values(@patient,1,2,@treatname,@diag,@group)";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            sqlOperation.AddParameterWithValue("@treatname", treatname);
            sqlOperation.AddParameterWithValue("@diag", diagid);
            sqlOperation.AddParameterWithValue("@group", group);
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
        if (step == 2)
        {
            string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID) values(@patient,1,3,@treatname,@diag,@group,@fix)";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            sqlOperation.AddParameterWithValue("@treatname", treatname);
            sqlOperation.AddParameterWithValue("@diag", diagid);
            sqlOperation.AddParameterWithValue("@group", group);
            sqlOperation.AddParameterWithValue("@fix", fixid);
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
        if (step == 3)
        {
            string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID,Location_ID) values(@patient,1,7,@treatname,@diag,@group,@fix,@locate)";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            sqlOperation.AddParameterWithValue("@treatname", treatname);
            sqlOperation.AddParameterWithValue("@diag", diagid);
            sqlOperation.AddParameterWithValue("@group", group);
            sqlOperation.AddParameterWithValue("@fix", fixid);
            sqlOperation.AddParameterWithValue("@locate", location);
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
        if (step == 4)
        {
            string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID,Location_ID,Design_ID,Review_ID) values(@patient,1,12,@treatname,@diag,@group,@fix,@locate,@design,@review)";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            sqlOperation.AddParameterWithValue("@treatname", treatname);
            sqlOperation.AddParameterWithValue("@diag", diagid);
            sqlOperation.AddParameterWithValue("@group", group);
            sqlOperation.AddParameterWithValue("@fix", fixid);
            sqlOperation.AddParameterWithValue("@locate", location);
            sqlOperation.AddParameterWithValue("@design", design);
            sqlOperation.AddParameterWithValue("@review", review);
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
        if (step == 5)
        {
            string insert = "insert into treatment(Patient_ID,State,Progress,Treatmentname,DiagnosisRecord_ID,Group_ID,Fixed_ID,Location_ID,Design_ID,Review_ID,Replacement_ID) values(@patient,1,14,@treatname,@diag,@group,@fix,@locate,@design,@review,@replace)";
            sqlOperation.AddParameterWithValue("@patient", patientid);
            sqlOperation.AddParameterWithValue("@treatname", treatname);
            sqlOperation.AddParameterWithValue("@diag", diagid);
            sqlOperation.AddParameterWithValue("@group", group);
            sqlOperation.AddParameterWithValue("@fix", fixid);
            sqlOperation.AddParameterWithValue("@locate", location);
            sqlOperation.AddParameterWithValue("@design", design);
            sqlOperation.AddParameterWithValue("@review", review);
            sqlOperation.AddParameterWithValue("@replace", replace);
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
        return "success";
    }    
}
