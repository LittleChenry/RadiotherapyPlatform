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

        var $p = $("<span class='form-text col-xs-4'>" + content + "</span>");
        $($text[i]).replaceWith($p);
    }

    var $pagetitle = $(".paper-title");
    var hospital = '<div>江苏省人民医院</div>';
    $pagetitle.before(hospital);

    var $selects = $printArea.find("select");
    var $oldSelect = $("#needPrint").find("select");
    for (var i = 0; i < $selects.length; ++i) {
        var _this = $($selects[i]);
        var parent = _this.parent();
        var val = $($oldSelect[i]).find(":selected").text();
        _this.remove();
        var span = "<span class='form-text col-xs-4'>" + val + "</span>";
        parent.append(span);
    }
    $("#printArea :button").remove();
    var inputs = $printArea.find("input:not([type=hidden])").filter(":not([type=radio])");
    for (var i = 0; i < inputs.length; ++i) {
        var _thiss = $(inputs[i]);
        var vals = _thiss.val();
        var nextSpan = _thiss.next(".input-group-addon");
        var nexttext = "";
        if (nextSpan.length != 0) {
            nexttext = nextSpan.text();
            nextSpan.remove();
        }
        var span = "<span class=form-text style=position:absolute>" + vals + nexttext + "</span>";
        _thiss.parent().append(span);
        _thiss.remove();
    }

    var radios = $printArea.find("input[type=radio]");
    var currentName = "";
    var getit = false;
    for (var i = 0; i < radios.length; ++i) {
        if (radios[i].name == currentName && getit == true) {
            continue;
        } else if (radios[i].name != currentName) {
            currentName = radios[i].name;
            getit = false;
        }
        var thisRadio = $(radios[i]);
        var radiotext = "";
        if (thisRadio.attr("checked") == "checked") {
            radiotext = thisRadio.val();
            getit = true;
        }
        thisRadio.parent().empty().append((radiotext == "1" ? "<span class='form-text col-xs-4'>是</span>" : "<span class='form-text col-xs-4'>否</span>"));
    }

    $("#printArea .paper").css("border", "0px");
    $("#printArea .tab-row").css("display", "none");
    $("#printArea .img").removeClass("img").css("height","140px");
    $("#printArea .boxes").removeClass("boxes").css("margin", "0px 16px 16px 0px");
    $("#printArea .area-group").removeClass("area-group");
    //$("#printArea button").css("display", "none");
    
    $printArea.show();
    $printArea.printArea({"mode":"popup","popClose":true});
    $pagetitle.prev().remove();
    $printArea.hide();
}