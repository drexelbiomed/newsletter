// Copyright 2005-2007 Adobe Systems Incorporated.  All rights reserved.
function ControlVersion(){var e,a;try{a=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7"),e=a.GetVariable("$version")}catch(s){}if(!e)try{a=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6"),e="WIN 6,0,21,0",a.AllowScriptAccess="always",e=a.GetVariable("$version")}catch(s){}if(!e)try{a=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3"),e=a.GetVariable("$version")}catch(s){}if(!e)try{a=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3"),e="WIN 3,0,18,0"}catch(s){}if(!e)try{a=new ActiveXObject("ShockwaveFlash.ShockwaveFlash"),e="WIN 2,0,0,11"}catch(s){e=-1}return e}function GetSwfVer(){var e=-1;if(null!=navigator.plugins&&navigator.plugins.length>0){if(navigator.plugins["Shockwave Flash 2.0"]||navigator.plugins["Shockwave Flash"]){var a=navigator.plugins["Shockwave Flash 2.0"]?" 2.0":"",s=navigator.plugins["Shockwave Flash"+a].description,r=s.split(" "),t=r[2].split("."),n=t[0],o=t[1],c=r[3];""==c&&(c=r[4]),"d"==c[0]?c=c.substring(1):"r"==c[0]&&(c=c.substring(1),c.indexOf("d")>0&&(c=c.substring(0,c.indexOf("d"))));var e=n+"."+o+"."+c}}else-1!=navigator.userAgent.toLowerCase().indexOf("webtv/2.6")?e=4:-1!=navigator.userAgent.toLowerCase().indexOf("webtv/2.5")?e=3:-1!=navigator.userAgent.toLowerCase().indexOf("webtv")?e=2:isIE&&isWin&&!isOpera&&(e=ControlVersion());return e}function DetectFlashVer(e,a,s){if(versionStr=GetSwfVer(),-1==versionStr)return!1;if(0!=versionStr){isIE&&isWin&&!isOpera?(tempArray=versionStr.split(" "),tempString=tempArray[1],versionArray=tempString.split(",")):versionArray=versionStr.split(".");var r=versionArray[0],t=versionArray[1],n=versionArray[2];if(r>parseFloat(e))return!0;if(r==parseFloat(e)){if(t>parseFloat(a))return!0;if(t==parseFloat(a)&&n>=parseFloat(s))return!0}return!1}}function AC_AddExtension(e,a){return-1!=e.indexOf("?")?e.replace(/\?/,a+"?"):e+a}function AC_Generateobj(e,a,s){var r="";if(isIE&&isWin&&!isOpera){r+="<object ";for(var t in e)r+=t+'="'+e[t]+'" ';r+=">";for(var t in a)r+='<param name="'+t+'" value="'+a[t]+'" /> ';r+="</object>"}else{r+="<embed ";for(var t in s)r+=t+'="'+s[t]+'" ';r+="> </embed>"}document.write(r)}function AC_FL_RunContent(){var e=AC_GetArgs(arguments,".swf","movie","clsid:d27cdb6e-ae6d-11cf-96b8-444553540000","application/x-shockwave-flash");AC_Generateobj(e.objAttrs,e.params,e.embedAttrs)}function AC_SW_RunContent(){var e=AC_GetArgs(arguments,".dcr","src","clsid:166B1BCA-3F9C-11CF-8075-444553540000",null);AC_Generateobj(e.objAttrs,e.params,e.embedAttrs)}function AC_GetArgs(e,a,s,r,t){var n=new Object;n.embedAttrs=new Object,n.params=new Object,n.objAttrs=new Object;for(var o=0;o<e.length;o+=2){var c=e[o].toLowerCase();switch(c){case"classid":break;case"pluginspage":n.embedAttrs[e[o]]=e[o+1];break;case"src":case"movie":e[o+1]=AC_AddExtension(e[o+1],a),n.embedAttrs.src=e[o+1],n.params[s]=e[o+1];break;case"onafterupdate":case"onbeforeupdate":case"onblur":case"oncellchange":case"onclick":case"ondblClick":case"ondrag":case"ondragend":case"ondragenter":case"ondragleave":case"ondragover":case"ondrop":case"onfinish":case"onfocus":case"onhelp":case"onmousedown":case"onmouseup":case"onmouseover":case"onmousemove":case"onmouseout":case"onkeypress":case"onkeydown":case"onkeyup":case"onload":case"onlosecapture":case"onpropertychange":case"onreadystatechange":case"onrowsdelete":case"onrowenter":case"onrowexit":case"onrowsinserted":case"onstart":case"onscroll":case"onbeforeeditfocus":case"onactivate":case"onbeforedeactivate":case"ondeactivate":case"type":case"codebase":case"id":n.objAttrs[e[o]]=e[o+1];break;case"width":case"height":case"align":case"vspace":case"hspace":case"class":case"title":case"accesskey":case"name":case"tabindex":n.embedAttrs[e[o]]=n.objAttrs[e[o]]=e[o+1];break;default:n.embedAttrs[e[o]]=n.params[e[o]]=e[o+1]}}return n.objAttrs.classid=r,t&&(n.embedAttrs.type=t),n}var isIE=-1!=navigator.appVersion.indexOf("MSIE")?!0:!1,isWin=-1!=navigator.appVersion.toLowerCase().indexOf("win")?!0:!1,isOpera=-1!=navigator.userAgent.indexOf("Opera")?!0:!1;