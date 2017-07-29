<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Notice.aspx.cs" Inherits="Main_Notice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>消息通知</title>
    <link href="../../css/Main/Notice.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div class="background-img-fixed" style="margin:auto;text-align:center;position:fixed;z-index:-15;">
        <img src="../../img/hospital.png" />
    </div>
    <div id="container_page">
        <div id="container_content">
            <div id="title">
                <h1>
                    <asp:Label ID="Label3" runat="server" Text=""></asp:Label>
                </h1>
            </div>
            <hr />
            <div class="panel panel-default">
                <div class="panel-body">
                    <div id="describe">
                        <span id="describe-content"><asp:Label ID="Label2" runat="server" Text=""></asp:Label></span>
                    </div> 
                    <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                </div>
            </div>
        </div>
    </div>
<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
<script>
    $("#container_page").css("minHeight", $(document).height());
</script>
</body>
</html>
