using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// DynamicType 的摘要说明
/// </summary>
public class DynamicType: TechnologyType
{
    public int change(int mod)
    {
        return mod - 1;
    }
}