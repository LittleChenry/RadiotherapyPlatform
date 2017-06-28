using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// 弹出提示对话框
/// </summary>
public class MessageBox
{
	public MessageBox()
	{
		
	}

    public static void Message(string MessageInformation)
    {
        System.Web.HttpContext.Current.Response.Write("<script language=javascript>alert('" + MessageInformation + "');</script>");
    }
}