using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using System.Text;

/// <summary>
/// FileHandler 
/// 文件读取处理
/// </summary>
public class FileHandler
{
	public FileHandler()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    /// <summary>
    /// 处理RTP文件从中读取期望数据
    /// </summary>
    /// <param name="content">RTP文件内容</param>
    /// <returns>a jsonString 结果</returns>
    public static string handler(string content)
    {
        StringBuilder result = new StringBuilder("{\"information\":[");
        Regex reg = new Regex("^\"\\w+\",\"(\\d+)\",(\"[^\"]*\",?\\r?\\n?){21}\"([^\"]*)\",(\"[^\"]*\",?\\r?\\n?){11}\"([^\"]*)\",\"([^\"]*)\",(\"[^\"]*\",?\\r?\\n?){2}\"([^\"]*)\",(\"[^\"]*\",?\\r?\\n?){3}\"([^\"]*)\",");
        Match m = reg.Match(content);
        string id = m.Groups[1].Value;
        string tps = m.Groups[3].Value;
        string all = m.Groups[5].Value;
        string once = m.Groups[6].Value;
        string fieldTimes = m.Groups[8].Value;
        string pos = m.Groups[10].Value;
        result.Append("{\"id\":\"").Append(id).Append("\"")
              .Append(",\"tps\":\"").Append(tps).Append("\"")
              .Append(",\"all\":\"").Append(all).Append("\"")
              .Append(",\"once\":\"").Append(once).Append("\"")
              .Append(",\"fieldTimes\":\"").Append(fieldTimes).Append("\"")
              .Append(",\"pos\":\"").Append(pos).Append("\"}")
              .Append("],\"details\":[");

        reg = new Regex("(\\w?)*\"FIELD_DEF\",\"[^\"]*\",?\\r?\\n?\"([^\"]*)\",?(\"[^\"]*\",?\\r?\\n?){3}\"([^\"]*)\",?(\"[^\"]*\",?\\r?\\n?)\"([^\"]*)\",?\"([^\"]*)\",?\"([^\"]*)\",?\"([^\"]*)\",?(\"[^\"]*\",?\\r?\\n?){3}\"([^\"]*)\",?\"([^\"]*)\",?\"([^\"]*)\",?(\"[^\"]*\",?\\r?\\n?){11}\"([^\"]*)\",?(\"[^\"]*\",?\\r?\\n?){29}\"CONTROL_PT_DEF\",?(\"[^\"]*\",?\\r?\\n?){3}\"([^\"]*)\",?");
        MatchCollection ms = reg.Matches(content);
        for (int i = 0; i < ms.Count; i++)
        {
            result.Append("{\"fieldID\":\"").Append(ms[i].Groups[2].Value).Append("\"")
                  .Append(",\"mu\":\"").Append(ms[i].Groups[4].Value).Append("\"")
                  .Append(",\"equipment\":\"").Append(ms[i].Groups[6].Value).Append("\"")
                  .Append(",\"technology\":\"").Append(ms[i].Groups[7].Value).Append("\"")
                  .Append(",\"type\":\"").Append(ms[i].Groups[8].Value).Append("\"")
                  .Append(",\"energyField\":\"").Append(ms[i].Groups[9].Value).Append("\"")
                  .Append(",\"ypj\":\"").Append(ms[i].Groups[11].Value).Append("\"")
                  .Append(",\"jjj\":\"").Append(ms[i].Groups[12].Value).Append("\"")
                  .Append(",\"jtj\":\"").Append(ms[i].Groups[13].Value).Append("\"")
                  .Append(",\"czj\":\"").Append(ms[i].Groups[15].Value).Append("\"")
                  .Append(",\"childs\":\"").Append(ms[i].Groups[18].Value).Append("\"},");
        }

        return result.Remove(result.Length-1,1).Append("]}").ToString();
    }
}