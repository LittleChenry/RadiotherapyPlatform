window.addEventListener("load", Init, false);

function Init() {
    document.getElementById('enableSee').addEventListener("click", showHide, false);
}

function showHide(evt) {
    var hidePart = document.getElementById("hidePart");
    //ie是element.currentStyle最终css,别的事wind.getComputedStyle(element,伪元素)获取最终css,element.style只能获取当前stlye值，第二个是只读的
    var style = (hidePart.currentStyle != undefined) ? hidePart.currentStyle.display : window.getComputedStyle(hidePart, null).display;
    if (style == "none") {
        hidePart.style.display = "list-item";
        document.getElementById('enableSeeSpan').className= "fa fa-angle-double-down";
    } else {
        hidePart.style.display = "none";
        document.getElementById('enableSeeSpan').className= "fa fa-angle-double-left";
    }
    evt.preventDefault();
}