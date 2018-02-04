using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Timers;

/// <summary>
/// AutoRun 的摘要说明
/// </summary>
public class AutoRun
{
    public static bool IsOpen = false;
    public static DateTime LastOpenTime = DateTime.Now;
    public static void Execute()
    {
        Timer objTimer = new Timer();
        objTimer.Interval = 6000; 
        objTimer.Enabled = true;
        objTimer.Elapsed += new ElapsedEventHandler(objTimer_Elapsed);
    }

    public static void objTimer_Elapsed(object sender, ElapsedEventArgs e)
    {
        if (int.Parse(DateTime.Now.Hour.ToString()) >= 5 && int.Parse(DateTime.Now.Hour.ToString()) <= 6)
        {
            ////如果上一次执行时间为昨天，就设置IsOpen为false,说明今天还没有执行
            if (DateTime.Today.AddDays(-1) == LastOpenTime.Date)
            {
                IsOpen = false;
            }
            ////如果今天还没执行，并且当前时间大于指定执行时间，就执行，
            ////执行完后，设置IsOpen为true,说明今天已执行过了。
            if (!IsOpen)
            {
                transferappoint();
                IsOpen = true;
                LastOpenTime = DateTime.Today;
            }
        }
    }

    public static void transferappoint()
    {
        
    }
}