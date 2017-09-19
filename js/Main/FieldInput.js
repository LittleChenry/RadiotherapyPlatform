$(".file").on("change","input[type='file']",function(){
    var filePath=$(this).val();
    var arr=filePath.split('\\');
    var fileName=arr[arr.length-1];
    $("#filename").val(fileName);
    //alert(fileName);
})