function display_category_input(obj_id){
    toggle_element(obj_id);
}


//function add_category(){
//    var category_input = $("add_ctegory_input");
//    if(category_input.value == ""){
//        alert("请输入类别名");
//    }
//    var url = "/manage/categories/ajax_new?category_name=" + category_input.value ;
//    var regx = /^\d+$/
//    new Ajax.Request(url,{
//        method:'get',
//        onComplete:function(response) {
//            if(regx.test(response.responseText)){
//                update_category_options(category_input.value,response.responseText);
//                new Effect.Highlight("blog_category_id");
//                category_input.value = ""
//                Element.hide("ajax_category_form");
//                Element.hide("onload_img");
//            }else{
//                alert(response.responseText);
//                Element.hide("onload_img");
//            }
//        },
//        onLoading:function(){
//            Element.show("onload_img");
//        }
//    });
//}

function add_category(){
    var category_input = $('add_ctegory_input');
    if(category_input.value == ""){
        alert("请输入类别名");
        return;
    }
    var url = "/manage/categories/ajax_new?category_name=" + category_input.value ;
    add_select_entry('ajax_category_form',category_input,'blog_category_id',url)
}

function add_album(){
    var album_input = $('add_album_input');
    if(album_input.value == ""){
        alert("请输入类别名");
        return;
    }
    var url = "/manage/photos/ajax_create_alubm?title=" + album_input.value ;
    add_select_entry('ajax_album_form',album_input,'photo_album_id',url);
}

function add_select_entry(form_id,category_input,select_id,url){
        var regx = /^\d+$/
        new Ajax.Request(url,{
            method:'get',
            onComplete:function(response) {
                if(regx.test(response.responseText)){
                    update_category_options(select_id,category_input.value,response.responseText);
                    category_input.value = ""
                    Element.hide(form_id);
                    Element.hide("onload_img");
                }else{
                    alert(response.responseText);
                    Element.hide("onload_img");
                }
            },
            onLoading:function(){
                Element.show("onload_img");
            }
        });
}

function update_category(category_id){
    var input_id = "text_input_" + category_id
    var category_input = $(input_id);
    $('notice_text').innerHTML = ''
    if(category_input.value == ""){
        alert("请输入类别名");
    }
    var url = "/manage/categories/"+category_id+"/ajax_update?category_name=" + category_input.value ;
    new Ajax.Request(url,{
        method:'get'
    });
}

function update_category_options(selec_id,text,value){
    var caegory_select = $(selec_id);
    add_item_to_select(caegory_select,text,value);
}

function add_item_to_select(objSelect, objItemText, objItemValue) {        
    var varItem = new Option(objItemText, objItemValue);
    objSelect.options.add(varItem);
    varItem.selected = true;
}

function toggle_element(obj_id)
{
    try {
        $(obj_id).toggle();
    }catch (e){}
}

function select_all(parent_id){
    var select_box = $('ifchecked');
    var check_boxies = $(parent_id).getElementsByTagName('input');
    $A(check_boxies).each(function (box){
        if(box.id != 'ifchecked'){
            box.checked = select_box.checked;
        }
    });
}

function submit_category_form(catgory_form){
    Element.show("onload_img");
    new Ajax.Request('/manage/categories',
    {
        method:post,
        asynchronous:true,
        evalScripts:true,
        parameters:Form.serialize(catgory_form)   
    });
}

function do_delete(element){
    new Ajax.Request(element.href,{
        method:'get'
    });
}

function validate_email(value_str){
    var email_regexp = /^[a-zA-Z0-9_\.]+@[a-zA-Z0-9-]+[\.a-zA-Z]+$/;
    return email_regexp.test(value_str);
}

function validate_user_emial(_input){
    if(validate_email(_input.value)){
        Element.hide('emial_error');
    }else{
        Element.show('emial_error');
    }
}

function validate_form(_form){
    if(validate_email($('user_email').value) && $('user_profile_city').value != ''){
        _form.submit();
    }else{
        alert("请完善必填内容");
    }
}

function post_sidebar_form(_from,bar_id){
    Element.show("onload_img");
    new Ajax.Request(_form.action, {
        method:'get',
        asynchronous:true,
        evalScripts:true,
        onComplete:function(){
            Element.hide('onload_img');
            Element.hide('edit_'+bar_id);
        },
        parameters:Form.serialize(_from)
    })
}
function addAttachmentDiv(ele,max_size){
    if(!$A(['jpg','bmp','png','gif','rar','zip','tar','gz','jar','war', 'bz2']).any(function(extName){
        return new RegExp('\\.'+extName+'$','i').test(ele.value);
    })){
        alert("如果您上传图片，请上传JPG、BMP、PNG或者GIF格式的图片\n如果您上传附件，请先压缩再上传");
        return false;
    }
    multiple_upload_attachment_counter++;
    var div=new Element("div").update("<ul><li>文件: "+ele.value+" <a href='#' onclick='removeAttachmentDiv(this, \""+ele.id+"\");return false;'>删除</a></li><li>注解: <textarea name='attachments[][remark]' style='width:300px;height:80px;'></textarea></li></ul>");
    var new_input=new Element("input",{
        type:"file",
        name:ele.name,
        id:ele.id,
        disabled:multiple_upload_attachment_counter>=max_size
    });
    Event.observe(new_input,'change',function(){
        addAttachmentDiv(new_input,max_size);
    });
    ele.insert({
        before:new_input,
        after:div
    });
    ele.id=ele.id+multiple_upload_attachment_counter;
    ele.name="attachments[][uploaded_data]";
    div.appendChild(ele.hide().remove());
}
function removeAttachmentDiv(link,eleId){
    multiple_upload_attachment_counter--;
    link.parentNode.parentNode.parentNode.remove();
    $(eleId).disabled=false;
}
function multiple_upload_picture(ele,max_size,tags){
    Event.observe(ele,'change',function(){
        addPictureDiv(ele,max_size,tags);
    });
    if(multiple_upload_picture_counter>=max_size)ele.disabled=true;
}
function addPictureDiv(ele,max_size,tags){
    if(!$A(['jpg','bmp','png','gif']).any(function(extName){
        return new RegExp('\\.'+extName+'$','i').test(ele.value);
    })){
        alert("您上传的图片格式不支持，请您上传JPG、BMP、PNG或者GIF格式的图片");
        return false;
    }
    multiple_upload_picture_counter++;
    var file_name=ele.value;
    try{
        file_name=ele.value.match(/(.*)[\/\\]([^\/\\]+)\.\w+$/)[2];
    }catch(e){}
    var tag_select="";
    if(tags.length>0){
        var tag_select="<select onchange='Element.previous($(this)).value = this.value;'><option value=''>选择已有标签</option>";
        for(var i=0;i<tags.length;i++)
            tag_select+="<option value='"+tags[i]+"'>"+tags[i]+"</option>";
        tag_select+="</select>";
    }
    var div=new Element("div").update("<ul><li>文件: "+ele.value+" <a href='#' onclick='removePictureDiv(this, \""+ele.id+"\");return false;'>删除</a></li><li>标签: <input type='text' name='pictures[][tag_list]' class='text'/>"+tag_select+" 小贴士: 多个标签可用半角逗号分开</li><li>名称: <input type='text' name='pictures[][title]' value='"+file_name+"' size='50' class='text'/></li><li>描述: <textarea name='pictures[][description]' style='width:400px;height:80px;'></textarea></li></ul>");
//    var div=new Element("div").update("<ul><li>文件: "+ele.value+" <a href='#' onclick='removePictureDiv(this, \""+ele.id+"\");return false;'>删除</a></li><li>名称: <input type='text' name='pictures[][title]' value='"+file_name+"' size='50' class='text'/></li><li>描述: <textarea name='pictures[][description]' style='width:400px;height:80px;'></textarea></li></ul>");
    var new_input=new Element("input",{
        type:"file",
        name:ele.name,
        id:ele.id,
        disabled:multiple_upload_picture_counter>=max_size
    });
    Event.observe(new_input,'change',function(){
        addPictureDiv(new_input,max_size,tags);
    });
    ele.insert({
        before:new_input,
        after:div
    });
    ele.id=ele.id+multiple_upload_picture_counter;
    ele.name="pictures[][uploaded_data]";
    div.appendChild(ele.hide().remove());
}

function removePictureDiv(link,eleId){
    multiple_upload_picture_counter--;
    link.parentNode.parentNode.parentNode.remove();
    $(ely6eId).disabled=false;
}

function inputOnclick(thisobj)
{
    var options = document.vote_form["vote_values[]"];
    var selectnum = 0;
    for(var i=0 ; i<options.length ; i++)
    {
        if(options[i].checked == true)
        {
            selectnum++;
        }
    }
    if(selectnum > vote_limit)
    {
        thisobj.checked = false;
        alert("根据发起人的设置，本投票最多只能选择" + vote_limit + "个选项!\n\n如果你确定要投票给此选项，请先去除一个已选择项。");
    }
}

function validate_vote_form(){
    var options = document.vote_form["vote_values[]"];
    var flag = false;
    for(var i=0 ; i<options.length ; i++)
    {
        if(options[i].checked == true)
        {
            flag = true;
        }
    }
    if(!flag){
        alert("请至少选择一个候选项");
        return false;
    }
    return true;
}

function select_friend(){
    friend_name = $('friend_name');
    selected_friend = $('selected_friend')
    if(friend_name.value == ''){
        friend_name.value += selected_friend.value;
    }else{
        friend_name.value += (','+selected_friend.value);
    }
    friend_name.value = friend_name.value.replace(',,',',').replace(/,$/,'').replace(/^,/,'');
    selected_friend.value = ''
    $('friend_list').hide();
}

function change_friend(checkbox){
    friend_input = $('selected_friend');
    if(checkbox.checked){
        if(friend_input.value == ''){
            friend_input.value +=  checkbox.value;
        }else{
            friend_input.value +=( ',' + checkbox.value);
        }
    }else{
        friend_name = $('friend_name');
        re=new RegExp(",?"+checkbox.value,"gi")
        friend_input.value = friend_input.value.replace(re,'');
        friend_name.value = friend_name.value.replace(re,'');
    }
}

function submitSearchForm(){    
    var _from = document.search_form;
    var keyword = _from["keywords"];
    if(keyword.value  == '' || keyword.value == keyword.defaultValue){
        alert("请输入关查询关键字");
        return false;
    }
    return true;
}