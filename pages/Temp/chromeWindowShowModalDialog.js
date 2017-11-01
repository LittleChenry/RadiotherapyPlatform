//var has_showModalDialog = !!window.showModalDialog;
if(window.showModalDialog == undefined){
    window.showModalDialog = function(url,mixedVar,features){
        if(window.hasOpenWindow){
            window.myNewWindow.focus();
            return;
        }
        window.hasOpenWindow = true;
        if(mixedVar) var mixedVar = mixedVar;
        //if(features) var features = features.replace(/(dialog)|(px)/ig,"").replace(/;/g,',').replace(/\:/g,"=");
        //var left = (window.screen.width - parseInt(features.match(/width[\s]*=[\s]*([\d]+)/i)[1]))/2;
        //var top = (window.screen.height - parseInt(features.match(/height[\s]*=[\s]*([\d]+)/i)[1]))/2;
        url = url + "?" + mixedVar.info;
        window.myNewWindow = window.open(url,"_blank");
    }
}
function _doChromeWindowShowModalDialog(obj){
    window.hasOpenWindow = false;
    try {
        doChromeWindowShowModalDialog(obj);
    }catch(e){
        
    }
}