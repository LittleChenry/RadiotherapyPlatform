<%@ WebHandler Language="C#" Class="getDiagResult" %>

using System;
using System.Web;
using System.Text;
/* ***********************************************************
 * FileName:getDiagResult.ashx
 * Writer: xubxiao
 * create Date: 2017-5-4
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 获取数据库中诊断结果表中的数据
 * **********************************************************/
public class getDiagResult : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getdiagresult();
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getdiagresult()
    {
        string countItem = "SELECT count(*) FROM diagnosisresult";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT ID,TumorName,Description FROM diagnosisresult";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["TumorName"].ToString() + reader["Description"].ToString() + "\"}");
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