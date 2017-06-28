<%@ Page Language="C#" AutoEventWireup="true" CodeFile="InspectionResult.aspx.cs" Inherits="roles_Root_InspectionResult" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8"/>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--Tell the brower to be responsive to screen width -->
    <meta content="Width=device-width, initial-scale=1, maxmum-scale=1, user-scalable=no" name="viewport" />
    <!--Boostrap -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css" />
    <!-- Theme style -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css" />
    <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css" />

    <!-- Main Css -->
    <link rel="stylesheet" href="../../css/Root/rootMain.css" />
    <title>设备检查结果</title>
    <!-- Main CSS -->
    <link href="../../css/Main/main.css" rel="stylesheet" />
    <link href="../../css/Root/Welcome.css" rel="stylesheet" type="text/css" />

   
</head>
<body>
    <div id="page-wrapper" style="border:0px;margin:0px; min-height: 923px;background:#f8f8f8;">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"></h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-md-12">
                <h3 id="loading" class="tohidden">加载中...</h3>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <span class="panel-title"></span>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <input type="hidden" id="sumPage" />
                            <input type="hidden" id="currentPage" value="1"/>
                            <div class="col-sm-12" id="tableArea">

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">&nbsp;</div>
                            <div class="col-sm-6">
                                <div id="pageButton" class="toright">
                                    <button type="button" id="firstPage" class="btn btn-primary btn-sm disabled">首页</button>
                                    <button type="button" id="prePage" class="btn btn-primary btn-sm disabled">上一页</button>
                                    <button type="button" id="nexrPage" class="btn btn-primary btn-sm">下一页</button>
                                    <button type="button" id="lastPage" class="btn btn-primary btn-sm">末页</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.row -->
    </div>
    <script type="text/javascript" src="../../plugin/AdminLTE/jquery.min.js"></script>
    <script type="text/javascript" src="../../js/Root/InspectionResultJS.js"></script>
</body>
</html>
