<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="pages_Root_test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <div class="single-row">
                    <div class="col-xs-6">
                        <div class="group-item" style="width:80%;">
                            <input type="text" id="filename" class="form-control" disabled="disabled" style="border-radius:4px 0px 0px 4px;"/>
                            <span class="input-group-btn">
                                <a href="javascript:;" class="btn btn-info file">选择文件<input type="file" id="file"/></a>
                            </span>
                        </div>
                    </div>
                    <div class="col-xs-6">
                        <button class="btn btn-success" id="sure" type="button"><i class="fa fa-fw fa-reply-all"></i>导入</button>
                    </div>
                </div>

    <script src="../../plugin/AdminLTE/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#sure").bind("click", function () {
                var formDate = new FormData();
                if ($("#file")[0].files[0] == null) {
                    formDate.append("exist", "false");
                } else {
                    formDate.append("file", $("#file")[0].files[0]);
                    formDate.append("exist", "true");
                }
                $.ajax({
                    type: "post",
                    url: "test.ashx",
                    data: formDate,
                    processData: false,
                    contentType: false,
                    success: function (data) {
                        alert(data);
                    }
                });
            });
            
        });
    </script>
</body>
</html>
