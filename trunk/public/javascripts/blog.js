function submit_comment(){
    var oEditor = FCKeditorAPI.GetInstance('comment[body]');
    document.getElementById('comment_body').value = oEditor.GetXHTML();
    var form = $('comment_form');
    if(form['comment[body]'].value != '' && form['comment[body]'].value.length >= 5 ) //&& form['comment[title]'].value != '' && form['comment[title]'].value.length  >= 1 )
    {
        ajax_submit(form)
        this.disabled=true;
    }else{
        alert("内容字数不够!");
    }
    return false;
}

function submit_player_comment(){

    var oEditor = FCKeditorAPI.GetInstance('comment[content]');

    document.getElementById('comment_body').value = oEditor.GetXHTML();

    var player_comment_form = document.getElementById('player_comment_form');

    if(player_comment_form['comment[content]'].value != '' && player_comment_form['comment[content]'].value.length >= 5 ) //&& form['comment[title]'].value != '' && form['comment[title]'].value.length  >= 1 )
    {
        ajax_submit(player_comment_form)
        this.disabled=true;
    }else{
        alert("内容字数不够!");
    }
    return false;
}

function post_vote(){
    var vote_form = document.vote_form;    
    if(vote_form['captcha'].value != ''){
        new Ajax.Request(vote_form.action,
        {
            method:'post',
            asynchronous:true,
            evalScripts:true,                        
            parameters:Form.serialize(vote_form)
        });
    }else{
        alert('请输入验证码');
    }
    return false;
}

function post_small_vote(location,user_id){
    var vote_form = $('vote_form_'+location+'_'+user_id);    
    if(vote_form['captcha'].value != ''){
        new Ajax.Request(vote_form.action,
        {
            method:'post',
            asynchronous:true,
            evalScripts:true,
            parameters:Form.serialize(vote_form)
        });
    }else{
        alert('请输入验证码');
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
            $('comment_body').value ='';
            var oEditor = FCKeditorAPI.GetInstance('comment[body]');
            oEditor.SetData('');
        },
        onLoading:function(request){
            Element.show('comment_loading');
        },
        parameters:Form.serialize(_from)
    });
}
