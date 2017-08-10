$(function () {
    $("#userNumber").bind("change", function () {
        checkExist();
    });
});


//ajax异步检查用户名是否已存在
function checkExist() {
    document.getElementById("errors").innerHTML = "";
    var xmlHttp = new XMLHttpRequest();
    var userName = document.getElementById("userNumber").value;
    var url = "CHeckRegeditUserName.ashx?userName=" + userName;
    xmlHttp.open("GET", url, true);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            var checked = xmlHttp.responseText;
            var error = document.getElementById("errors");
            if (checked != "false") {
                document.getElementById("userNumber").className += " invalid";
                error.style.display = "block";
                error.innerHTML = "用户名不存在";
            } else {
                $("#userNumber").removeClass("invalid");
                error.display = "none";
            }
        }
    }
    xmlHttp.send();
}

$(function () {
    $("#sureChange").bind("click", function () {
        var number = $("#userNumber").val();
        var oldKey = $("#userKey").val();
        var newKey = $("#newKey").val();
        var reKery = $("#reKey").val();
        var $errors = $("#errors");

        $("#loginDiv input").removeClass("invalid");

        $errors.hide();

        if (number == "") {
            $errors.show();
            $errors.text("账号不能为空");
            $("#userNumber").addClass("invalid");
            return false;
        }
        if (oldKey == "") {
            $errors.show();
            $errors.text("旧密码不能为空");
            $("#userKey").addClass("invalid");
            return false;
        }
        if (newKey == "") {
            $errors.show();
            $errors.text("新密码不能为空");
            $("#newKey").addClass("invalid");
            return false;
        }

        if (!checkKey(newKey)) {
            $errors.show();
            $errors.text("请输入6-12位密码");
            $("#newKey").addClass("invalid");
            return false;
        }
        if (reKery != newKey) {
            $errors.show();
            $errors.text("两次密码不同");
            $("#reKey").addClass("invalid");
            return false;
        }

        $.ajax({
            type: "post",
            url: "changeKey.ashx",
            data: { "number": number, "oldKey": oldKey, "newKey": newKey },
            ansyc: false,
            success: function (data) {
                if (data == "true") {
                    alert("修改成功，即将跳转到登录界面");
                    window.location.replace("Login.aspx");
                } else {
                    $errors.show();
                    if (data == "number") {
                        $errors.text("账号不存在");
                        $("#userNumber").addClass("invalid");
                    }
                    if (data == "key") {
                        $errors.text("原密码不正确");
                        $("#userKey").addClass("invalid");
                    }
                }
            }
        });
    });
});

function checkKey(key) {
    var reg = /^\w{6,12}$/;
    return reg.test(key);
}