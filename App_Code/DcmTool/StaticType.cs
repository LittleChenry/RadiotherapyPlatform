using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// StaticType 的摘要说明
/// </summary>
public class StaticType:TechnologyType
{
    public int change(int mod)
    {
        int ans = mod >> 1;
        return ans;
    }
}