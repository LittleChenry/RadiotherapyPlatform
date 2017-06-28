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
    <div style="min-height:556px;">
        <h1 class="page-header title">疗程诊断</h1>
          <div class="row">
             
                <div class="col-xs-12 "> 
                   
                    <div class="panel panel-default"> 
                         
                       
                             <div class="panel-body" id="panelbodytemp" style="height:500px;text-align:center">
                              
                                 <div class="row" >
                                     
                                      
                                     <div id="complete" style="position:relative;top:10px;text-align:center">
                                         
                                    
                                         <table class="table table-bordered table-striped tableWidth" style="border:solid thin;margin-left:33%;width:35%">
                                             <tbody>
                                               <tr>
                                                    <th style="height:35px"><label for="treatID" class="height">疗程号</label></th>
                                                   <td>
                                                       <input id="treatID" name="treatID" type="text" readonly="true" class="form-control controlHeight IsEmpty"  />
                                                    </td> 
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
                            <input type="text" id="diaguser" name="diaguser" readonly="true" class="form-control controlHeight" />
                              <input type="hidden" id="diaguserid" name="diaguserid" />
                          </td>
                             </tr>
                        <tr>
                             <th style="height:35px"><label for="time" class="height">诊断时间</label></th>
                        <td>
                           <input type="text" id="time" name="time" readonly="true" class="form-control controlHeight" />
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
