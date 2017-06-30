<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Diagnose.aspx.cs" Inherits="pages_Main_Records_Diagnose" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>

    <title></title>
    <!-- Bootstrap Core CSS -->   
    
 
</head>
<body>
    <input id="type" type="hidden" value="YS" />
    <div style="min-height:556px;background-color:#fff;">
        <h1 class="page-header title">疗程诊断</h1>
          <div class="row">
             
                <div class="col-xs-12 "> 
                   
                    <div class="panel panel-default"> 
                         
                       
                             <div class="panel-body" id="panelbodytemp" style="height:500px;text-align:center">
                              
                                 <div class="row" >
                                     
                                      
                                     <div id="complete" style="position:relative;top:10px;text-align:center">
                                         
                                     <input type="hidden" id="progress" name="progress" />
                                         
                                         <table class="table table-bordered table-striped tableWidth" style="border:solid thin;margin-left:10%;width:80%">
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
                                        <td colspan="6" style="border-top:#000 solid 1px; border-bottom:#000 solid 1px;height:50px;font-weight:bolder;font-size:large;text-align:center">病情诊断</td>
                                    </tr>           
                                  <tr>
                                  <th style="height:35px"><label for="part" class="height">部位</label></th>
                                  <td>
                                    <select id="part" name="part"  style="width:158px;" class="form-control">                
                                    </select>
                                 </td>
                                </tr>
                              <tr>
                                   <th style="height:35px"><label for="diagresult" class="height">诊断结果</label></th>
                              <td>
                                    <select id="diagresult" name="diagresult"  style="width:158px;" class="form-control">                
                                    </select>
                              </td>
                            </tr>
                             <tr>
                                  <th style="height:35px"><label for="diaguser" class="height">诊断人</label></th>
                             <td>
                            <input type="text" id="diaguser" name="diaguser" readonly="true" style="border:none;float:left;margin-top:10px" />
                              <input type="hidden" id="diaguserid" name="diaguserid" />
                          </td>
                             </tr>
                        <tr>
                             <th style="height:35px"><label for="time" class="height">诊断时间</label></th>
                        <td>
                           <input type="text" id="time" name="time" readonly="true" style="border:none;float:left;margin-top:10px" />
                        </td>
                       </tr>
                         <tr>
                             <th style="height:35px"><label for="remark" class="height">备注</label></th>
                        <td>
                           <input type="text" id="remark" name="remark"  value="" class="form-control controlHeight" placeholder="可不填"/>
                        </td>
                       </tr>
                        <tr style="text-align:center">
                         <td colspan="2">
                            <input type="button" id="postdiag" value="完成诊断" class="btn btn-primary btn-xs" />
                        </td>
                     
                     </tr>     
                   </tbody>
                      </table>
                      
                                     </div>
                                 </div>


                                 
                                 </div>
       
                           </div>
                            </div>
                   


                        </div>
                    </div>

 
    

</body>
      <script src="../../../js/Main/Diagnose.js" type="text/javascript"></script>
</html>
