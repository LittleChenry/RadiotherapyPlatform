using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// TrchnologyTypeFactory 的摘要说明
/// </summary>
public class TrchnologyTypeFactory
{
    public static TechnologyType newInstance(string who)
    {
        switch (who)
        {
            case "STATIC":
                return new StaticType();
            case "DYNAMIC":
                return new DynamicType();
        }
        return new StaticType();
    }
}