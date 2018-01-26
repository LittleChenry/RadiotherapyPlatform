window.addEventListener("load", Init, false);

var userName;
var userID;
var signal = new Array();
var role;
var item11 = new Array();
var howmany = 0;
function Init(evt) {

//获得当前执行人姓名与ID,
getUserName();
getUserID();
var session = getSession();
role = session.role;
if ((typeof (userID) == "undefined")) {
    if (confirm("用户身份已经失效,是否选择重新登录?")) {
        parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
    }
}
//此处为分页代码
//alert("jy");
//document.getElementById("username").value = userID; 
var treatID = window.location.search.split("=")[1];


var patient = getPatientInfo(treatID);
document.getElementById("username").innerHTML = patient.Name;
document.getElementById("sex").innerHTML = sex(patient.Gender);
document.getElementById("age").innerHTML = patient.Age;
document.getElementById("progress").value = patient.Progress;
document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
var texthos = hosttext(patient.Hospital_ID);
document.getElementById("hospitalid").innerHTML = texthos;
document.getElementById("lightpart").innerHTML = patient.LightPart_ID;

var progress = patient.Progress.split(",");
if (isInArray(progress, '11')) {
    var designInfo = getDesignInfo(treatID);
    var fieldInfo = getFieldInfo(treatID);
    var length = designInfo.length;
    //for (var i = 0; i < length; i++) {
    $("#current-tab").text(designInfo[0].DesignName);
    if (designInfo[0].Treatmentname == patient.Treatmentname) {
        howmany = designInfo.length;
        document.getElementById("positioninfomation1").innerHTML = designInfo[0].positioninfomation1;
        
        document.getElementById("Equipment1").innerHTML = designInfo[0].equipment;
        document.getElementById("plansystem1").innerHTML = designInfo[0].PlanSystem;
        document.getElementById("Coplanar1").innerHTML = charge1(designInfo[0].Coplanar1);
        document.getElementById("Irradiation1").innerHTML = designInfo[0].Irradiation1;
        document.getElementById("Raytype1").innerHTML = designInfo[0].Raytype;
        document.getElementById("energy1").innerHTML = designInfo[0].energy1;
        document.getElementById("childdesign").value = designInfo[0].childDesign_ID;
        document.getElementById("IlluminatedNumber1").innerHTML = designInfo[0].IlluminatedNumber1;
        document.getElementById("Illuminatedangle1").innerHTML = designInfo[0].Illuminatedangle1;
        document.getElementById("MU1").innerHTML = designInfo[0].MU1;
        document.getElementById("pinyin1").innerHTML = designInfo[0].pinyin1;
        document.getElementById("radioID1").innerHTML = designInfo[0].radioID1;
        document.getElementById("ControlPoint1").innerHTML = designInfo[0].ControlPoint1;
        document.getElementById("left").innerHTML = (designInfo[0].left == "") ? "" : (designInfo[0].left + "cm");
        document.getElementById("right").innerHTML = (designInfo[0].right == "") ? "" : (designInfo[0].right + "cm");
        document.getElementById("rise").innerHTML = (designInfo[0].rise == "") ? "" : (designInfo[0].rise + "cm");
        document.getElementById("drop").innerHTML = (designInfo[0].drop == "") ? "" : (designInfo[0].drop + "cm");
        document.getElementById("enter").innerHTML = (designInfo[0].enter == "") ? "" : (designInfo[0].enter + "cm");
        document.getElementById("out").innerHTML = (designInfo[0].out == "") ? "" : (designInfo[0].out + "cm");
        document.getElementById("positioninfomation2").innerHTML = fieldInfo[0].positioninfomation2;
        document.getElementById("pinyin2").innerHTML = fieldInfo[0].pinyin2;
        document.getElementById("radioID2").innerHTML = fieldInfo[0].radioID2;
        var list = new Array();
        
        for (var i = 0; i <= designInfo.length; i++) {
            var temp = new Array();
            list.push(temp);
            signal.push(0);
            item11.push(0);           
        }
        for(var j=0;j<designInfo.length;j++)
        {
            for(var i=0;i<fieldInfo.length;i++){
                if(designInfo[j].childDesign_ID==fieldInfo[i].childdesign_ID){                
                    list[j].push(fieldInfo[i]);                
                }           
            }
        }
        document.getElementById("dose2").innerHTML = list[0][0].dose2;
        document.getElementById("Equipment2").innerHTML = list[0][0].Equipment2;
        document.getElementById("plansystem2").innerHTML = list[0][0].plansystem2;
        document.getElementById("remark").value = list[0][0].remark;
        document.getElementById("Coplanar2").innerHTML = charge3(list[0][0].Coplanar2);
        document.getElementById("Raytype2").innerHTML = list[0][0].Raytype2;
        document.getElementById("energy2").innerHTML = list[0][0].energy2;
        for (i = 0; i < list.length; i++) {            
            document.getElementById("Irradiation2").innerHTML = charge4(list[0]);
            document.getElementById("IlluminatedNumber2").innerHTML = list[0].length;
            document.getElementById("Illuminatedangle2").innerHTML = ruler(list[0]);
            document.getElementById("MU2").innerHTML = cale2(list[0]);
            document.getElementById("ControlPoint2").innerHTML = cale3(list[0]);
        }
    }
    if (designInfo.length > 1) {
        for (var i = 1; i < designInfo.length; i++) {
            var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + designInfo[i].DesignName + '</a></li>';
            var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row"><input type="hidden"  id="TechnologyConfirm1_' + i + '" name="TechnologyConfirm1_' + i + '" value="0"/>' +
                          '<input type="hidden"  id="confirmPlanSystem1_' + i + '" name="confirmPlanSystem1_' + i + '" value="0"/><input type="hidden"  id="EquipmentConfirm1_' + i + '" name="EquipmentConfirm1_' + i + '" value="0"/>' +
                          '<input type="hidden"  id="childdesign_' + i + '" name="childdesign_' + i + '" value="' + designInfo[i].childDesign_ID + '"/><div class="col-xs-12"><div class="pull-right">' +
                          '<button id="Forced_' + i + '" type="button" class="btn btn-success" onclick="force(' + i + ')" disabled="disabled" style="margin-left:10px;">强制通过</button>' +
                          '<button id="confirm_' + i + '" type="button" class="btn btn-success" onclick="check('+i+')" disabled="disabled" style="margin-left:10px;">自动复核</button>' +
                          '<button id="save_' + i + '" type="button" class="btn btn-success" disabled="disabled" onclick="savereview(' + i + ')" style="margin-left:10px;">保存</button></div></div></div>' +
                          '<div class="single-row"><div class="item area-group col-xs-12"><table class="table table-bordered" style="word-break:break-all;">' +
                          '<thead><tr><th style="width:8%;text-align:center;">序号</th><th style="width:22%;text-align:center;">复核项</th><th style="width:25%;text-align:center;">计划信息</th>' +
                          '<th style="width:25%;text-align:center;">导入信息</th><th style="width:20%;text-align:center;">复核结果</th></tr></thead>';
            var content1 = '<tbody style="text-align: center;"><tr><td>1</td><td>姓名（拼音）</td><td id="pinyin1_' + i + '">' + designInfo[i].pinyin1 + '</td><td id="pinyin2_' + i + '">' + list[i][0].pinyin2 + '</td><td id="check13_' + i + '"></td>' +
                          '</tr><tr><td>2</td><td>放疗号</td><td id="radioID1_' + i + '">' + designInfo[i].radioID1 + '</td><td id="radioID2_' + i + '">' + list[i][0].radioID2 + '</td><td id="check14_' + i + '"></td>' +
                          '</tr><tr><td>3</td><td>摆位信息</td><td id="positioninfomation1_' + i + '">' + designInfo[i].positioninfomation1 + '</td><td id="positioninfomation2_' + i + '">' + list[i][0].positioninfomation2 + '</td><td id="check1_' + i + '"></td>' +
                          '</tr><tr><td>4</td><td>分次剂量/总剂量</td><td id="dose1_' + i + '"><select id="designdose_' + i + '" disabled="disabled" class="form-item" name="designdose_' + i + '"></select></td><td id="dose2_' + i + '">' + list[i][0].dose2 + '</td><td id="check2_' + i + '"></td></tr>' +
                          '<tr><td>5</td><td>放疗设备</td><td id="Equipment1_' + i + '">' + designInfo[i].equipment + '</td><td id="Equipment2_' + i + '">' + list[i][0].Equipment2 + '</td><td id="check3_' + i + '"></td></tr>' +
                          '<tr><td>6</td><td>放疗计划系统</td><td id="plansystem1_' + i + '">' + designInfo[i].PlanSystem + '</td><td id="plansystem2_' + i + '">' + list[i][0].plansystem2 + '</td><td id="check4_' + i + '"></td></tr>' +
                          '<tr><td>7</td><td>照射技术</td><td id="Irradiation1_' + i + '">' + designInfo[i].Irradiation1 + '</td><td id="Irradiation2_' + i + '">' + charge4(list[i]) + '</td><td id="check5_' + i + '"></td></tr>' +
                          '<tr><td>8</td><td>射线类型</td><td id="Raytype1_' + i + '">' + designInfo[i].Raytype + '</td><td id="Raytype2_' + i + '">' + list[i][0].Raytype2 + '</td><td id="check6_' + i + '"></td></tr><tr>' +
                          '<td>9</td><td>能量</td><td id="energy1_' + i + '" >' + designInfo[i].energy1 + '</td><td id="energy2_' + i + '">' + list[i][0].energy2 + '</td><td id="check7_' + i + '"></td></tr>';
            var content2 = '<tr><td>10</td><td>射野数量</td><td id="IlluminatedNumber1_' + i + '" >' + designInfo[i].IlluminatedNumber1 + '</td><td id="IlluminatedNumber2_' + i + '">' + list[i].length + '</td><td id="check8_' + i + '"></td></tr>' +
                          '<tr><td>11</td><td>射野角度</td><td id="Illuminatedangle1_' + i + '" >' + designInfo[i].Illuminatedangle1 + '</td><td id="Illuminatedangle2_' + i + '">' + ruler(list[i]) + '</td><td id="check9_' + i + '"></td></tr>' +
                          '<tr><td>12</td><td>机器跳数</td><td id="MU1_' + i + '" >' + designInfo[i].MU1 + '</td><td id="MU2_' + i + '">' + cale2(list[i]) + '</td><td id="check10_' + i + '"></td></tr>' +
                          '<tr><td>13</td><td>控制点数量</td><td id="ControlPoint1_' + i + '" >' + designInfo[i].ControlPoint1 + '</td><td id="ControlPoint2_' + i + '">' + cale3(list[i]) + '</td><td id="check11_' + i + '"></td></tr>';
            var content6 = '<tr><td>14</td><td>非共面照射</td><td id="Coplanar1_' + i + '" >' + charge1(designInfo[i].Coplanar1) + '</td><td id="Coplanar2_' + i + '">' + charge3(list[i][0].Coplanar2) + '</td><td id="check12_' + i + '"></td></tr></tbody></table></div></div>' +
                          '<div class="single-row"><div class="col-xs-12"><table class="table table-bordered" style="table-layout:fixed;"><thead style="text-align:center;">' +
                          '<tr><th style="width:8%;">序号</th><th style="width:22%;">复核项</th><th colspan="4">复核内容</th><th style="width:20%;">手动复核</th></tr></thead>'+
                          '<tbody style="text-align:center;"><tr><td rowspan="3">13</td><td rowspan="3">移床参数</td><td>左</td><td>' + ((designInfo[i].left == "") ? "" : (designInfo[i].left + "cm"))+ '</td>';
            var content3 = '<td>右</td><td>' + ((designInfo[i].right == "") ? "" : (designInfo[i].right + "cm")) + '</td><td rowspan="3" id="check97_' + i + '">' +
                          '<button id="confirmCoplanar_' + i + '" class="btn btn-success" type="button" onclick="confirm1(this,confirmCoplanar_' + i + ', cancelconfirmCoplanar_' + i + ',TechnologyConfirm1_' + i + ')" disabled="disabled" style="margin:auto;">通过</button>' +
                          '<button id="cancelconfirmCoplanar_' + i + '" class="btn btn-warning" type="button" onclick="cancelconfirm(this,confirmCoplanar_' + i + ', cancelconfirmCoplanar_' + i + ',TechnologyConfirm1_' + i + ')" style="display:none;margin:auto;" >取消通过</button>';
            var content7='</td></tr><tr><td>升</td><td>' + ((designInfo[i].rise == "") ? "" : (designInfo[i].rise + "cm")) + '</td><td>降</td><td>' + ((designInfo[i].drop == "") ? "" : (designInfo[i].drop + "cm")) + '</td></tr>' +
                          '<tr><td>进</td><td>' + ((designInfo[i].enter == "") ? "" : (designInfo[i].enter + "cm")) + '</td><td>出</td><td>' + ((designInfo[i].out == "") ? "" : (designInfo[i].out + "cm")) + '</td></tr>' +
                          '<tr><td>14</td><td>治疗计划打印与传输</td><td colspan="4"></td><td id="check98_' + i + '">';
            var content5 = '<button id="Button1_' + i + '" class="btn btn-success" type="button" onclick="confirm1(this,Button1_' + i + ',Button2_' + i + ',confirmPlanSystem1_' + i + ')" disabled="disabled" style="margin:auto;">通过</button>' +
                          '<button id="Button2_' + i + '" class="btn btn-warning" type="button" onclick="cancelconfirm(this,Button1_' + i + ',Button2_' + i + ',confirmPlanSystem1_' + i + ')" style="display:none;margin:auto;" >取消通过</button>' +
                          '</td></tr><tr><td>15</td><td>参考图像传输</td><td colspan="4"></td><td id="check99_' + i + '">';
            var content8 = '<button id="Button3_' + i + '" class="btn btn-success" type="button" onclick="confirm1(this,Button3_' + i + ',Button4_' + i + ',EquipmentConfirm1_' + i + ')" disabled="disabled" style="margin:auto;">通过</button>' +
                          '<button id="Button4_' + i + '" class="btn btn-warning" type="button" onclick="cancelconfirm(this,Button3_' + i + ',Button4_' + i + ',EquipmentConfirm1_' + i + ')" style="display:none;margin:auto;" >取消通过</button>';
            var content4='</td></tr><tr><td>16</td><td>放疗计划QA</td><td colspan="4"><span class="col-xs-6"><input type="radio" name="planQA_' + i + '" id="yes_' + i + '" value="1" disabled="disabled"/>执行</span>' +
                          '<span class="col-xs-6"><input type="radio" name="planQA_' + i + '" id="no_' + i + '" value="0" disabled="disabled"/>未执行</span></td><td></td></tr><tr>' +
                          '<td>17</td><td>通过率</td><td colspan="4"><input name="degree_' + i + '" id="degree_' + i + '" class="form-item" disabled="disabled"/></td><td></td></tr>' +
                          '<tr><td>18</td><td>备注条件</td><td colspan="4"><input name="remark_' + i + '" id="remark_' + i + '" class="form-item" disabled="disabled" value="'+list[i][0].remark+'"/></td><td></td></tr></tbody></table></div></div>' +
                          '<div id="pdfplan_' + i + '" class="single-row"><div id="firstplan_' + i + '" class="col-xs-12"><span class="form-text col-xs-2" style="padding-left:0px;">计划PDF上传：</span>' +
                          '<div class="group-item col-xs-3"><input id="fp_upload_' + i + '" type="file" accept="application/pdf" name="fp_upload_' + i + '" disabled="disabled"/></div></div></div>' +
                          '<div  id="reviewplan_' + i + '" class="single-row"><div  id="secondplan_' + i + '" class="col-xs-12"><span class="form-text col-xs-2" style="padding-left:0px;">复核PDF上传：</span>' +
                          '<div class="group-item col-xs-3"><input id="fp_upload1_' + i + '" type="file" accept="application/pdf" name="fp_upload1_' + i + '" disabled="disabled"/>' +
                          '</div></div></div></div>';
            //alert(content2);
            $("#tabs").append(tab);
            $("#tab-content").append(content + content1 + content2 + content6 + content3 + content7 + content5 + content8 + content4);         
        }
    }
    cale(designInfo[0].DosagePriority);
    document.getElementById("userID").value = userID;
    document.getElementById("applyuser").innerHTML = userName;
    document.getElementById("time").innerHTML = getNowFormatDate();
    document.getElementById("hidetreatID").value = treatID;
    for (var i = 0; i < designInfo.length; i++) {
        var gggg = "";
        if (i != 0) {
            gggg = "_" + i;
        }
        document.getElementById("yes" + gggg).checked = true;
        var $radio1 = $('input[name="planQA' + gggg + '"]:eq(0)');
        var $radio2 = $('input[name="planQA' + gggg + '"]:eq(1)');
        $radio2.bind('click', function () {
            document.getElementById("degree" + gggg).disabled = "disabled";
            document.getElementById("remark" + gggg).disabled = "disabled";
        });
        $radio1.bind('click', function () {
            if (document.getElementById("yes" + gggg).disabled != "disabled") {
                document.getElementById("degree" + gggg).removeAttribute("disabled");
                document.getElementById("remark" + gggg).removeAttribute("disabled");
            }
        });
    }
    if (isInArray(progress, '12')) {
        var reviewInfo = getReviewInfo(treatID);
        for (var i = 0; i < reviewInfo.length; i++) {
            for (var j = 0; j < designInfo.length; j++) {
                if (j == 0) {
                    var gg = "";
                } else {
                    var gg = "_" + j;
                }
                if (document.getElementById("childdesign" + gg).value == reviewInfo[i].childdesign) {
                    item11[j] = 1;
                    var objSelect = document.getElementById("designdose" + gg);
                    var objItemText=reviewInfo[i].SelectDose;
                    jsSelectItemByValue(objSelect, objItemText);
                    document.getElementById(plan(reviewInfo[i].PlanQA)).checked = true;
                    document.getElementById("degree"+gg).value = reviewInfo[i].degree;
                    document.getElementById("remark"+gg).value = reviewInfo[i].Remark;
                    if (reviewInfo[i].sum == "1") {
                        signal[j] = 1;
                        document.getElementById("TechnologyConfirm1"+gg).value = 1;
                        document.getElementById("confirmPlanSystem1"+gg).value = 1;
                        document.getElementById("EquipmentConfirm1"+gg).value = 1;
                        document.getElementById("check1"+gg).innerHTML = "通过";
                        document.getElementById("check1"+gg).style.color = "#0000ff";
                        document.getElementById("check2"+gg).innerHTML = "通过";
                        document.getElementById("check2"+gg).style.color = "#0000ff";
                        document.getElementById("check3"+gg).innerHTML = "通过";
                        document.getElementById("check4"+gg).innerHTML = "通过";
                        document.getElementById("check5"+gg).innerHTML = "通过";
                        document.getElementById("check6"+gg).innerHTML = "通过";
                        document.getElementById("check7"+gg).innerHTML = "通过";
                        document.getElementById("check8"+gg).innerHTML = "通过";
                        document.getElementById("check9"+gg).innerHTML = "通过";
                        document.getElementById("check10"+gg).innerHTML = "通过";
                        document.getElementById("check11"+gg).innerHTML = "通过";
                        document.getElementById("check12"+gg).innerHTML = "通过";
                        document.getElementById("check13"+gg).innerHTML = "通过";
                        document.getElementById("check14"+gg).innerHTML = "通过";
                        document.getElementById("check97"+gg).innerHTML = "通过";
                        document.getElementById("check97"+gg).style.color = "#0000ff";
                        document.getElementById("check98"+gg).innerHTML = "通过";
                        document.getElementById("check98"+gg).style.color = "#0000ff";
                        document.getElementById("check99"+gg).innerHTML = "通过";
                        document.getElementById("check99"+gg).style.color = "#0000ff";
                        document.getElementById("check3"+gg).style.color = "#0000ff";
                        document.getElementById("check4"+gg).style.color = "#0000ff";
                        document.getElementById("check5"+gg).style.color = "#0000ff";
                        document.getElementById("check6"+gg).style.color = "#0000ff";
                        document.getElementById("check7"+gg).style.color = "#0000ff";
                        document.getElementById("check8"+gg).style.color = "#0000ff";
                        document.getElementById("check9"+gg).style.color = "#0000ff";
                        document.getElementById("check10"+gg).style.color = "#0000ff";
                        document.getElementById("check11"+gg).style.color = "#0000ff";
                        document.getElementById("check12"+gg).style.color = "#0000ff";
                        document.getElementById("check13"+gg).style.color = "#0000ff";
                        document.getElementById("check14"+gg).style.color = "#0000ff";
                        document.getElementById("applyuser").innerHTML = reviewInfo[i].name;
                        document.getElementById("time").innerHTML = reviewInfo[i].ReviewTime;
                        if (reviewInfo[i].PDF1 != "") {
                            var content = '<div class="group-item col-xs-3"><a href="' + reviewInfo[i].PDF1 + '"target="_blank"   class="btn btn-default">查看已传计划PDF文档</a></div>';
                            $("#firstplan" + gg).append(content);

                        }
                        if (reviewInfo[i].PDF2 != "") {
                            var content = '<div class="group-item col-xs-3"><a href="' + reviewInfo[i].PDF2 + '"target="_blank"   class="btn btn-default">查看已传复核PDF文档</a></div>';
                            $("#secondplan" + gg).append(content);

                        }
                    }
                }
            }
        }
                
        if (reviewInfo.userID == userID) {
            window.parent.document.getElementById("edit").removeAttribute("disabled");
        }

        }
    }
}

function numSub(num1, num2) {
    var baseNum, baseNum1, baseNum2;
    try {
        baseNum1 = num1.toString().split(".")[1].length;
    } catch (e) {
        baseNum1 = 0;
    }
    try {
        baseNum2 = num2.toString().split(".")[1].length;
    } catch (e) {
        baseNum2 = 0;
    }
    baseNum = Math.pow(10, Math.max(baseNum1, baseNum2));
    var precision = (baseNum1 >= baseNum2) ? baseNum1 : baseNum2;
    return ((num1 * baseNum - num2 * baseNum) / baseNum).toFixed(precision);
}
function jsSelectItemByValue(objSelect, objItemText) {
    //判断是否存在 
    var isExit = false;
    for (var i = 0; i < objSelect.options.length; i++) {
        if (objSelect.options[i].text == objItemText) {
            objSelect.options[i].selected = true;
            isExit = true;
            break;
        }
    }
}
function check(gg) {
    var item = 1;
    signal[gg] = 1;
    var i = "";
    if (gg != 0) {
        i = '_'+gg;
    }
    if (document.getElementById("positioninfomation1"+i).innerHTML == document.getElementById("positioninfomation2"+i).innerHTML) {
        document.getElementById("check1"+i).innerHTML = "通过";
        document.getElementById("check1"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check1"+i).innerHTML = "不通过";
        document.getElementById("check1"+i).style.color = "#ff0000";
    }
    var objSelect = document.getElementById("designdose" + i);
    var currSelectText = objSelect.options[objSelect.selectedIndex].text;
    if (currSelectText == document.getElementById("dose2" + i).innerHTML) {
        document.getElementById("check2"+i).innerHTML = "通过";
        document.getElementById("check2"+i).style.color = "#0000ff";
    }
    else {
        item = 0;
        document.getElementById("check2"+i).innerHTML = "不通过";
        document.getElementById("check2"+i).style.color = "#ff0000";
    }
    var equipment = document.getElementById("Equipment1"+i).innerHTML;
    var dreg = /(\d*)([a-z]*[A-Z]*)(\d*)/;
    dreg.exec(equipment);
    var deleteEChar = RegExp.$1 + RegExp.$3;
    if (deleteEChar == document.getElementById("Equipment2"+i).innerHTML) {
        document.getElementById("check3"+i).innerHTML = "通过";
        document.getElementById("check3"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check3"+i).innerHTML = "不通过";
        document.getElementById("check3"+i).style.color = "#ff0000";
    }
    if (document.getElementById("plansystem1"+i).innerHTML == document.getElementById("plansystem2"+i).innerHTML) {
        document.getElementById("check4"+i).innerHTML = "通过";
        document.getElementById("check4"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check4"+i).innerHTML = "不通过";
        document.getElementById("check4"+i).style.color = "#ff0000";
    }
    if (document.getElementById("Coplanar1"+i).innerHTML == document.getElementById("Coplanar2"+i).innerHTML) {
        document.getElementById("check12"+i).innerHTML = "通过";
        document.getElementById("check12"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check12"+i).innerHTML = "不通过";
        document.getElementById("check12"+i).style.color = "#ff0000";
    }
    if (document.getElementById("Irradiation1"+i).innerHTML.toLowerCase() == document.getElementById("Irradiation2"+i).innerHTML.toLowerCase()) {
        document.getElementById("check5"+i).innerHTML = "通过";
        document.getElementById("check5"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check5"+i).innerHTML = "不通过";
        document.getElementById("check5"+i).style.color = "#ff0000";
    }
    if (document.getElementById("Raytype1"+i).innerHTML == document.getElementById("Raytype2"+i).innerHTML) {
        document.getElementById("check6"+i).innerHTML = "通过";
        document.getElementById("check6"+i).style.color = "#0000ff";

    } else {
        item = 0;
        document.getElementById("check6"+i).innerHTML = "不通过";
        document.getElementById("check6"+i).style.color = "#ff0000";
    }
    var enery = document.getElementById("energy1"+i).innerHTML;
    var reg = /(\d*)([a-z]*[A-Z]*)(\d*)/;
    reg.exec(enery);
    var deleteChar = RegExp.$1 + RegExp.$3;
    if (deleteChar == parseInt(document.getElementById("energy2"+i).innerHTML)) {
        document.getElementById("check7"+i).innerHTML = "通过";
        document.getElementById("check7"+i).style.color = "#0000ff";

    } else {
        item = 0;
        document.getElementById("check7"+i).innerHTML = "不通过";
        document.getElementById("check7"+i).style.color = "#ff0000";
    }
    if (document.getElementById("IlluminatedNumber1"+i).innerHTML == document.getElementById("IlluminatedNumber2"+i).innerHTML) {
        document.getElementById("check8"+i).innerHTML = "通过";
        document.getElementById("check8"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check8"+i).innerHTML = "不通过";
        document.getElementById("check8"+i).style.color = "#ff0000";
    }
    if (isequal(i)) {
        document.getElementById("check9"+i).innerHTML = "通过";
        document.getElementById("check9"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check9"+i).innerHTML = "不通过";
        document.getElementById("check9"+i).style.color = "#ff0000";
    }
    if (isequal1(i)) {
        document.getElementById("check10"+i).innerHTML = "通过";
        document.getElementById("check10"+i).style.color = "#0000ff";
       
    } else {
        item = 0;
        document.getElementById("check10"+i).innerHTML = "不通过";
        document.getElementById("check10"+i).style.color = "#ff0000";
    }
    if (document.getElementById("ControlPoint1"+i).innerHTML == document.getElementById("ControlPoint2"+i).innerHTML) {
        document.getElementById("check11"+i).innerHTML = "通过";
        document.getElementById("check11"+i).style.color = "#0000ff";
        
    } else {
        item = 0;
        document.getElementById("check11"+i).innerHTML = "不通过";
        document.getElementById("check11"+i).style.color = "#ff0000";

    }
    if (pinyinequal(i)) {
        document.getElementById("check13"+i).innerHTML = "通过";
        document.getElementById("check13"+i).style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check13"+i).innerHTML = "不通过";
        document.getElementById("check13"+i).style.color = "#ff0000";

    }
    if (document.getElementById("radioID1"+i).innerHTML == document.getElementById("radioID2"+i).innerHTML) {
        document.getElementById("check14"+i).innerHTML = "通过";
        document.getElementById("check14"+i).style.color = "#0000ff";

    } else {
        item = 0;
        document.getElementById("check14"+i).innerHTML = "不通过";
        document.getElementById("check14"+i).style.color = "#ff0000";

    }
    if (item == 0) {
        signal[gg] = 0;
    }
}
function pinyinequal(i) {
    var text = document.getElementById("pinyin1"+i).innerHTML;
    var value = text.replace(/[^a-zA-Z]/ig, "");
    return value.toLowerCase() == document.getElementById("pinyin2"+i).innerHTML.toLowerCase()
}
function isequal1(gg) {
    var str1 = document.getElementById("MU1"+gg).innerHTML;
    var str2 = document.getElementById("MU2"+gg).innerHTML;
    var num1 = Math.round(str1 * 1);
    var num2 = Math.round(str2 * 1);
    if (num1 == num2) {
        return true;
    } else {
        return false;
    }
}
function force(gg) {
    signal[gg] = 1;
    var i = "";
    if (gg != 0) {
        i = '_' + gg;
    }
    document.getElementById("check1"+i).innerHTML = "通过";
    document.getElementById("check2"+i).innerHTML = "通过";
    document.getElementById("check3"+i).innerHTML = "通过";
    document.getElementById("check4"+i).innerHTML = "通过";
    document.getElementById("check5"+i).innerHTML = "通过";
    document.getElementById("check6"+i).innerHTML = "通过";
    document.getElementById("check7"+i).innerHTML = "通过";
    document.getElementById("check8"+i).innerHTML = "通过";
    document.getElementById("check9"+i).innerHTML = "通过";
    document.getElementById("check10"+i).innerHTML = "通过";
    document.getElementById("check11"+i).innerHTML = "通过";
    document.getElementById("check12"+i).innerHTML = "通过";
    document.getElementById("check13"+i).innerHTML = "通过";
    document.getElementById("check14"+i).innerHTML = "通过";
    document.getElementById("check1"+i).style.color = "#0000ff";
    document.getElementById("check2"+i).style.color = "#0000ff";
    document.getElementById("check3"+i).style.color = "#0000ff";
    document.getElementById("check4"+i).style.color = "#0000ff";
    document.getElementById("check5"+i).style.color = "#0000ff";
    document.getElementById("check6"+i).style.color = "#0000ff";
    document.getElementById("check7"+i).style.color = "#0000ff";
    document.getElementById("check8"+i).style.color = "#0000ff";
    document.getElementById("check9"+i).style.color = "#0000ff";
    document.getElementById("check10"+i).style.color = "#0000ff";
    document.getElementById("check11"+i).style.color = "#0000ff";
    document.getElementById("check12"+i).style.color = "#0000ff";
    document.getElementById("check13"+i).style.color = "#0000ff";
    document.getElementById("check14"+i).style.color = "#0000ff";
}
function isequal(gg) {
    var str2 = document.getElementById("Illuminatedangle2"+gg).innerHTML;
    var str1 = document.getElementById("Illuminatedangle1"+gg).innerHTML;
    var array1 = new Array();
    array1 = str1.split(",");
    var array2 = new Array();
    array2 = str2.split(",");
    if (array1.length != array2.length) {
        return false;
    }
    var sign = new Array();
    for (var i = 0; i < array1.length; i++) {
        for (var j = 0; j < array2.length; j++) {
            if (qq(array1[i],array2[j])) {
                sign[i] = 1;
                break;
            } else {
                sign[i] = 0;
            }
        }
    }
    for (var k = 0; k < sign.length; k++) {
        if (sign[k] == 0) {
            return false;
        }
    }
    return true;
}
function qq(a1, a2) {
    if (isInArray(a1, "/")) {
        if (!isInArray(a2, "/")) {
            return false;
        } else {
            if (a1.split("/")[0]*1 == a2.split("/")[0]*1 && a1.split("/")[1]*1 == a2.split("/")[1]*1) {
                return true;
            } else {
                return false;
            }
        }
    } else {
        if (a1 * 1 == a2 * 1) {
            return true;
        } else {
            return false;
        }
    }
   
}
function charge4(arr) {
    var count = 1;
    var array = new Array();
    for (var item in arr) {
        array[item] = arr[item].Irradiation2;
    }
    var yuansu = new Array();
 
    for (var i = 0; i < array.length; i++) {
        if (array[i].toLowerCase() == "3DCRT".toLowerCase() || array[i].toLowerCase() == "Step and shot".toLowerCase() || array[i].toLowerCase() == "Static".toLowerCase()) {
            yuansu[i]= "Static";
        }
        if (array[i].toLowerCase() == "dMLC".toLowerCase() || array[i].toLowerCase() == "VMAT".toLowerCase() || array[i].toLowerCase() == "Dynamic".toLowerCase()) {
            yuansu[i] = "Dynamic";
        }
    }
    for (var j = 0; j < yuansu.length; j++) {
        if (yuansu[j] != yuansu[0]) {
            return "Dynamic,Static"
        }
    }
    return yuansu[0];
}
function confirm1(input, Button, cancelButton,confirm) {
    var content = input.innerHTML;
    if (content == "通过") {
        confirm.value = 1;
    }
    Button.style.display = "none";
    cancelButton.style.display = "block";
}

function cancelconfirm(input, Button, cancelButton,confirm) {
    var content = input.innerHTML;
    if (content == "取消通过") {
        confirm.value = 0;
    }
    Button.style.display = "block";
    cancelButton.style.display = "none";
}
function ruler(arr) {
    var array = new Array();
    var str = "";
    for (var item in arr) {
        array[item] = arr[item].Illuminatedangle2;
    }
    
    for (var i = 0; i < array.length-1; i++) {
        str = str+array[i]+","
    }
    str = str + array[array.length - 1];
    return str;
}
function cale2(arr) {
    var array = new Array();
    for (var item in arr) {
        array[item] = arr[item].MU2 * 1;
    }
    var len = array.length;
    var sum = 0;
    for (var i = 0; i < len; i++) {
        sum += array[i];
    }
    sum = parseInt(sum * Math.pow(10, 6) + 0.5, 10) / Math.pow(10, 6);
    return sum;
}
function cale3(arr) {
    var array = new Array();
    for (var item in arr) {
        array[item] = arr[item].ControlPoint2 * 1;
    }
    var len = array.length;
    var sum = 0;
    for (var i = 0; i < len; i++) {
        sum += array[i];
    }

    return sum;
}
//function createdegreeItem(thiselement) {
//    var PartItem = JSON.parse(getdegreeItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--优化程度选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getdegreeItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getdegree.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
//function createplaceinfoItem(thiselement) {
//    var PartItem = JSON.parse(getplaceinfoItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--信息选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getplaceinfoItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getplaceinfo.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
//function createdrrItem(thiselement) {
//    var PartItem = JSON.parse(getdrrItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--drr选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getdrrItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getdrr.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
//function createimportItem(thiselement) {
//    var PartItem = JSON.parse(getimportItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--导出选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getimportItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getimport.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i]) {
            return true;
        }
    }
    return false;
}
function hosttext(str) {
    if (str == "") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
    }
}
function cale(str) {
    var lists = new Array();
    var dose = new Array();
    lists = str.split(";");
    var a = 0;
    for (var j = 0; j < howmany; j++) {
        var gg = "";
        if (j != 0) {
            gg = '_' + j;
        }
        var objSelect = document.getElementById("designdose" + gg);
        objSelect.options[0] = new Option("--剂量选择--");
        objSelect.options[0].value = "allItem";
        for (var i = 0; i < lists.length-1; i++) {
            objSelect.options[i+1] = new Option(lists[i].split(",")[3] + "/" + lists[i].split(",")[5]);
            objSelect.options[i + 1].value = i+1;
        }
    }
    //for (var i = 0; i < lists.length; i++) {
    //    var list = new Array();
    //    list = lists[i].split(",");
    //    dose[a] = list[5];
    //    a++;
    //}
    //var max = 0;
    //var len = dose.length;
    //if (len = 1) {
    //    return lists[0].split(",")[3] + "/" + lists[0].split(",")[5];
    //} else {
    //    for (var i = 1; i < len; i++) {
    //        if (dose[i] > max) {
    //            max = i;
    //        }
    //    }
    //    return lists[max].split(",")[3] + "/" + lists[max].split(",")[5];
    //}
}
function getReviewInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "ReviewInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.reviewInfo;
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designReviewInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo;
}
function getFieldInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "FieldConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo;
}
function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}
function getPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
}

function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var min = date.getMinutes();
    if (min < 10) {
        min = "0" + min;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + min;

    return currentdate;
}

function getUserName() {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetUserName.ashx";
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
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}
function charge(evt) {
    if (evt == "0")
        return "不可执行";
    else
        return "可执行";
}
function charge1(evt) {
    if (evt == "0")
        return "不是";
    else
        return "是";
}
function charge3(evt) {
    if (evt == "0.0")
        return "不是";
    else
        return "是";
}
function charge2(evt) {
    if (evt == "0")
        return "不通过";
    else
        return "通过";
}
function getreference(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("ReferenceCenterX").value = Reference[0];
    document.getElementById("ReferenceCenterY").value = Reference[1];
    document.getElementById("ReferenceCenterZ").value = Reference[2];
}
function gettreatment(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("TreatmentCenterX").value = Reference[0];
    document.getElementById("TreatmentCenterY").value = Reference[1];
    document.getElementById("TreatmentCenterZ").value = Reference[2];
}
function getmovement(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("MovementX").value = Reference[0];
    document.getElementById("MovementY").value = Reference[1];
    document.getElementById("MovementZ").value = Reference[2];
}
function save() {
}
function savereview(gg) {
    var i = "";
    if (gg != 0) {
        i = '_' + gg;
    }
    if (signal[gg] == 0) {
        window.alert("请核对正确");
        return false;
    }
    if (document.getElementById("TechnologyConfirm1"+i).value == 0) {
        window.alert("请核对正确");
        return false;
    }
    if (document.getElementById("confirmPlanSystem1"+i).value == 0) {
        window.alert("请核对正确");
        return false;
    }
    if (document.getElementById("EquipmentConfirm1"+i).value == 0) {
        window.alert("请核对正确");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("saveReview"));
    form.append("item", gg);
    var objSelect = document.getElementById("designdose" + i);
    var currSelectText = objSelect.options[objSelect.selectedIndex].text;
    form.append("selectdose", currSelectText);
    $.ajax({
        url: "designReviewRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        async: false,
        contentType: false,
        success: function (data) {
            if (data == "success") {
                alert("保存成功");
            } else {
                alert("保存失败");
                return false;
            }
            window.location.reload();
        },
        error: function (e) {
            window.location.href = "Error.aspx";
        },
        failure: function (e) {
            window.location.href = "Error.aspx";
        }
    });
}
function remove() {
    for (var i = 0; i < howmany; i++) {
        var gg = "";
        if (i != 0) {
            gg = '_' + i;
        }
        document.getElementById("designdose" + gg).removeAttribute("disabled");
        document.getElementById("confirm" + gg).removeAttribute("disabled");
        document.getElementById("save" + gg).removeAttribute("disabled");
        if (role == "科主任") {
            document.getElementById("Forced"+gg).removeAttribute("disabled");
        }
        if (item11[i] == 0) {
            document.getElementById("confirmCoplanar"+gg).removeAttribute("disabled");
            document.getElementById("Button1"+gg).removeAttribute("disabled");
            document.getElementById("Button3"+gg).removeAttribute("disabled");
        }
        document.getElementById("degree"+gg).removeAttribute("disabled");
        document.getElementById("degree"+gg).removeAttribute("disabled");
        document.getElementById("remark"+gg).removeAttribute("disabled");
        var add = document.getElementsByName("planQA" + gg);
        add[0].removeAttribute("disabled");
        add[1].removeAttribute("disabled");
        document.getElementById("fp_upload1"+gg).removeAttribute("disabled");
        document.getElementById("fp_upload"+gg).removeAttribute("disabled");
    }
}
function plan(evt) {
    if (evt == "1")
        return "yes";
    else
        return "no";
}