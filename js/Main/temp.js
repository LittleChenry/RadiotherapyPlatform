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
function change() {
    var srcs = getObjectURL(this.files[0]);   //获取路径
    $(this).nextAll(".img").attr("src", srcs);    //this指的是input
    $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用*/
    var htmlImg = '<div class="boxes">' +
              '<div class="imgnum">' +
              '<input type="file" name="img' + Date.parse(new Date()) + '"  class="filepath" />' +
              '<i class="closecamera fa fa-times" style="font-size:35px;display:none;"></i>' +
              '<i class="camera fa fa-camera" style="font-size:110px;"></i>' +
              '<img src=" " class="img" />' +
              '</div>' +
              '</div>';


    $(this).parent().parent().before(htmlImg);
    $(this).parent().parent().find(".camera").hide();   //this指的是input
    $(this).parent().parent().find('.closecamera').show();
    $(this).parent().parent().prev().find('.filepath').on("change", change);
    $(".closecamera").on("click", function () {
        $(this).hide();     //this指的是span
        $(this).nextAll(".img").hide();
        $(this).nextAll(".camera").show();
        if ($('.boxes').length > 1) {
            $(this).parent().parent().remove();
        }

    });
};

$(function () {
    $(".filepath").on("change", function(){
        //alert($('.boxes').length);
        var srcs = getObjectURL(this.files[0]);   //获取路径
        //this指的是input
        $(this).nextAll(".img").attr("src",srcs);    //this指的是input
        $(this).nextAll(".img").show();  //fireBUg查看第二次换图片不起做用*/
        var htmlImg = '<div class="boxes">' +
                  '<div class="imgnum">' +
	              '<input type="file" name="img'+Date.parse(new Date())+'" class="filepath" />' +
	              '<i class="closecamera fa fa-times" style="font-size:35px;display:none;"></i>' +
	              '<i class="camera fa fa-camera" style="font-size:110px;"></i>' +
	              '<img src=" " class="img" />' +
                  '</div>' +
                  '</div>';
    

        $(this).parent().parent().before(htmlImg);
        $(this).parent().parent().find(".camera").hide();   //this指的是input
        $(this).parent().parent().find('.closecamera').show();
        $(this).parent().parent().prev().find('.filepath').on("change", change);
        $(".closecamera").on("click", function () {
            $(this).hide();     //this指的是span
            $(this).nextAll(".img").hide();
            $(this).nextAll(".camera").show();
            if ($('.boxes').length > 1) {
                $(this).parent().parent().remove();
            }

        })
    })
})
