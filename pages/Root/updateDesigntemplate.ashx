<%@ WebHandler Language="C#" Class="updateDesigntemplate" %>

using System;
using System.Web;

public class updateDesigntemplate : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = update(context);
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
    private string update(HttpContext context)
    {
        try
        {
            string aa = context.Request.Form["aa"];
            string bb = context.Request.Form["bb"];
            string name = context.Request.Form["templateName_design"];
            string updateID = context.Request.Form["updateID"];
            string DosagePriority = "";
            if (aa == "NaN")
            {
                aa = "-1";
            }
            if (bb == "NaN")
            {
                bb = "-1";
            }
            int a1 = Convert.ToInt32(aa);
            int i = 0;
            while (i <= a1)
            {
                string ii = Convert.ToString(i);
                string Prioritytype = context.Request.Form["Prioritytype" + ii];
                string Priorityout = context.Request.Form["Priorityout" + ii];
                string Prioritptv = context.Request.Form["Prioritptv" + ii];
                string Prioritcgy = context.Request.Form["Prioritcgy" + ii];
                string Priorittime = context.Request.Form["Priorittime" + ii];
                string Prioritsum = context.Request.Form["Prioritsum" + ii];
                string Prioritremark = context.Request.Form["Prioritremark" + ii];
                string Priorit = context.Request.Form["Priorit" + ii];
                DosagePriority = DosagePriority + Prioritytype + "," + Priorityout + "," + Prioritptv + "," + Prioritcgy + "," + Priorittime + "," + Prioritsum + "," + Prioritremark + "," + Priorit + ";";
                i++;
            }
            int b1 = Convert.ToInt32(bb);
            int j = 0;
            DosagePriority = DosagePriority + "&";
            while (j <= b1)
            {
                string jj = Convert.ToString(j);
                string type = context.Request.Form["type" + jj];
                string dv = context.Request.Form["dv" + jj];
                string number = context.Request.Form["number" + jj];
                string outt = context.Request.Form["out" + jj];
                string prv = context.Request.Form["prv" + jj];
                string num = context.Request.Form["num" + jj];
                string numbers = context.Request.Form["numbers" + jj];
                string pp = context.Request.Form["pp" + jj];
                DosagePriority = DosagePriority + type + "," + dv + ",<," + number + "," + outt + "," + prv + "," + num + ",<," + numbers + "," + pp + ";";
                j++;
            }
            string designSql = "update design set RadiotherapyHistory=@RadiotherapyHistory,DosagePriority=@DosagePriority,Technology_ID=@Technology_ID,Equipment_ID=@Equipment_ID where ID=@ID";
                                    
            sqlOperation.AddParameterWithValue("@ID", Convert.ToInt32(updateID));
            sqlOperation.AddParameterWithValue("@RadiotherapyHistory", context.Request.Form["Remarks_design"]);
            sqlOperation.AddParameterWithValue("@Technology_ID", Convert.ToInt32(context.Request.Form["technology_design"]));
            sqlOperation.AddParameterWithValue("@Equipment_ID", Convert.ToInt32(context.Request.Form["equipment_design"]));
            sqlOperation.AddParameterWithValue("@DosagePriority", DosagePriority);
            int success1 = sqlOperation.ExecuteNonQuery(designSql);
            
            
            string templateSql = "update doctortemplate set Name=@Name where TemplateID=@TemplateID";
            sqlOperation1.AddParameterWithValue("@Name", name);
            sqlOperation1.AddParameterWithValue("@TemplateID", Convert.ToInt32(updateID));
            int success2 = sqlOperation1.ExecuteNonQuery(templateSql);


            

            if (success1 > 0 && success2 > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }


    }
}