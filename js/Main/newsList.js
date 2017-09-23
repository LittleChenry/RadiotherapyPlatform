window.addEventListener("load", createManageTable, false)
var titleArea;
var obj;
var pageCurrent;
var notice;
var lastPageNumber;

$(document).ready(function () {
    var session = getSession();
    if (session.role != "物理师" && session.role != "模拟技师" && session.role != "治疗技师") {
         $("#Menu-EquipmentView").attr("href", "javascript:;");
         $("#Menu-EquipmentView").bind("click", function(){
            alert("权限不够！");
         });
    }
});

function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
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

function createManageTable(evt) {
    titleArea = document.getElementById("infomanagetable");
    var Role = window.location.search.split("=")[1];
    document.getElementById("type").value = Role;
    getInformation();
    notice = obj.Notice;
    lastPageNumber = Math.ceil(notice.length / 20);
    if (notice.Title == "false") {
        return;
    }
    if (lastPageNumber == 1) {
        for (var i = 0; i < notice.length; i++) {
            createTable(notice[i]);
        }
        document.getElementById("nextPage").disabled = "true";
        document.getElementById("previousPage").disabled = "true";
    } else {
        for (var i = 0; i < 10; i++) {
            createTable(notice[i]);
        }
        document.getElementById("previousPage").disabled = "true";
    }
    document.getElementById("currentPage").value = 1;
    document.getElementById("firstPage").addEventListener('click', firstPageShow, false);
    document.getElementById("nextPage").addEventListener('click', nextPageShow, false);
    document.getElementById("previousPage").addEventListener('click', previousPageShow, false);
    document.getElementById("lastPage").addEventListener('click', lastPageShow, false);
}

function createTable(notice) {
    var type = getType();
    var title = notice.Title;
    var time = notice.Time;
    var ID = notice.ID;
    var imp = notice.Important;
    var ReleaseUserName = notice.ReleaseUserName;
    var textNode = document.createTextNode(title);


    var spanbadage = document.createElement("SPAN");
    var textNodeNew = document.createTextNode("NEW");
    spanbadage.className = "label label-danger";
    spanbadage.appendChild(textNodeNew);
    var h5 = document.createElement("H5");
    h5.appendChild(textNode);
    var linkNode = document.createElement("A");
    linkNode.href = "Notice.aspx?ID=" + ID + "&Type=" + type;
    linkNode.target = "_blank";
    linkNode.appendChild(textNode);
    var timeNode = document.createTextNode(time);
    var Span = document.createElement("SPAN");
    Span.appendChild(timeNode);
    var tdNode1 = document.createElement("TD");
    tdNode1.appendChild(linkNode);
    var Year = new String(new Date().getFullYear());
    var Day = new String(new Date().getDay());
    var Month = new String(new Date().getMonth() + 1);
    var Now = Year + "-" + Month + "-" + Day;
    if (time == Now) {
        tdNode1.appendChild(spanbadage);
    }
    var tdNode2 = document.createElement("TD");
    tdNode2.appendChild(timeNode);
    tdNode2.style.textAlign = "center";
    
    var tdNode3 = document.createElement("TD");
    var textNode0 = document.createTextNode(ReleaseUserName);
    tdNode3.appendChild(textNode0);
    tdNode3.style.textAlign = "center";

    var tdNode4 = document.createElement("TD");
    var inode0 = document.createElement("i");
    if (imp == "1") {
        inode0.className = "fa fa-hand-pointer-o";
    }
    tdNode4.appendChild(inode0);
    tdNode4.style.textAlign = "right";
    
    var trNode = document.createElement("TR");
    trNode.appendChild(tdNode4);
    trNode.appendChild(tdNode1);
    trNode.appendChild(tdNode3);
    trNode.appendChild(tdNode2);

    titleArea.appendChild(trNode);

}

function Refresh(evt) {
    evt.preventDefault();
    window.location = 'newsList.aspx';
}

function firstPageShow(evt) {
    removeUlAllChild();
    release();
    if (lastPageNumber == 1) {
        for (var i = 0; i < notice.length; i++) {
            createTable(notice[i]);
        }
        document.getElementById("nextPage").disabled = "true";
        document.getElementById("previousPage").disabled = "true";
    } else {
        for (var i = 0; i < 10; i++) {
            createTable(notice[i]);
        }
        document.getElementById("previousPage").disabled = "true";

    }
    document.getElementById("currentPage").value = 1;
}

function nextPageShow(evt) {
    removeUlAllChild();
    release();
    pageCurrent = parseInt(document.getElementById("currentPage").value) + 1;
    if (pageCurrent == lastPageNumber) {
        document.getElementById("nextPage").disabled = "true";
        for (var i = 10 * pageCurrent - 10; i < notice.length; i++) {
            createTable(notice[i]);
        }
    }
    else {
        for (var i = 10 * pageCurrent - 10; i < 10 * pageCurrent; i++) {
            createTable(notice[i]);
        }
    }
    document.getElementById("currentPage").value = pageCurrent;
}

function previousPageShow(evt) {
    removeUlAllChild();
    release();
    pageCurrent = document.getElementById("currentPage").value - 1;
    if (pageCurrent == 1) {
        if (lastPageNumber == 1) {
            document.getElementById("nextPage").disabled = "true";
            document.getElementById("previousPage").disabled = "true";
        } else {
            document.getElementById("previousPage").disabled = "true";
        }
    }
    for (var i = 10 * pageCurrent - 10; i < 10 * pageCurrent; i++) {
        createTable(notice[i]);
    }
    document.getElementById("currentPage").value = pageCurrent;
}

function lastPageShow(evt) {
    removeUlAllChild();
    release();
    pageCurrent = lastPageNumber;
    for (var i = 10 * lastPageNumber - 10; i < notice.length; i++) {
        createTable(notice[i]);
    }
    if (lastPageNumber == 1) {
        document.getElementById("nextPage").disabled = "true";
        document.getElementById("previousPage").disabled = "true";
    } else {
        document.getElementById("nextPage").disabled = "true";

    }
    document.getElementById("currentPage").value = pageCurrent;
}

function release() {
    document.getElementById("nextPage").removeAttribute("disabled");
    document.getElementById("previousPage").removeAttribute("disabled");
}

function getInformation() {
    var type = getType();
    var xmlHttp = new XMLHttpRequest();
    var url = "../Root/Notice.ashx?Type=" + type;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;
            //alert(getString);
            obj = eval("(" + getString + ")");
        }
    }
    xmlHttp.send();
}

function getType() {
    var type = document.getElementById("type").value;
    return type;
}

function removeUlAllChild() {
    while (titleArea.hasChildNodes()) {
        var child = titleArea.firstChild;
        while (child.hasChildNodes()) {
            child.removeChild(child.firstChild);
        }
        titleArea.removeChild(titleArea.firstChild);
    }
}
