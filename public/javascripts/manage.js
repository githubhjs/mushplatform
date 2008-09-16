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
    new Ajax.Request(url,{method:'get',onComplete:function(response) {
            if(regx.test(response.responseText)){
                update_category_options(category_input.value,response.responseText);
                new Effect.Highlight("blog_category_id");
                category_input.value = ""
                Element.hide("ajax_category_form");
                Element.hide("onload_img");
            }else{
              alert(response.responseText);
            }  
        },onLoading:function(){
            Element.show("onload_img");
        }});
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

function do_delete(element){
    if (confirm('你确定要删除这篇博客？')) {
        var f =  document.createElement('form');
        f.style.display = 'none';
        element.parentNode.appendChild(f);
        f.method = 'POST';
        f.action = element.href;
        var m = document.createElement('input');
        m.setAttribute('type', 'hidden');
        m.setAttribute('name', '_method');
        m.setAttribute('value', 'delete');
        f.appendChild(m);
        f.submit();
    }
}