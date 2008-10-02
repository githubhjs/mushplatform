function display_category_input(obj_id){
    toggle_element(obj_id);
}

function add_category(){
    var category_input = $("add_ctegory_input");
    if(category_input.value == ""){
        alert("请输入类别名");
    }
    var url = "/manage/categories/ajax_new?category_name=" + category_input.value ;
    var regx = /^\d+$/
    new Ajax.Request(url,{
        method:'get',
        onComplete:function(response) {
            if(regx.test(response.responseText)){
                update_category_options(category_input.value,response.responseText);
                new Effect.Highlight("blog_category_id");
                category_input.value = ""
                Element.hide("ajax_category_form");
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

function update_category_options(text,value){
    var caegory_select = $("blog_category_id");
    add_item_to_select(caegory_select,text,value);
}

function add_item_to_select(objSelect, objItemText, objItemValue) {        
    var varItem = new Option(objItemText, objItemValue);
    objSelect.options.add(varItem);
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
    {   method:post,
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
    new Ajax.Request('/manage/sidebars/friend_link/edit', {
        method:'get',
        asynchronous:false,
        evalScripts:true,
        onComplete:function(){
          Element.hide('onload_img');
          Element.hide('edit_'+bar_id);
        },
        parameters:Form.serialize(_from)
        })
}
