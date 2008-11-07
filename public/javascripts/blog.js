function submit_comment(){
    form = $('comment_form');
    if(form['comment[body]'].value != '' && form['comment[body]'].value.length >= 5 ) //&& form['comment[title]'].value != '' && form['comment[title]'].value.length  >= 1 )
    {
        ajax_submit(form)
        this.disabled=true;
    }else{
        alert("内容字数不够!");
    }
    return false;
}
function ajax_submit(_from){
    new Ajax.Request(_from.action,
    {
        method:'post',
        asynchronous:true,
        evalScripts:true,
        onComplete:function(request){
            Element.hide('comment_loading');
            _from['comment[body]'].value='';
            _from['comment[title]'].value='';
        },
        onLoading:function(request){
            Element.show('comment_loading');
        },
        parameters:Form.serialize(_from)
    });
}
multiple_upload_picture_counter = 0
function addPictureDiv(ele,max_size,tags){
    if(!$A(['jpg','bmp','png','gif']).any(function(extName){return new RegExp('\\.'+extName+'$','i').test(ele.value);})){
        alert("æ‚¨ä¸Šä¼ çš„å›¾ç‰‡æ ¼å¼ä¸æ”¯æŒï¼Œè¯·æ‚¨ä¸Šä¼ JPGã€BMPã€PNGæˆ–è€…GIFæ ¼å¼çš„å›¾ç‰‡");
        return false;
    }
    multiple_upload_picture_counter++;
    var file_name = ele.value;
    try{file_name = ele.value.match(/(.*)[\/\\]([^\/\\]+)\.\w+$/)[2];}catch(e){}
    var tag_select="";
    if(tags.length>0){
        var tag_select="<select onchange='Element.previous($(this)).value = this.value;'><option value=''>é€‰æ‹©å·²æœ‰æ ‡ç­¾</option>";
        for(var i=0;i<tags.length;i++)
            tag_select+="<option value='"+tags[i]+"'>"+tags[i]+"</option>";
        tag_select+="</select>";
    }
    var div = new Element("div").update("<ul><li>æ–‡ä»¶: "+ele.value+" <a href='#' onclick='removePictureDiv(this, \""+ele.id+"\");return false;'>åˆ é™¤</a></li><li>æ ‡ç­¾: <input type='text' name='pictures[][tag_list]' class='text'/>"+tag_select+" å°è´´å£«: å¤šä¸ªæ ‡ç­¾å¯ç”¨åŠè§’é€—å·åˆ†å¼€</li><li>åç§°: <input type='text' name='pictures[][name]' value='"+file_name+"' size='50' class='text'/></li><li>æè¿°: <textarea name='pictures[][description]' style='width:400px;height:80px;'></textarea></li></ul>");
    var new_input = new Element("input",{type:"file",name:ele.name,id:ele.id,disabled:multiple_upload_picture_counter>=max_size});
    Event.observe(new_input,'change',function(){
        addPictureDiv(new_input,max_size,tags);
    });
    ele.insert({before:new_input,after:div});
    ele.id=ele.id+multiple_upload_picture_counter;
    ele.name="pictures[][uploaded_data]";
    div.appendChild(ele.hide().remove());
}
function removePictureDiv(link,eleId){
    multiple_upload_picture_counter--;
    link.parentNode.parentNode.parentNode.remove();
    $(eleId).disabled=false;
}