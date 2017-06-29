<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixedRecord.aspx.cs" Inherits="pages_Main_Records_FixedRecord" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>
    <title></title>
</head>
<body>
    <div id="page-wrapper" style="border:0px;margin:0px; min-height: 923px;background:#fff;">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header  title" id="itemName">体位固定记录</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default"> 
                   
                    <div class="panel-body" id="singlepatientpanelbody" style="text-align:center">
                        <form  runat="server"  id="saveFixRecord" name="saveFixRecord" method="post"   enctype="multipart/form-data">
                            <input type="hidden" name="ispostback" value="true" />
                           <input type="hidden"  id="hidetreatID" name="hidetreatID" />
                            <input type="hidden"  id="progress" name="progress" />
                            <input type="hidden"  id="userID" name="userID" />
                            <table class="table table-bordered table-hover" style="border:solid thin;width:80%;margin:auto;">
                                <tbody>
                                    <tr class="warning">
                                        <td colspan="6" style="border-bottom:#000 solid 1px;height:50px;font-weight:bolder;font-size:large;text-align:center">病人信息</td>
                                    </tr>
                                    <tr style="height:30px">
                                                    <td style="width:10%;">姓名:</td>
                                                    <td id="username" style="width:10%;"></td>
                                                    <td style="width:10%;">性别:</td>
                                                    <td id="sex" style="width:10%;"> </td>
                                                    <td style="width:15%;">身份证号:</td>
                                                    <td id="idnumber" style="width:20%;"> </td>
                                                 </tr>
                                                  <tr style="height:30px">
                                                    <td style="width:10%;">民族:</td>
                                                    <td id="nation" style="width:10%;"></td> 
                                                    <td style="width:15%;">年龄:</td>
                                                    <td id="age" style="width:20%;"> </td>
                                                    <td style="width:15%;">住址:</td>
                                                    <td id="address" style="width:20%;"> </td>
                                                 </tr>
                                                 <tr style="height:30px">
                                                    <td style="width:10%;">就诊单位:</td>
                                                    <td id="hospital" style="width:15%;"></td> 
                                                     <td style="width:15%;">联系方式1:</td>
                                                    <td id="contact" style="width:15%;"> </td>
                                                    <td style="width:15%;">联系方式2:</td>
                                                    <td id="contact2" style="width:25%;"> </td>
                                               </tr>
                                               <tr style="height:30px">
                                                    <td style="width:10%;">疗程号:</td>
                                                   <td id="treatID" style="width:15%;"></td> 
                                               </tr>
                                    <tr class="info">
                                        <td colspan="6" style="border-top:#000 solid 1px; border-bottom:#000 solid 1px;height:50px;font-weight:bolder;font-size:large;text-align:center">申请信息</td>
                                    </tr>
                                    <tr style="height:30px">
                                        <td>体位</td>
                                        <td id="body"></td>
                                        <td>固定模具</td>
                                        <td id="modelID"></td>
                                        <td>特殊要求</td>
                                        <td id="requireID"></td>
                                    </tr>
                                    <tr style="height:30px">
                                        <td>固定装置</td>
                                        <td id="fixedEquipment"></td>
                                        <td>申请医生</td>
                                        <td id="ApplicationUser"></td>
                                        <td>申请时间</td>
                                        <td id="ApplicationTime"></td>
                                    </tr>
                                    <tr class="success">
                                         <td colspan="6" style="border-top:#000 solid 1px; border-bottom:#000 solid 1px;height:50px;font-weight:bolder;font-size:large;text-align:center">体位固定记录</td>
                                    </tr>
                                    <tr>
                                        <td>体位详细描述</td>
                                        <td colspan="5">
                                            <textarea id="BodyPositionDetail" class="form-control" name="BodyPositionDetail" rows="3"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>附件描述</td>
                                        <td colspan="5">
                                            <textarea id="AnnexDescription" class="form-control" name="AnnexDescription" rows="3"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>备注</td>
                                        <td colspan="5">
                                            <textarea id="Remarks" name="Remarks" class="form-control" rows="2"></textarea>
                                        </td>
                                    </tr>
                                   
                                    <tr>
                                        <td>固定摄像图片(多图片)</td>
                                        <td colspan="5">
                                            <div id="imgbox">
                                                <div class="boxes">
			                                        <div class="imgnum">
				                                        <input type="file" name="f1" class="filepath" />
                                                        <i class="closecamera fa fa-times" style="font-size:35px;display:none;"></i>
                                                        <i class="camera fa fa-camera" style="font-size:110px;"></i>
				                                        <img src="" class="img" />
			                                        </div>
                                               
                                            </div>
                                                </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="row" style="margin-top:30px;margin-bottom:30px;">
                                <input id="cancel" class="btn btn-default" type="button" value="取消" style="margin-right:40px;" />
                                <input id="save" class="btn btn-success" type="submit" value="保存" />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="../../../js/Main/Fixed.js" type="text/javascript"></script>

    
  

  
</body>
</html>
