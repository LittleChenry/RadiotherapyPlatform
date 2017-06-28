var obj;
function getPatientInfo()
{
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetPatientInfo.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    obj = eval("(" + json + ")");
}