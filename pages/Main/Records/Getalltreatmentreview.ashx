<%@ WebHandler Language="C#" Class="Getalltreatmentreview" %>


using System;
using System.Web;
using System.Text;

public class Getalltreatmentreview : IHttpHandler {
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
        string treatid = context.Request.QueryString["treatmentID"];
        string countcommand = "select count(*) from treatmentreview where treatmentid=@treatmentid and operateuser is not NULL";
        sqlOperation.AddParameterWithValue("@treatmentid", treatid);
        int count = int.Parse(sqlOperation.ExecuteScalar(countcommand));
        string sqlCommand = "SELECT scanpart.Name as scanpartname,scanmethod.Method as scanMethod,up,down,enhance,enhancemethod,locationrequirements.Requirements as locaterequire,applyremark,thick,treatmentreview.number as trnumber,ReferenceNumber,ReferenceScale,remark,user.Name as username,operateuser from treatmentreview,scanpart,scanmethod,locationrequirements,user where treatmentid=@treatmentid and operateuser is not NULL and treatmentreview.scanmethod=scanmethod.ID and treatmentreview.scanpart=scanpart.ID and treatmentreview.specialrequest=locationrequirements.ID  and treatmentreview.applyuser=user.ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i=0;
        while(reader.Read())
        {
            string operateuser = "";
            string enhancemethod = "";
            string usercommand = "select user.Name from user where ID=@useroperate";
            sqlOperation1.AddParameterWithValue("@useroperate", Convert.ToInt32(reader["operateuser"].ToString()));
            operateuser=sqlOperation1.ExecuteScalar(usercommand);
            if (enhancemethod != "")
            {
                string enhancemethodcommand = "select Method from enhancemethod where ID=@enhancemethod";
                sqlOperation1.AddParameterWithValue("@enhancemethod", Convert.ToInt32(reader["enhancemethod"].ToString()));
                enhancemethod = sqlOperation1.ExecuteScalar(enhancemethodcommand);
            }

            backText.Append("{\"scanpart\":\"" + reader["scanpartname"].ToString() + "\",\"scanmethod\":\"" + reader["scanMethod"].ToString() + "\",\"up\":\"" + reader["up"].ToString() + "\",\"down\":\"" + reader["down"].ToString() + "\",\"enhance\":\"" + reader["enhance"].ToString() + "\",\"enhancemethod\":\"" + enhancemethod + "\",\"specialrequest\":\"" + reader["locaterequire"].ToString() + "\",\"applyremark\":\"" + reader["applyremark"].ToString() +
                "\",\"thick\":\"" + reader["thick"].ToString() + "\",\"number\":\"" + reader["trnumber"].ToString() + "\",\"ReferenceNumber\":\"" + reader["ReferenceNumber"].ToString() + "\",\"ReferenceScale\":\"" + reader["ReferenceScale"].ToString() + "\",\"remark\":\"" + reader["remark"].ToString() + "\",\"applyuser\":\"" + reader["username"].ToString() + "\",\"operateuer\":\"" + operateuser + "\"}");
            if (i < count - 1)
            {
                backText.Append(",");
                i++;
            }
 
        }
        backText.Append("]}");
        return backText.ToString();
    }

}