<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ImportCT.aspx.cs" Inherits="pages_Main_Records_ImportCT" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <!-- css -->
    <link rel="stylesheet" href="../../../css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datepicker/datepicker3.css"/>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css"/>
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css"/>
    <!-- AdminLTE Skins. Choose a skin from the css/skins
    folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>
</head>
<body style="width:auto;min-width:900px;margin:auto;">
   <section class="content">
        <div class="paper">
             <input type="hidden" id="progress" />
            <div class="paper-title">
                     CT图像导入
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>基本信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">姓名：<span id="username" class="underline"></span></div>
                    <div class="item col-xs-4">性别：<span id="sex" class="underline"></span></div>
                    <div class="item col-xs-4">年龄：<span id="age" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">民族：<span id="nation" class="underline"></span></div>
                    <div class="item col-xs-4">身份证号：<span id="idnumber" class="underline"></span></div>
                    <div class="item col-xs-4">地址：<span id="address" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">联系方式1：<span id="contact" class="underline"></span></div>
                    <div class="item col-xs-4">联系方式2：<span id="contact2" class="underline"></span></div>
                    <div class="item col-xs-4">分中心医院：<span id="hospital" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>病案信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">疗程号：<span id="treatID" class="underline"></span></div>
                    <div class="item col-xs-4">患病部位：<span id="part" class="underline"></span></div>
                    <div class="item col-xs-4">所属医生：<span id="diaguser" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content"> 
                <form id="saveImportCT" method="post" runat="server">
                    <input type="hidden" name="ispostback" value="true" />
                    <input type="hidden"  id="treatmentID" name="treatmentID" />
                   <input type="hidden"  id="userID" name="userID" />
                <div class="content-title">
                    <span>CT图像信息填写：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-2">
                        CT-电子密度转换：
                     </div>
                     <div class="item col-xs-4">
                         <select id="DensityConversion" name="DensityConversion" class="form-item">                
                           </select>
                         </div>
                    <div class="item col-xs-2">
                        CT序列命名：        
                     </div>
                    <div class="item col-xs-4">
                         <input id="SequenceNaming" name="SequenceNaming" class="form-item"/>       
                        </div>
                 </div> 
                  <div class="single-row">
                     <div class="item col-xs-2">
                         层厚：
                     </div>
                       <div class="item col-xs-4">
                           <input id="Thickness" name="Thickness" type="number"  class="form-item"  />
                      </div>

                    <div class="item col-xs-2">
                        层数：
                     </div>
                      <div class="item col-xs-4"> 
                          <input id="Number" name="Number" type="number"  class="form-item"  />
                          </div>
                     
                  </div>
                  <div class="single-row">
                      <div class="item col-xs-2">
                          参考中心层面：
                     </div>
                      <div class="item col-xs-4"> 
                          <input id="ReferenceScale" class="form-item" type="number" name="ReferenceScale"/>
                       </div>
                      <div class="item col-xs-2">
                          多模态图像：
                      </div>
                      <div class="item col-xs-4">
                        <span>
                            <select id="MultimodalImage" name="MultimodalImage" class="form-item">
                                  <option value="allItem" >--选择多模态图像--</option>
                                   <option value="MRI">MRI</option>
                                 <option value="PET">PET</option>
                                <option value="Other">Other</option>
                            </select>
                        </span>
                 </div>
                 </div> 
                 <div class="single-row">
                    <div class="item area-group col-xs-12">
                        备注：
                        <textarea id="Remarks" class="form-area" style="height:50px"></textarea>
                    </div>
                </div>
                </form>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">日期：<span  id="time" class="underline"></span></div>
                </div>
            </div>
        </div>
         
    </section>
    <!-- jQuery 2.2.3 -->
    <script src="../../../plugin/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="../../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
    <!-- DataTables -->
    <script src="../../../plugin/AdminLTE/plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.min.js"></script>
    <!-- bootstrap datepicker -->
    <script src="../../../plugin/AdminLTE/plugins/datepicker/bootstrap-datepicker.js"></script>
    <!-- SlimScroll -->
    <script src="../../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
    <!-- FastClick -->
    <script src="../../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="../../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../plugin/AdminLTE/dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../../../plugin/AdminLTE/dist/js/demo.js"></script>
    <!-- javascript -->
     <script src="../../../js/Main/importCT.js" type="text/javascript"></script>
     <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>
