/**
 *
 */

function print() {
    var $printArea = $("#printArea");
    $printArea.empty();

    $printArea.append($("#needPrint").clone());

    var $text = $("#printArea textarea");
    for (var i = 0; i < $text.length; ++i) {
        var content = $text[i].value;
        var reg = new RegExp("\r\n", "g");
        var reg1 = new RegExp(" ", "g");
        var reg2 = new RegExp("\n", "g");
        var reg3 = new RegExp("\r", "g");

        content.replace(reg, "<br/>")
               .replace(reg1, "&nbsp;")
               .replace(reg2, "<br />")
               .replace(reg3, "<br />");

        var $p = $("<span>" + content + "</span>");
        $($text[i]).replaceWith($p);
    }

    $("#printArea .paper").css("border", "0px");
    $("#printArea .img").removeClass("img").css("height","140px");
    $("#printArea .boxes").removeClass("boxes").css("margin", "0px 16px 16px 0px");

    $printArea.show();
    $printArea.printArea({"mode":"popup"});
    $printArea.hide();
}