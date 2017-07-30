$(function () {
    $(".singlefilepath").on("change", function () {
        var srcs = getObjectURL(this.files[0]);   //获取路径
        $(this).hide();
        $(this).nextAll(".camera-picture").hide();   //this指的是input
        $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用
        $(this).nextAll('.closecamera').show();   //this指的是input
        $(this).nextAll(".img").attr("src", srcs);    //this指的是input
        $(".resetarra").on("click", function () {
            $(this).hide();     //this指的是span
            $(this).prevAll(".singlefilepath").show();
            $(this).prevAll(".singlefilepath").val("");
            $(this).nextAll(".img").hide();
            $(this).nextAll(".camera-picture").show();
            $(this).nextAll(".img").attr("src", srcs);
        });
    });
    $(".multifilepath").on("change", function () {
        $(this).hide();
        var srcs = getObjectURL(this.files[0]);   //获取路径
        $(this).nextAll(".img").attr("src", srcs);    //this指的是input
        $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用*/
        var htmlImg = "<div class='boxes'><div class='imgnum'>" +
        "<input type='file' accept='image/*' name='img" + Date.parse(new Date()) + "' class='multifilepath filepath'/>" +
        "<span class='closecamera closearea'><i class='fa fa-times'></i></span>" +
        "<img src='../../../img/camera.png' class='camera-picture'><img class='img'/></div></div>";
        $(this).parent().parent().before(htmlImg);
        $(this).parent().parent().find(".img").click(function () {
            $("#showPic").click();
            $("#pic").attr("src", this.src);
        })
        $(this).parent().parent().find(".camera-picture").hide();   //this指的是input
        $(this).parent().parent().find('.closecamera').show();
        $(this).parent().parent().prev().find('.multifilepath').on("change", change);
        $(".closearea").on("click", function () {
            $(this).parent().parent().remove();
        });
    });
    $(".multifilepath1").on("change", function () {
        $(this).hide();
        var srcs = getObjectURL(this.files[0]);   //获取路径
        $(this).nextAll(".img").attr("src", srcs);    //this指的是input
        $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用*/
        var htmlImg = "<div class='boxes'><div class='imgnum'>" +
        "<input type='file' accept='image/*' name='img" + Date.parse(new Date()) + "' class='multifilepath1 filepath'/>" +
        "<span class='closecamera closearea'><i class='fa fa-times'></i></span>" +
        "<img src='../../../img/camera.png' class='camera-picture'><img class='img'/></div></div>";
        $(this).parent().parent().before(htmlImg);
        $(this).parent().parent().find(".img").click(function () {
            $("#showPic").click();
            $("#pic").attr("src", this.src);
        })
        $(this).parent().parent().find(".camera-picture").hide();   //this指的是input
        $(this).parent().parent().find('.closecamera').show();
        $(this).parent().parent().prev().find('.multifilepath1').on("change", change);
        $(".closearea").on("click", function () {
            $(this).parent().parent().remove();
        });
    });
})

function change() {
    $(this).hide();
    var srcs = getObjectURL(this.files[0]);   //获取路径
    $(this).nextAll(".img").attr("src", srcs);    //this指的是input
    $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用*/
    var htmlImg = "<div class='boxes'><div class='imgnum'>" +
        "<input type='file' name='img" + Date.parse(new Date()) + "' class='multifilepath filepath'/>" +
        "<span class='closecamera closearea'><i class='fa fa-times'></i></span>" +
        "<img src='../../../img/camera.png' class='camera-picture'><img class='img'/></div></div>";
    $(this).parent().parent().before(htmlImg);
    $(this).parent().parent().find(".img").click(function () {
        $("#showPic").click();
        $("#pic").attr("src", this.src);
    })
    $(this).parent().parent().find(".camera-picture").hide();   //this指的是input
    $(this).parent().parent().find('.closecamera').show();
    $(this).parent().parent().prev().find('.multifilepath').on("change", change);
    $(".closearea").on("click", function () {
        $(this).parent().parent().remove();
    });
};

function getObjectURL(file) {
    var url = null;
    if (window.createObjectURL != undefined) {
        url = window.createObjectURL(file)
    } else if (window.URL != undefined) {
        url = window.URL.createObjectURL(file)
    } else if (window.webkitURL != undefined) {
        url = window.webkitURL.createObjectURL(file)
    }
    return url
};