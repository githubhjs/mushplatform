function Ob(o){
 return document.getElementById(o)?document.getElementById(o):o;
}

function Hd(o){
 o.style.display="none";
}
function Sw(o){
 o.style.display="block";
}
function Sw2(o){
 o.style.display="";
}

function RevHdSw(o){
 Ob(o).style.display= Ob(o).style.display=="none"?"":"none";
}

function ChgBg0(o){
 Ob(o).className="tr0";
 //o.style.backgoundColor="#f00";
}

function ChgBg1(o){
 Ob(o).className="tr1";
}

function GetCookie(Name) {
 var search = Name + "=";
 var returnvalue = "";
 if (document.cookie.length > 0) {
  offset = document.cookie.indexOf(search);
  if (offset != -1) {      
   offset += search.length;
   end = document.cookie.indexOf(";", offset);                        
   if (end == -1)
   end = document.cookie.length;
   returnvalue=unescape(document.cookie.substring(offset,end));
  }
 }
 return returnvalue;
}

function RevKeyBox(o){
 var o=o.parentNode.parentNode.parentNode;
 o.className=o.className=="KeyBox"?"KeyBox2":"KeyBox";
}

function ChgSkin(s){
 document.getElementById("ActCSS").href="css/skin"+s+".css";
 var expdate=new Date();
 expdate.setTime(expdate.getTime()+(24*60*60*1000*30));
 SetCookie("SkinCCMWorld",s,expdate,"/",null,false);
}

function GetSkin(){
 if (GetCookie("SkinCCMWorld")) {
  try {
   document.getElementById("ActCSS").href="css/skin"+GetCookie("SkinCCMWorld")+".css";
  }
  catch (e) {;}
 }
}

function popupWin(){
  var o=top.document.getElementById("SmlWin");
  o.style.display="block";
  var theHandle = document.getElementById("OpHand");
  var theRoot = document.getElementById("SmlWin");
  Drag.init(theHandle, theRoot);
}
function OpenWin(s){
top.document.getElementById("SmlFrm").src=s;
var o=top.document.getElementById("SmlWin");
o.style.display="block";
//top.document.body.className="Msg";
 var theHandle = document.getElementById("OpHand");
 var theRoot = document.getElementById("SmlWin");
 Drag.init(theHandle, theRoot);
}
function CloseWin(){
var o=document.getElementById("SmlWin");
o.style.display="none";
Drag.end;
}

function HidWin(){
top.CloseWin();
}

function ShowWin(s){
top.OpenWin(s);
}
//Check
function Ck(o,w){
  if (o.checked==false) { 
	document.getElementById("BtnChkAll").checked=false;
  } else {
  Ac(w);
  }
}

function Ac(w){
 var ChkNums=0;
 var arrObj=document.getElementById(w).getElementsByTagName("input");
 for (i=0;i<arrObj.length;i++ ) {
  ChkNums+=arrObj[i].checked?1:0;
 }
   document.getElementById("BtnChkAll").checked=ChkNums==arrObj.length;
}

function Ca(o,w){
 var arrObj=document.getElementById(w).getElementsByTagName("input");
 //alert('aa');
 for (i=0;i<arrObj.length;i++ ) {
  arrObj[i].checked=o.checked;
 }
}


function handle_all_submit( form, action, action_desc ) {
  if( confirm('确认要'+ action_desc +'所有选中的？') ){
    form.action = action;
    form.submit();
  }
}

function add_categories() {
  var categories = document.getElementById('ListCate').getElementsByTagName("input");
  var category_names = '';
  var category_ids = '';
  for (i=0;i<categories.length;i++ ) {
    if ( categories[i].name == 'id[]' && categories[i].checked ){
      var arr_value = categories[i].value.split(',');
      category_ids = category_ids + ',' + arr_value[0];
      category_names = category_names + ' ' + arr_value[1];
    }
  } 
  category_ids = category_ids.substring(1);
  category_names = category_names.substring(1);
  window.parent.document.getElementById('category_names').value = category_names;
  window.parent.document.getElementById('category_ids').value = category_ids;
  HidWin();
}

function add_tags(spliter) {
  var tags = document.getElementById('ListCate').getElementsByTagName("input");
  var tag_names = '';
  for (i=0;i<tags.length;i++ ) {
    if ( tags[i].name == 'id[]' && tags[i].checked ){
      var arr_value = tags[i].value.split(',');
      tag_names = tag_names + spliter + arr_value[1];
    }
  } 
  tag_names = tag_names.substring(1);
  window.parent.document.getElementById('article_tag_list').value = tag_names;
  HidWin();
}

function add_linkwords() {
  var linkwords = document.getElementById('ListArtKey').getElementsByTagName("input");
  var linkword_names = '';
  var linkword_ids = '';
  for (i=0;i<linkwords.length;i++ ) {
    if ( linkwords[i].name == 'id[]' && linkwords[i].checked ){
      var arr_value = linkwords[i].value.split(',');
      linkword_ids = linkword_ids + ',' + arr_value[0];
      linkword_names = linkword_names + ' ' + arr_value[1];
    }
  } 
  linkword_ids = linkword_ids.substring(1);
  linkword_names = linkword_names.substring(1);
  window.parent.document.getElementById('linkword_names').value = linkword_names;
  window.parent.document.getElementById('linkword_ids').value = linkword_ids;
  HidWin();
}


function getPartial(input_id){
  var isFF = false;
  if(navigator.userAgent.toLowerCase().indexOf("firefox") > 0){
    isFF = true;
  }
  var myArea = document.getElementById(input_id);
  var selection;
  if (isFF == true){
    if (myArea.selectionStart!= undefined) {
      selection = myArea.value.substr(myArea.selectionStart, myArea.selectionEnd - myArea.selectionStart);
    }
  }else{
    if (window.getSelection){
      selection = window.getSelection();
    }else if (document.getSelection){
      selection = document.getSelection();
    }else if (document.selection){
      selection = document.selection.createRange().text;
    }
  }
  //alert(selection)
  return selection;
}

// ===================================================================
// Author: Matt Kruse <matt@mattkruse.com>
// WWW: http://www.mattkruse.com/
//
// NOTICE: You may use this code for any purpose, commercial or
// private, without any further permission from the author. You may
// remove this notice from your final code if you wish, however it is
// appreciated by the author if at least my web site address is kept.
//
// You may *NOT* re-distribute this code in any way except through its
// use. That means, you can include it in your product, or your web
// site, or any other form where the code is actually being used. You
// may not put the plain javascript up on your site for download or
// include it in your javascript libraries for download. 
// If you wish to share this code with others, please just point them
// to the URL instead.
// Please DO NOT link directly to my .js files from your site. Copy
// the files to your server and use them there. Thank you.
// ===================================================================

/* SOURCE FILE: AnchorPosition.js */
function getAnchorPosition(anchorname){var useWindow=false;var coordinates=new Object();var x=0,y=0;var use_gebi=false, use_css=false, use_layers=false;if(document.getElementById){use_gebi=true;}else if(document.all){use_css=true;}else if(document.layers){use_layers=true;}if(use_gebi && document.all){x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);}else if(use_gebi){var o=document.getElementById(anchorname);x=AnchorPosition_getPageOffsetLeft(o);y=AnchorPosition_getPageOffsetTop(o);}else if(use_css){x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);}else if(use_layers){var found=0;for(var i=0;i<document.anchors.length;i++){if(document.anchors[i].name==anchorname){found=1;break;}}if(found==0){coordinates.x=0;coordinates.y=0;return coordinates;}x=document.anchors[i].x;y=document.anchors[i].y;}else{coordinates.x=0;coordinates.y=0;return coordinates;}coordinates.x=x;coordinates.y=y;return coordinates;}
function getAnchorWindowPosition(anchorname){var coordinates=getAnchorPosition(anchorname);var x=0;var y=0;if(document.getElementById){if(isNaN(window.screenX)){x=coordinates.x-document.body.scrollLeft+window.screenLeft;y=coordinates.y-document.body.scrollTop+window.screenTop;}else{x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;}}else if(document.all){x=coordinates.x-document.body.scrollLeft+window.screenLeft;y=coordinates.y-document.body.scrollTop+window.screenTop;}else if(document.layers){x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;}coordinates.x=x;coordinates.y=y;return coordinates;}
function AnchorPosition_getPageOffsetLeft(el){var ol=el.offsetLeft;while((el=el.offsetParent) != null){ol += el.offsetLeft;}return ol;}
function AnchorPosition_getWindowOffsetLeft(el){return AnchorPosition_getPageOffsetLeft(el)-document.body.scrollLeft;}
function AnchorPosition_getPageOffsetTop(el){var ot=el.offsetTop;while((el=el.offsetParent) != null){ot += el.offsetTop;}return ot;}
function AnchorPosition_getWindowOffsetTop(el){return AnchorPosition_getPageOffsetTop(el)-document.body.scrollTop;}

/* SOURCE FILE: PopupWindow.js */
function PopupWindow_getXYPosition(anchorname){var coordinates;if(this.type == "WINDOW"){coordinates = getAnchorWindowPosition(anchorname);}else{coordinates = getAnchorPosition(anchorname);}this.x = coordinates.x;this.y = coordinates.y;}
function PopupWindow_setSize(width,height){this.width = width;this.height = height;}
function PopupWindow_populate(contents){this.contents = contents;this.populated = false;}
function PopupWindow_setUrl(url){this.url = url;}
function PopupWindow_setWindowProperties(props){this.windowProperties = props;}
function PopupWindow_refresh(){if(this.divName != null){if(this.use_gebi){document.getElementById(this.divName).innerHTML = this.contents;}else if(this.use_css){document.all[this.divName].innerHTML = this.contents;}else if(this.use_layers){var d = document.layers[this.divName];d.document.open();d.document.writeln(this.contents);d.document.close();}}else{if(this.popupWindow != null && !this.popupWindow.closed){if(this.url!=""){this.popupWindow.location.href=this.url;}else{this.popupWindow.document.open();this.popupWindow.document.writeln(this.contents);this.popupWindow.document.close();}this.popupWindow.focus();}}}
function PopupWindow_showPopup(anchorname){this.getXYPosition(anchorname);this.x += this.offsetX;this.y += this.offsetY;if(!this.populated &&(this.contents != "")){this.populated = true;this.refresh();}if(this.divName != null){if(this.use_gebi){document.getElementById(this.divName).style.left = this.x + "px";document.getElementById(this.divName).style.top = this.y;document.getElementById(this.divName).style.visibility = "visible";}else if(this.use_css){document.all[this.divName].style.left = this.x;document.all[this.divName].style.top = this.y;document.all[this.divName].style.visibility = "visible";}else if(this.use_layers){document.layers[this.divName].left = this.x;document.layers[this.divName].top = this.y;document.layers[this.divName].visibility = "visible";}}else{if(this.popupWindow == null || this.popupWindow.closed){if(this.x<0){this.x=0;}if(this.y<0){this.y=0;}if(screen && screen.availHeight){if((this.y + this.height) > screen.availHeight){this.y = screen.availHeight - this.height;}}if(screen && screen.availWidth){if((this.x + this.width) > screen.availWidth){this.x = screen.availWidth - this.width;}}var avoidAboutBlank = window.opera ||( document.layers && !navigator.mimeTypes['*']) || navigator.vendor == 'KDE' ||( document.childNodes && !document.all && !navigator.taintEnabled);this.popupWindow = window.open(avoidAboutBlank?"":"about:blank","window_"+anchorname,this.windowProperties+",width="+this.width+",height="+this.height+",screenX="+this.x+",left="+this.x+",screenY="+this.y+",top="+this.y+"");}this.refresh();}}
function PopupWindow_hidePopup(){if(this.divName != null){if(this.use_gebi){document.getElementById(this.divName).style.visibility = "hidden";}else if(this.use_css){document.all[this.divName].style.visibility = "hidden";}else if(this.use_layers){document.layers[this.divName].visibility = "hidden";}}else{if(this.popupWindow && !this.popupWindow.closed){this.popupWindow.close();this.popupWindow = null;}}}
function PopupWindow_isClicked(e){if(this.divName != null){if(this.use_layers){var clickX = e.pageX;var clickY = e.pageY;var t = document.layers[this.divName];if((clickX > t.left) &&(clickX < t.left+t.clip.width) &&(clickY > t.top) &&(clickY < t.top+t.clip.height)){return true;}else{return false;}}else if(document.all){var t = window.event.srcElement;while(t.parentElement != null){if(t.id==this.divName){return true;}t = t.parentElement;}return false;}else if(this.use_gebi && e){var t = e.originalTarget;while(t.parentNode != null){if(t.id==this.divName){return true;}t = t.parentNode;}return false;}return false;}return false;}
function PopupWindow_hideIfNotClicked(e){if(this.autoHideEnabled && !this.isClicked(e)){this.hidePopup();}}
function PopupWindow_autoHide(){this.autoHideEnabled = true;}
function PopupWindow_hidePopupWindows(e){for(var i=0;i<popupWindowObjects.length;i++){if(popupWindowObjects[i] != null){var p = popupWindowObjects[i];p.hideIfNotClicked(e);}}}
function PopupWindow_attachListener(){if(document.layers){document.captureEvents(Event.MOUSEUP);}window.popupWindowOldEventListener = document.onmouseup;if(window.popupWindowOldEventListener != null){document.onmouseup = new Function("window.popupWindowOldEventListener();PopupWindow_hidePopupWindows();");}else{document.onmouseup = PopupWindow_hidePopupWindows;}}
function PopupWindow(){if(!window.popupWindowIndex){window.popupWindowIndex = 0;}if(!window.popupWindowObjects){window.popupWindowObjects = new Array();}if(!window.listenerAttached){window.listenerAttached = true;PopupWindow_attachListener();}this.index = popupWindowIndex++;popupWindowObjects[this.index] = this;this.divName = null;this.popupWindow = null;this.width=0;this.height=0;this.populated = false;this.visible = false;this.autoHideEnabled = false;this.contents = "";this.url="";this.windowProperties="toolbar=no,location=no,status=no,menubar=no,scrollbars=auto,resizable,alwaysRaised,dependent,titlebar=no";if(arguments.length>0){this.type="DIV";this.divName = arguments[0];}else{this.type="WINDOW";}this.use_gebi = false;this.use_css = false;this.use_layers = false;if(document.getElementById){this.use_gebi = true;}else if(document.all){this.use_css = true;}else if(document.layers){this.use_layers = true;}else{this.type = "WINDOW";}this.offsetX = 0;this.offsetY = 0;this.getXYPosition = PopupWindow_getXYPosition;this.populate = PopupWindow_populate;this.setUrl = PopupWindow_setUrl;this.setWindowProperties = PopupWindow_setWindowProperties;this.refresh = PopupWindow_refresh;this.showPopup = PopupWindow_showPopup;this.hidePopup = PopupWindow_hidePopup;this.setSize = PopupWindow_setSize;this.isClicked = PopupWindow_isClicked;this.autoHide = PopupWindow_autoHide;this.hideIfNotClicked = PopupWindow_hideIfNotClicked;}


/* SOURCE FILE: ColorPicker2.js */

ColorPicker_targetInput = null;
ColorPicker_targetInputElem = null;
ColorPicker_targetSelectedInputElem = null;

function ColorPicker_writeDiv(){document.writeln("<DIV ID=\"colorPickerDiv\" STYLE=\"position:absolute;visibility:hidden;\"> </DIV>");}

function ColorPicker_show(anchorname){this.showPopup(anchorname);}

function ColorPicker_pickColor(color,obj,selected){obj.hidePopup();pickColor(color,selected);}

function pickColor(color,selected){
  if(ColorPicker_targetInput==null){
    alert("Target Input is null, which means you either didn't use the 'select' function or you have no defined your own 'pickColor' function to handle the picked color!");
    return;
  }
  //var selected = getPartial(ColorPicker_targetInputElem);
  //var selected = ColorPicker_targetSelectedInputElem;
  if( selected != ''){
    var f_value = ColorPicker_targetInput.value.split(selected);
    ColorPicker_targetInput.value = f_value[0] + '<span style="color:'+color+'">'+ selected +'</span>' + f_value[1];
  } else{
    ColorPicker_targetInput.value = '<span style="color:'+color+'">'+ColorPicker_targetInput.value+'</span>';
  }
}

function ColorPicker_select(inputelem,linkname){
  window.ColorPicker_targetSelectedInputElem = getPartial(inputelem);
  ColorPicker_targetInputElem = inputelem;
  var inputobj = document.getElementById(inputelem);
  if(inputobj.type!="text" && inputobj.type!="hidden" && inputobj.type!="textarea"){
    alert("colorpicker.select: Input object passed is not a valid form input object");
    window.ColorPicker_targetInput=null;
    return;
  }
  window.ColorPicker_targetInput = inputobj;
  this.show(linkname);
}

function ColorPicker_highlightColor(c){var thedoc =(arguments.length>1)?arguments[1]:window.document;var d = thedoc.getElementById("colorPickerSelectedColor");d.style.backgroundColor = c;d = thedoc.getElementById("colorPickerSelectedColorValue");d.innerHTML = c;}

function ColorPicker(){
  window.ColorPicker_targetSelectedInputElem = getPartial(arguments[1]);
  var windowMode = false;
  if(arguments.length==0){
    var divname = "colorPickerDiv";
  }else if(arguments[0] == "window"){
    var divname = '';
    windowMode = true;}
  else{
    var divname = arguments[0];
  }
  if(divname != ""){
    var cp = new PopupWindow(divname);
  }else{
    var cp = new PopupWindow();
    cp.setSize(225,250);
  }
  cp.currentValue = "#FFFFFF";
  cp.writeDiv = ColorPicker_writeDiv;
  cp.highlightColor = ColorPicker_highlightColor;
  cp.show = ColorPicker_show;
  cp.select = ColorPicker_select;
  var colors = new Array("#000000","#000033","#000066","#000099","#0000CC","#0000FF","#330000","#330033","#330066","#330099","#3300CC",
                         "#3300FF","#660000","#660033","#660066","#660099","#6600CC","#6600FF","#990000","#990033","#990066","#990099",
                         "#9900CC","#9900FF","#CC0000","#CC0033","#CC0066","#CC0099","#CC00CC","#CC00FF","#FF0000","#FF0033","#FF0066",
                         "#FF0099","#FF00CC","#FF00FF","#003300","#003333","#003366","#003399","#0033CC","#0033FF","#333300","#333333",
                         "#333366","#333399","#3333CC","#3333FF","#663300","#663333","#663366","#663399","#6633CC","#6633FF","#993300",
                         "#993333","#993366","#993399","#9933CC","#9933FF","#CC3300","#CC3333","#CC3366","#CC3399","#CC33CC","#CC33FF",
                         "#FF3300","#FF3333","#FF3366","#FF3399","#FF33CC","#FF33FF","#006600","#006633","#006666","#006699","#0066CC",
                         "#0066FF","#336600","#336633","#336666","#336699","#3366CC","#3366FF","#666600","#666633","#666666","#666699",
                         "#6666CC","#6666FF","#996600","#996633","#996666","#996699","#9966CC","#9966FF","#CC6600","#CC6633","#CC6666",
                         "#CC6699","#CC66CC","#CC66FF","#FF6600","#FF6633","#FF6666","#FF6699","#FF66CC","#FF66FF","#009900","#009933",
                         "#009966","#009999","#0099CC","#0099FF","#339900","#339933","#339966","#339999","#3399CC","#3399FF","#669900",
                         "#669933","#669966","#669999","#6699CC","#6699FF","#999900","#999933","#999966","#999999","#9999CC","#9999FF",
                         "#CC9900","#CC9933","#CC9966","#CC9999","#CC99CC","#CC99FF","#FF9900","#FF9933","#FF9966","#FF9999","#FF99CC",
                         "#FF99FF","#00CC00","#00CC33","#00CC66","#00CC99","#00CCCC","#00CCFF","#33CC00","#33CC33","#33CC66","#33CC99",
                         "#33CCCC","#33CCFF","#66CC00","#66CC33","#66CC66","#66CC99","#66CCCC","#66CCFF","#99CC00","#99CC33","#99CC66",
                         "#99CC99","#99CCCC","#99CCFF","#CCCC00","#CCCC33","#CCCC66","#CCCC99","#CCCCCC","#CCCCFF","#FFCC00","#FFCC33",
                         "#FFCC66","#FFCC99","#FFCCCC","#FFCCFF","#00FF00","#00FF33","#00FF66","#00FF99","#00FFCC","#00FFFF","#33FF00",
                         "#33FF33","#33FF66","#33FF99","#33FFCC","#33FFFF","#66FF00","#66FF33","#66FF66","#66FF99","#66FFCC","#66FFFF",
                         "#99FF00","#99FF33","#99FF66","#99FF99","#99FFCC","#99FFFF","#CCFF00","#CCFF33","#CCFF66","#CCFF99","#CCFFCC",
                         "#CCFFFF","#FFFF00","#FFFF33","#FFFF66","#FFFF99","#FFFFCC","#FFFFFF");
  var total = colors.length;
  var width = 18;
  var cp_contents = "";
  var windowRef =(windowMode)?"window.opener.":"";
  if(windowMode){cp_contents += "<HTML><HEAD><TITLE>Select Color</TITLE></HEAD>";
  cp_contents += "<BODY MARGINWIDTH=0 MARGINHEIGHT=0 LEFTMARGIN=0 TOPMARGIN=0><CENTER>";}cp_contents += "<TABLE BORDER=1 CELLSPACING=1 CELLPADDING=0>";var use_highlight =(document.getElementById || document.all)?true:false;for(var i=0;i<total;i++){if((i % width) == 0){cp_contents += "<TR>";}if(use_highlight){var mo = 'onMouseOver="'+windowRef+'ColorPicker_highlightColor(\''+colors[i]+'\',window.document)"';}else{mo = "";}cp_contents += '<TD BGCOLOR="'+colors[i]+'"><FONT SIZE="-3"><A HREF="#" onClick="'+windowRef+'ColorPicker_pickColor(\''+colors[i]+'\','+windowRef+'window.popupWindowObjects['+cp.index+'],\''+ColorPicker_targetSelectedInputElem+'\');return false;" '+mo+' STYLE="text-decoration:none;">&nbsp;&nbsp;&nbsp;</A></FONT></TD>';if( ((i+1)>=total) ||(((i+1) % width) == 0)){cp_contents += "</TR>";}}if(document.getElementById){var width1 = Math.floor(width/2);var width2 = width = width1;cp_contents += "<TR><TD COLSPAN='"+width1+"' BGCOLOR='#ffffff' ID='colorPickerSelectedColor'>&nbsp;</TD><TD COLSPAN='"+width2+"' ALIGN='CENTER' ID='colorPickerSelectedColorValue'>#FFFFFF</TD></TR>";}cp_contents += "</TABLE>";if(windowMode){cp_contents += "</CENTER></BODY></HTML>";}cp.populate(cp_contents+"\n");cp.offsetY = 25;cp.autoHide();return cp;}















function article_toggle(){
  Element.toggle('article_url', 'article_common');
  Element.toggle('url', 'body');
  Element.toggle('url', 'excerpt');
  Element.toggle('url', 'file');
  Element.toggle('url', 'image');
  var article_type = Ob('article_article_type');
  if ( article_type.value == 1 ){
    article_type.value = 2;
  } else if ( article_type.value == 2 ){
    article_type.value = 1;
  }
}
function add_prefix(f, prefix){
  var f_obj = document.getElementById(f);
  f_obj.value = prefix + f_obj.value;
  f_obj.focus();
}
function add_link(f, tag){
  var link = prompt("请输入要加入的连接，例如：http://www.ccmw.net");
  var f_obj = document.getElementById(f);
  var f_value = f_obj.value.split('：');
  if(f_value.length == 1){
    f_obj.value = '<a href="'+ link +'">' + f_value + '</a>';
  } else {
    f_obj.value = f_value[0] + '：' + '<a href="'+ link +'">' + f_value[1] + '</a>';
  }
  f_obj.focus();
}
function add_selected_link(f,tag){
  var selected = getPartial(f);
  if (selected == '') {
    alert("没有选择要增加连接的文字！");
    return;
  }
  var link = prompt("请输入要加入的连接，例如：http://www.ccmw.net");
  var f_obj = document.getElementById(f);
  var f_value = f_obj.value.split(selected);
  if(f_value.length == 1){
    f_obj.value = '<a href="'+ link +'" target="_blank">' + selected + '</a>';
  } else {
    f_obj.value = f_value[0] + '<a href="'+ link +'" target="_blank">' + selected + '</a>' + f_value[1];
  }
  f_obj.focus();
}

function getPartial(input_id){
  var isFF = false;
  if(navigator.userAgent.toLowerCase().indexOf("firefox") > 0){
    isFF = true;
  }
  var myArea = document.getElementById(input_id);
  var selection;
  if (isFF == true){
    if (myArea.selectionStart!= undefined) {
      selection = myArea.value.substr(myArea.selectionStart, myArea.selectionEnd - myArea.selectionStart);
    }
  }else{
    if (window.getSelection){
      selection = window.getSelection();
    }else if (document.getSelection){
      selection = document.getSelection();
    }else if (document.selection){
      selection = document.selection.createRange().text;
    }
  }
  //alert(selection)
  return selection;
}