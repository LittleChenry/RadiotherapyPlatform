<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientRegister.aspx.cs" Inherits="pages_Main_Records_PatientRegister" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>

    <title></title>
 
 <style type="text/css">
        .auto-style1 {
            height: 45px;
        }
    </style>
</head>
<body>
    <div id="page-wrapper" style="border:0px;margin:0px; min-height: 923px;background:#f8f8f8;">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header  title" id="itemName">患者基本信息录入</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default"> 
                    <div class="panel-body" id="mainpanelbody">
                        <div class="row" style="height:1000px">
                            <form id="frmRegist" name="frmRegist" method="post" runat="server">
                                <input type="hidden" name="ispostback" value="true" />

                                <div class="container">
                                    <div class="row">
                                        <input id="patientID" type="hidden" name="patientID"    />
                                        <input id="treatID" type="hidden" name="treatID" />
                                           <table  class="table table-bordered table-hover" style="border:solid thin;width:80%;margin-top:100px;margin-left:10%">
                                           
                                               <tr class="warning" >
                                                   <td colspan="6" style="border:solid thin;height:45px;font-weight:bolder;font-size:large;text-align:center">注册新患者基本信息</td>
                                                 </tr>
                                               <tr>
                                                    <td style="width:15%;height:35px">姓名：</td>
                                                    <td style="width:20%;"> 
                                                    <input id="userName" type="text" size="28" name="userName" class="form-control isEmpty userName"  />
                                                    </td>
                                                    <td style="width:15%;">身份证号：</td>
                                                    <td style="width:20%;"> <input id="IDcardNumber" type="text" name="IDcardNumber" size="28" class="form-control isEmpty IDcardNumber"  />
                                                    </td>
                                                    </tr>
                                             <tr>
                                                    <td style="width:15%;height:35px">性别：</td>
                                                    <td > 
                                                        <input id="Gender" type="text" name="Gender"  class="form-control isEmpty Gender"   />
                                                   </td>
                                           
                                                   
                                                    <td >病案号：</td>
                                                      <td >
                                                     <input id="RecordNumber" type="text" name="RecordNumber" size="28" class="form-control isEmpty RecordNumber"  />
                                                    </td>
                                                 </tr>
                                            
                                             <tr>
                                                    <td style="width:15%;height:35px">民族：</td>
                                                    <td >  <input id="Nation" type="text" name="Nation" size="28"   class="form-control isEmpty Nation"  />
                                                     </td>

                                             
                                                   <td >出生日期：</td>
                                                     <td> 
                                                         <input id="Birthday" type="text" name="Birthday" size="28" onclick="laydate()"  class="form-control isEmpty Birthday"  />
                                                       </td>
                                                 </tr>
                                                <tr>
                                                    <td style="width:15%;height:35px">就诊医院：</td>
                                                    <td colspan="5"> 
                                                    <input id="Hospital" type="text" name="Hospital" size="80" class="form-control isEmpty Hospital"  />
                                                    </td>
                                                 </tr>
                                             <tr>
                                                   <td style="width:15%;height:35px">地址：</td>
                                                   <td colspan="5">
                                                        <input id="Address" type="text" name="Address" size="80"   class="form-control isEmpty Address"  />
                                                     </td>
                                                   
                                               </tr>
                                               <tr>
                                                   <td style="width:15%;height:35px">电话1：</td>
                                                    <td >
                                                         <input id="Number1" type="text" name="Number1" size="28"   class="form-control  Number1" />
                                                     </td>
                                                   <td >电话2：</td>
                                                   <td >
                                                        <input id="Number2" type="text" name="Number2" size="28"   class="form-control  Number2"  />
                                                   </td>
                                                    
                                               </tr>
                                               <tr>
                                                   <td style="width:15%;height:35px">身高：</td>
                                                    <td >
                                                         <input id="height" type="number" name="height" size="28"  class="form-control isEmpty height"  />
                                                     </td>
                                                   <td >体重：</td>
                                                   <td >
                                                        <input id="weight" type="number" name="weight"  size="28" class="form-control isEmpty weight"  />
                                                    </td>
                                                   </tr>
                                             <tr>
                                                   <td style="width:15%;height:35px">照片：</td>
                                                   <td >
                                                     <asp:FileUpload ID="FileUpload" runat="server" />
                                                   </td>
                                               </tr>
                                                <tr class="info" style="border:solid thin">
                                                   <td colspan="6" style="font-weight:bolder;font-size:large;text-align:center" class="auto-style1">注册新患者管理信息</td>
                                                 </tr>
                                               <tr>
                                              <td style="width:15%;height:35px">患病部位：</td>
                                                   <td >
                                                        <select id="SickPart" name="SickPart" style="width:200px;" class="form-control SickPart">                
                                                        </select>
                                                   </td>  
                                                   <td >选择医生：</td>
                                                   <td >
                                                        <select id="docter" name="docter" style="width:200px;" class="form-control docter">                
                                                        </select>
                                                   </td>
                                               </tr>
                                             <tr>
                                                   <td style="width:15%;height:35px">选择分中心负责人：</td>
                                                     <td >
                                                        <select id="Sub" name="Sub" style="width:200px;" class="form-control Sub">                
                                                        </select>
                                                     </td>
                                                    <td >登记时间：</td>
                                                      <td >
                                                     <input id="date" type="text" name="date" size="28" class="form-control isEmpty RecordNumber"  />
                                                    </td>
                                                 </tr>

                                               <tr>
                                                  <td colspan="6" style="text-align:center">
                                                     <input type="submit" value="确定" class="regedit-button btn btn-success btn-lg" />
                                                     <input type="reset" value="重置" class="regedit-button  btn btn-success btn-lg" />
                                                    </td>
                                               </tr>
                                                 
                                           </table>
                                            <label id="error" style="margin-left:54px;"></label>
                                        </div>
                                    </div>
                                  </form>
                                </div>
                           
                        </div>
                    </div>
                </div>
            </div>
        </div>
       
</body>
    <script src="../../../js/Main/PatientRegister.js" ></script>
</html>
