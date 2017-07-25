<%@ WebHandler Language="C#" Class="addNewItemInModel" %>

using System;
using System.Web;

public class addNewItemInModel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        add(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void add(HttpContext context)
    {
        string mainItem = context.Request.Form["MainItem"];
        string childItem = context.Request.Form["ChildItem"];
        string checkWay = context.Request.Form["checkWay"];
        string explain = context.Request.Form["explain"];
        string reference = context.Request.Form["reference"];
        string cycle = context.Request.Form["cycle"];
        string model = context.Request.Form["model"];
        string exist = context.Request.Form["exist"];
        string savepath1 = "";
        if (exist == "true")
        {
            HttpFileCollection files = context.Request.Files;            
            string savePath = System.Web.HttpContext.Current.Server.MapPath("~/upload/EquipmentPicture");
            if (!System.IO.Directory.Exists(savePath))
            {
                System.IO.Directory.CreateDirectory(savePath);
            }
            savePath = savePath + "\\";
            try
            {

                System.Web.HttpPostedFile postedFile = files[0];
                string fileName = postedFile.FileName;//完整的路径
                if (fileName == "")
                {
                    savepath1 = "";
                }
                else
                {
                    fileName = System.IO.Path.GetFileName(postedFile.FileName); //获取到名称
                    string fileExtension = System.IO.Path.GetExtension(fileName);//文件的扩展名称
                    string type = fileName.Substring(fileName.LastIndexOf(".") + 1);    //类型  
                    files[0].SaveAs(savePath + DateTime.Now.ToString("yyyyMMdd") + fileName);
                    savepath1 = "/RadiotherapyPlatform/upload/EquipmentPicture/" + DateTime.Now.ToString("yyyyMMdd") + fileName;
                }
            }
            catch (System.Exception Ex)
            {
                context.Response.Write(Ex);
            }
        }
        
        if (checkWay == "NA")
            reference = "NA";
        else if (checkWay == "IsOK")
            reference = "功能正常";

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "INSERT INTO inspections(MainItem,ChildItem,inspections.Explain,Reference,TemplateID,Cycle,files) VALUES(@mainItem,@childItem,@explain,@reference,@templateID,@cycle,@files)";
        if (exist != "true")
        {
            sqlCommand = "INSERT INTO inspections(MainItem,ChildItem,inspections.Explain,Reference,TemplateID,Cycle) VALUES(@mainItem,@childItem,@explain,@reference,@templateID,@cycle)";
        }
        sqlOperator.AddParameterWithValue("@mainItem", mainItem);
        sqlOperator.AddParameterWithValue("@childItem", childItem);
        sqlOperator.AddParameterWithValue("@explain", explain);
        sqlOperator.AddParameterWithValue("@reference", reference);
        sqlOperator.AddParameterWithValue("@templateID", int.Parse(model));
        sqlOperator.AddParameterWithValue("@cycle", cycle);
        sqlOperator.AddParameterWithValue("@files", savepath1);
        sqlOperator.ExecuteNonQuery(sqlCommand);

            
    }
   
}