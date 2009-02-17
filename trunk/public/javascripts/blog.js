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
        },
        onLoading:function(request){
            Element.show('comment_loading');
        },
        parameters:Form.serialize(_from)
    });
}
