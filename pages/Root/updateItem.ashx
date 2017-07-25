<%@ WebHandler Language="C#" Class="updateItem" %>

using System;
using System.Web;

public class updateItem : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = update(context);
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string update(HttpContext context)
    {
        int id = int.Parse(context.Request.Form["id"]);
        string mainItem = context.Request.Form["mainItem"];
        string childItem = context.Request.Form["childItem"];
        string types = context.Request.Form["type"];
        string explain = context.Request.Form["explain"];
        explain.Replace("\r", "");
        explain.Replace("\n", "");
        string reference = context.Request.Form["reference"];
        string exist = context.Request.Form["exist"];//是否新家图片
        string del = context.Request.Form["del"];//是否删除原来图片
        string savepath1 = "";
        string link = context.Request.Form["oldlink"];//原来图片链接
        if (del == "true")
        {
            System.IO.File.Delete(System.Web.HttpContext.Current.Server.MapPath(link));
        }

        if (exist == "true")
        {
            if (link != "")
            {
                System.IO.File.Delete(System.Web.HttpContext.Current.Server.MapPath(link));
            }
            
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

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "UPDATE inspections SET MainItem=@mainItem,ChildItem=@childItem,inspections.Explain=@explain,Reference=@reference,files=@link WHERE ID=@id";
        if (exist != "true")
        {
            sqlCommand = "UPDATE inspections SET MainItem=@mainItem,ChildItem=@childItem,inspections.Explain=@explain,Reference=@reference WHERE ID=@id";
        }
        sqlOperator.AddParameterWithValue("@mainItem", mainItem);
        sqlOperator.AddParameterWithValue("@childItem", childItem);
        sqlOperator.AddParameterWithValue("@explain", explain);
        sqlOperator.AddParameterWithValue("@reference", reference);
        sqlOperator.AddParameterWithValue("@id", id);

        sqlOperator.AddParameterWithValue("@link", savepath1);
        if (del=="true" && savepath1 == "")
        {
            sqlCommand = "UPDATE inspections SET MainItem=@mainItem,ChildItem=@childItem,inspections.Explain=@explain,Reference=@reference,files=@link WHERE ID=@id";
            sqlOperator.AddParameterWithValue("@link", DBNull.Value);
        }

        sqlOperator.ExecuteNonQuery(sqlCommand);
        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
        return savepath1;

    }

}