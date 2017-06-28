/* ***********************************************************
 * FileName: NoticeJS.js
 * Writer: peach
 * create Date: 2017-4-2
 * ReWriter:xubixiao
 * Rewrite Date: 2017-4-15
 * impact :
 * 消息展示主页
 * **********************************************************/


window.addEventListener("load", createNotice, false)

var titleArea;
var obj;
var pageCurrent;
var notice;
var lastPageNumber;

function createNotice(evt) {
    titleArea = document.getElementById("information");
    getInformation();
    document.getElementById("currentPage").value = 1;

    notice = obj.Notice;
    lastPageNumber = Math.ceil(notice.length / 10);
    if (notice.Title == "false") {
        return;
    }
    for (var i = 0; i < 10; i++) {
        createTitle(notice[i]);
    }
    document.getElementById("previousPage").disabled = "true";
    document.getElementById("firstPage").addEventListener('click', firstPageShow, false);
    document.getElementById("nextPage").addEventListener('click', nextPageShow, false);
    document.getElementById("previousPage").addEventListener('click', previousPageShow, false);
    document.getElementById("lastPage").addEventListener('click', lastPageShow, false);


}
function firstPageShow(evt) {
    removeUlAllChild();
    release();
    for (var i = 0; i < 10; i++) {
        createTitle(notice[i]);
    }
    document.getElementById("previousPage").disabled = "true";
    document.getElementById("currentPage").value = 1;
}
function nextPageShow(evt) {
    removeUlAllChild();
    release();
    pageCurrent = parseInt(document.getElementById("currentPage").value)+ 1;
    if (pageCurrent == lastPageNumber) {
        document.getElementById("nextPage").disabled = "true";
        for (var i = 10 * pageCurrent - 10; i < notice.length ; i++) {
            createTitle(notice[i]);
        }
    }
    else {
        for (var i = 10 * pageCurrent - 10; i < 10 * pageCurrent ; i++) {
            createTitle(notice[i]);
        }
       
    }
    document.getElementById("currentPage").value = pageCurrent;

}
function previousPageShow(evt) {
    removeUlAllChild();
    release();
    pageCurrent = document.getElementById("currentPage").value - 1;
    if (pageCurrent == 1) {
        document.getElementById("previousPage").disabled = "true";
    }
    for (var i = 10 * pageCurrent - 10; i < 10 * pageCurrent; i++) {
        createTitle(notice[i]);
    }
    document.getElementById("currentPage").value = pageCurrent;
}
function lastPageShow(evt) {
    removeUlAllChild();
    release();
    pageCurrent = lastPageNumber;
    for (var i = 10 * lastPageNumber - 10; i < notice.length; i++) {
        createTitle(notice[i]);
    }
    document.getElementById("nextPage").disabled = "true";
    document.getElementById("currentPage").value = pageCurrent;
}
function release() {
    document.getElementById("nextPage").removeAttribute("disabled");
    document.getElementById("previousPage").removeAttribute("disabled");

}
function getInformation() {
    var type = getType();
    var xmlHttp = new XMLHttpRequest();
    var url = "Notice.ashx?Type=" + type;
    xmlHttp.open("GET", url, false);
    //var obj;
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;
            obj = eval("(" + getString + ")");
        }
    }
    xmlHttp.send();
    //return obj;
}

function getType() {
    var type = document.getElementById("type").value;
    return type;
}
function removeUlAllChild() {
    while (titleArea.hasChildNodes()) {
        titleArea.removeChild(titleArea.firstChild);
    }
}

function createTitle(notice) {
    var type = getType();
    var title = notice.Title;
    var time = notice.Time;
    var ID = notice.ID;
    var hot = notice.Hot;
    var New = notice.New;
   
    var spanbadage = document.createElement("SPAN");
    var textNodeNew = document.createTextNode("NEW");
    spanbadage.className = "label label-danger";
    spanbadage.appendChild(textNodeNew);


    var spanbadage2 = document.createElement("SPAN");
    var textNodeNew2 = document.createTextNode("HOT");
    spanbadage2.className = "label label-warning";
    spanbadage2.appendChild(textNodeNew2);


    var textNode = document.createTextNode(title);

    var timeNode = document.createTextNode(time);
    var Span = document.createElement("SPAN");
    Span.appendChild(timeNode);
    Span.style.cssFloat = "right";
    var linkNode = document.createElement("A");
    linkNode.href = "../Main/Notice.aspx?ID=" + ID + "&Type=" + type;
    linkNode.style.width = "100%"
    linkNode.target = "_blank";
    linkNode.appendChild(textNode);
    var hr = document.createElement("HR");
    hr.style.marginTop = "5px";
    hr.style.marginBottom = "5px";
    var linkContentNode = document.createElement("INPUT");
    linkContentNode.type = "Hidden";
    linkContentNode.value = ID;
    var li = document.createElement("LI");
    li.appendChild(Span);

    li.appendChild(linkNode);
    if (parseInt(New) == 1) {
       li.appendChild(spanbadage);
    }
    if (parseInt(hot) == 1) {
        li.appendChild(spanbadage2);
    }
    li.appendChild(hr);
    li.appendChild(linkContentNode);
    titleArea.appendChild(li);
}