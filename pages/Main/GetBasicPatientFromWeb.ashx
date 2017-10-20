<%@ WebHandler Language="C#" Class="GetBasicPatientFromWeb" %>

using System;
using System.Web;
using System.Xml;
using System.Text;

public class GetBasicPatientFromWeb : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(GetBasicInfo(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public String GetBasicInfo(HttpContext context)
    {
        string card = context.Request["info"];
        //string xmlstring = "<?xml version=\"1.0\" encoding=\"utf-8\"?><NewDataSet><Table><PATINAME>张俊东</PATINAME><SEXID>1</SEXID><BIRTHDATE>2008-10-7</BIRTHDATE><TELENUM>183252316621</TELENUM><FAMILYADDR>溧阳市赖江花园1区4栋3号门</FAMILYADDR></Table></NewDataSet>";
        //string xmlstring2 = "<?xml version=\"1.0\" encoding=\"utf-8\"?><NewDataSet><Table><NATIONALITYNAME>汉族</NATIONALITYNAME><CONTACTORTELENUM>18372328322</CONTACTORTELENUM><NATIVEPLACENAME>江苏省常州市溧阳市</NATIVEPLACENAME></Table></NewDataSet>";  
        HIS.Service service = new HIS.Service();
        string xmlstring = service.GetPatiInfoDetail(card, 0);
        string xmlstring2 = service.GetPatiInfoBasic(card);
        XmlDocument xmldoc = new XmlDocument();
        xmldoc.LoadXml(xmlstring);
        XmlNode username = xmldoc.SelectSingleNode("/NewDataSet/Table/PATINAME");
        String name = username.InnerText;
        if(name=="不详"||name=="-")
        {
            name="";
        }
        XmlNode sex = xmldoc.SelectSingleNode("/NewDataSet/Table/SEXID");
        String sexid = sex.InnerText;
        if (sexid == "不详" || sexid == "-")
        {
            sexid="";
        }
        XmlNode birth = xmldoc.SelectSingleNode("/NewDataSet/Table/BIRTHDATE");
        String birthdate = birth.InnerText;
        if (birthdate == "不详" || birthdate == "-")
        {
            birthdate="";
        }
        XmlNode tele = xmldoc.SelectSingleNode("/NewDataSet/Table/TELENUM");
        String telenumber = tele.InnerText;
        if (telenumber == "不详" || telenumber == "-")
        {
            telenumber="";
        }
        XmlNode addr = xmldoc.SelectSingleNode("/NewDataSet/Table/FAMILYADDR");
        String address = addr.InnerText;
        if (address == "不详" || address == "-")
        {
            address="";
        }
        xmldoc.LoadXml(xmlstring2);
        XmlNode nationnode = xmldoc.SelectSingleNode("/NewDataSet/Table/NATIONALITYNAME");
        String nation = nationnode.InnerText;
        if (nation == "不详" || nation == "-")
        {
            nation="";
        }
        XmlNode tele2 = xmldoc.SelectSingleNode("/NewDataSet/Table/CONTACTORTELENUM");
        String telenumber2 = tele2.InnerText;
        if (telenumber2 == "不详" || telenumber2 == "-")
        {
            telenumber2="";
        }
        XmlNode address2 = xmldoc.SelectSingleNode("/NewDataSet/Table/IDCARD");
        String idcard = address2.InnerText;
        if (idcard == "不详" || idcard == "-")
        {
            idcard = "";
        }
        StringBuilder backText = new StringBuilder("{\"Item\":");
        backText.Append("{\"name\":\"" + name + "\",\"sexid\":\"" + sexid + "\",\"birthdate\":\"" + birthdate + "\",\"simpleaddress\":\"" + address + "\",\"idcard\":\"" + idcard + "\",\"nation\":\"" + nation + "\",\"telenumber\":\"" + telenumber + "\",\"telenumber2\":\"" + telenumber2 + "\"}");
        backText.Append("}");

        return backText.ToString();
     
        
        
        
    }

}