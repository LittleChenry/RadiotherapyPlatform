window.addEventListener("load", createPatient, false)
var SickPart;
var SickPartid;
var diagnosisresultname;
var diagnosisresultID;

//JS入口主函数
function createPatient(evt) {
    //获取入口患者信息界面的div
 
    //获得当前执行人姓名与ID
   
    var treatID = window.location.search.split("=")[1];
    document.getElementById("treatID").value = treatID;
    getDignoseInfo(treatID);
    
    //调取后台所有等待就诊的疗程号及其对应的病人
    
    var select3 = document.getElementById("part");
    createPartItem(select3);
    var select4 = document.getElementById("diagresult");
    createDiagResultItem(select4);
  
}
function getDignoseInfo(treatID) {

    var xmlHttp = new XMLHttpRequest();

    var url = "diagnoseInfo.ashx?treatID=" + treatID;

    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;
            diagnoseInfo = eval("(" + getString + ")");
        }
    }

    xmlHttp.send();
    
    writeDiagnoseInfo(diagnoseInfo);
}
function writeDiagnoseInfo(DiagnoseInfo) {

    
    document.getElementById("diaguser").value = DiagnoseInfo.diagnosisInfo[0].username;
    document.getElementById("remark").value = DiagnoseInfo.diagnosisInfo[0].Remarks;
    SickPart = DiagnoseInfo.diagnosisInfo[0].partname;
    SickPartid = DiagnoseInfo.diagnosisInfo[0].partID;
    diagnosisresultname = DiagnoseInfo.diagnosisInfo[0].diagnosisresultname;
    diagnosisresultID = DiagnoseInfo.diagnosisInfo[0].diagnosisresultID;
    //doctor = DiagnoseInfo.DiagnoseInfo[0].doctor;
    
    document.getElementById("time").value = DiagnoseInfo.diagnosisInfo[0].Time;
    // document.getElementById("userID").value = userID;
    // addDosagePriority( DiagnoseInfo.DiagnoseInfo[0].DosagePriority);


}
//获取所有待就诊疗程号以及所属患者ID与其他信息


//首页判断

//生成基本信息确认DIV

//第二步部位下拉项建立
function createPartItem(thiselement) {
    var PartItem = JSON.parse(getPartItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option(SickPart);
    thiselement.options[0].value = SickPartid;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getpart.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//第二步诊断结果下拉建立
function createDiagResultItem(thiselement) {
    var DiagResultItem = JSON.parse(getDiagResultItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option(diagnosisresultname);
    thiselement.options[0].value = diagnosisresultID;
    for (var i = 0; i < DiagResultItem.length; i++) {
        if (DiagResultItem[i] != "") {
            thiselement.options[i + 1] = new Option(DiagResultItem[i].Name);
            thiselement.options[i + 1].value = parseInt(DiagResultItem[i].ID);
        }
    }


}
//第二步诊断结果下拉选项获取
function getDiagResultItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getDiagResult.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//检查填写情况
/*
function getUserName() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../Root/GetUserName.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {//正常响应
            if (xmlHttp.status == 200) {//正确接受响应数据
                userName = xmlHttp.responseText;
            }
        }
    }
    xmlHttp.send();
}
function getUserID() {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetUserID.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {//正常响应
            if (xmlHttp.status == 200) {//正确接受响应数据
                userID = xmlHttp.responseText;
            }
        }
    }
    xmlHttp.send();
}
//下面是jquery流程条实现代码




*/