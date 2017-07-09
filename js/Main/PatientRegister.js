var isAllGood;//所有检查是否通过

window.addEventListener("load", Init, false);
//初始化 

function Init(evt) {
    
    var treatID = window.location.search.split("=")[1];
    
    getPatientInfo(treatID);
    document.getElementById("treatID").value = treatID;
    //document.forms[0].addEventListener("submit", CheckInput, false);//添加表单提交事件处理函数
    document.forms[0].addEventListener("reset", resetForm, false);//添加表单rest事件函数
    //document.getElementById("Number1").addEventListener("change", phoneFormat, false);//电话号码格式化
   // document.getElementById("Number2").addEventListener("change", phoneFormat, false);//电话号码格式化
    document.getElementById("progress").value = 0;
   
    
}
function getPatientInfo(treatID) {
    
    var xmlHttp = new XMLHttpRequest();
    
    var url = "patientInfo.ashx?treatID=" + treatID;

    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;
            patientInfo = eval("(" + getString + ")");
        }
    }
    
    xmlHttp.send();
    
    writePatientInfo(patientInfo);
}
function writePatientInfo(PatientInfo) {
    
    var select4 = document.getElementById("doctor");
    createdoctorItem(select4);
   
    document.getElementById("RecordNumber").value = PatientInfo.patientInfo[0].RecordNumber;
   
    document.getElementById("userName").value = PatientInfo.patientInfo[0].Name;
    //alert(sex(PatientInfo.patientInfo[0].Gender));
    //alert(document.getElementById("female").value);
    document.getElementById(sex(PatientInfo.patientInfo[0].Gender)).checked = true;
    //document.getElementById("Gender").value = PatientInfo.patientInfo[0].Gender;
    document.getElementById("IDcardNumber").value =  PatientInfo.patientInfo[0].IDcardNumber;
    document.getElementById("Address").value =  PatientInfo.patientInfo[0].Address;   
    document.getElementById("Number1").value =  PatientInfo.patientInfo[0].Contact1;
    document.getElementById("Number2").value =  PatientInfo.patientInfo[0].Contact2;
    document.getElementById("patientID").value =  PatientInfo.patientInfo[0].ID;
    //document.getElementById("diagnosisresult").value =  PatientInfo.patientInfo[0].diagnosisresult;
    document.getElementById("doctor").value = PatientInfo.patientInfo[0].doctor;
    document.getElementById("picture1").value = PatientInfo.patientInfo[0].Picture;   
    document.getElementById("Sub").value = PatientInfo.patientInfo[0].Sub;;
    document.getElementById("Hospital").value =  PatientInfo.patientInfo[0].Hospital;
    document.getElementById("Nation").value =  PatientInfo.patientInfo[0].Nation;
    document.getElementById("Birthday").value =  PatientInfo.patientInfo[0].Birthday;
    document.getElementById("Birthday").placeholder = PatientInfo.patientInfo[0].Birthday;
    document.getElementById("height").value =  PatientInfo.patientInfo[0].Height;
    document.getElementById("weight").value = PatientInfo.patientInfo[0].Weight;
    if (PatientInfo.patientInfo[0].Picture != "") {
        document.getElementById("background-photo").style.display = "none";
        document.getElementById("photo").style.display = "inline";
        document.getElementById("photo").src = PatientInfo.patientInfo[0].Picture;
    }
    
    //doctor = PatientInfo.patientInfo[0].doctor;
    document.getElementById("operator").innerHTML = PatientInfo.patientInfo[0].Registeruser;
    document.getElementById("date").innerHTML = PatientInfo.patientInfo[0].date;
    document.getElementById("date").disabled = "true";
    //document.getElementById("userID").value = userID;
    //addDosagePriority( PatientInfo.patientInfo[0].DosagePriority);


}
function sex(evt) {
    if (evt == "F")
        return "female";
    else
        return "male";
}
//第二步诊断单中的分中心负责人选择项建立

function createdoctorItem(thiselement) {
    var doctorItem = JSON.parse(getdoctorItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-----医生选择-----");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < doctorItem.length; i++) {
        if (doctorItem[i] != "") {
            thiselement.options[i + 1] = new Option(doctorItem[i].Name);
            thiselement.options[i + 1].value = parseInt(doctorItem[i].ID);
        }
    }
}
function getdoctorItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getdoctor.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}


//表单reset函数
function resetForm(evt) {
    //所有提示清空
    document.getElementById("error").innerHTML = "";

    var allInput = document.getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].className.indexOf("invalid") > -1) {
            resetInput(allInput[i]);//恢复Input样式
        }
    }
}
//第二步部位下拉项建立

//检查各个输入项内容
function CheckInput(evt) {
    isAllGood = true;//初始默认全为通过
    //各个提示项每次初始清空
    document.getElementById("error").innerHTML = "";
    //所有元素节点数组
    var allElements = document.forms[0].getElementsByTagName("*");
    for (var i = 0; i < allElements.length; i++) {
        if (!CheckEmpty(allElements[i])) {
            isAllGood = false;
        }
    }
    if (!isAllGood) {
        evt.preventDefault();//阻止事件进行
    }
}
//检查是否为空
function CheckEmpty() {   
   
    if (document.getElementById("userName").value=="") {
        window.alert("姓名不能为空");
        return; 
    }
    if (document.getElementById("IDcardNumber").value=="") {
        window.alert("身份证不能为空");
        return;            
    }
    if (document.getElementById("RecordNumber").value=="") {
        window.alert("病案号不能为空");
        return;           
    }
    if (document.getElementById("userName").value=="") {
        window.alert("姓名不能为空");
        return;   
    }
    if (document.getElementById("Hospital").value=="") {
        window.alert("就诊医院不能为空");
        return;   
                
    }         
    if (document.getElementById("Birthday").value=="") {
        window.alert("出生日期不能为空");
        return;   
               
    }
    if (document.getElementById("Nation").value=="") {
        window.alert("民族不能为空");
        return;                  
    }
    if (document.getElementById("Address").value=="") {
        window.alert("地址不能为空");
        return;                
    }
    if (document.getElementById("Number1").value=="") {
        window.alert("电话1不能为空");
        return;                  
    } 
    if (isCardNo()) {
        window.alert("身份证格式不正确");
        return;
    }      
    if (document.getElementById("height").value=="") {
        window.alert("身高不能为空");
        return;                  
    }
    if (document.getElementById("weight").value=="") {
        window.alert("体重不能为空");
        return;                 
    }
    if (document.getElementById("Sub").value == "") {
        window.alert("请输入分中心负责人"); 
        return;   
    }
    if (document.getElementById("doctor").value == "allItem") {
        window.alert("请选择医生");        
        return;   
    }
    var form = new FormData(document.getElementById("frmRegist"));
    $.ajax({
        url: "patientRegister.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        success: function (data) {
            alert("更新成功");
            window.location.reload();
        },
        error: function (e) {
            window.location.href = "Error.aspx";
        },
        failure: function (e) {
            alert("更新失败！！");
        }
    });
}
    
//根据classname做对应的各项检查

function AlertLabel(thisNode) {
    if (thisNode.nodeName == "LABEL")
        thisNode.className += "invalid ";
}
//电话号码验证
function checkPhone() {
    var strPhoneNumber = document.getElementById("Number1").value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (!rep.test(strPhoneNumber)) {
        return true;
    }
    return false;
}
function checkPhone2() {
    var strPhoneNumber = document.getElementById("Number2").value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (!rep.test(strPhoneNumber)) {
        return true;
    }
    return false;
}
//电话号码格式规范
function phoneFormat() {
    var thisPhone = this.value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (rep.test(thisPhone)) {
        rep.exec(thisPhone);
        this.value = RegExp.$1 + "-" + RegExp.$2 + "-" + RegExp.$3;
    }
}
function isCardNo() {
    // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X  
    var card = document.getElementById("IDcardNumber").value;
    var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
    if (!reg.test(card)) {
        return true;
    }
    return false;
} 
//reset时Input样式恢复
function resetInput(thisElement) {
    var allClassName = thisElement.className.split(" ");
    var resetClassName = "";
    for (var i = 0; i < allClassName.length; i++) {
        if (allClassName[i] != "invalid") {
            resetClassName += allClassName[i] + " ";
        }
    }
    thisElement.className = resetClassName;
}
//恢复样式（取消invalid）
function recoverClassName(thisElement) {
    var returnClassName = "";
    var className = thisElement.className.split(" ");
    for (var i = 0; i < className.length; i++) {
        if (className[i] != "invalid") {
            returnClassName += className[i] + " ";
        }
    }
    thisElement.className = returnClassName;
}