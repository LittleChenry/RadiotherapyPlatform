$(function() {
    $(".singlefilepath").on("change",function() {
        var srcs = getObjectURL(this.files[0]);   //获取路径
        $(this).hide();
        $(this).nextAll(".camera-picture").hide();   //this指的是input
        $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用
        $(this).nextAll('.closecamera').show();   //this指的是input
        $(this).nextAll(".img").attr("src",srcs);    //this指的是input
        $(".closecamera").on("click",function() {
            $(this).hide();     //this指的是span
            $(this).prevAll(".singlefilepath").show();
            $(this).prevAll(".singlefilepath").val("");
            $(this).nextAll(".img").hide();
            $(this).nextAll(".camera-picture").show();
            $(this).nextAll(".img").attr("src",srcs);
        });
    });
    $(".multifilepath").on("change",function() {
        var srcs = getObjectURL(this.files[0]);   //获取路径
        $(this).hide();
        $(this).nextAll(".camera-picture").hide();   //this指的是input
        $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用
        $(this).nextAll('.closecamera').show();   //this指的是input
        $(this).nextAll(".img").attr("src",srcs);    //this指的是input
        var nextbox = "<div class='boxes'><div class='imgnum'><input type='file' name='avatar' class='filepath'/>" +
        "<span class='closecamera'><i class='fa fa-times'></i></span>" +
        "<img src='../../../img/camera.png' class='camera-picture'><img src='"+ $(this).nextAll(".img")[0].src +"' class='img'/></div></div>";
        $(".multifile").append($(nextbox));
        $(this).nextAll(".img").attr("src","");
        //$(nextbox).find(".imgnum").find(".filepath").val($(this).val());
        //alert($(this).nextAll(".img")[0].src);
        //$(nextbox).find(".imgnum").find(".img").attr("src",$(this).nextAll(".img")[0].src);
        $(".closecamera").on("click",function() {
            $(this).hide();     //this指的是span
            $(this).prevAll(".multifilepath").show();
            $(this).prevAll(".multifilepath").val("");
            $(this).nextAll(".img").hide();
            $(this).nextAll(".camera-picture").show();
            $(this).nextAll(".img").attr("src",srcs);
        });
    });
})

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
