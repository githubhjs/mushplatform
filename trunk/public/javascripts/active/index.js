var div_mm=$('#div_mm a');
div_mm.click(function()
{
    var j=div_mm.index($(this)[0]);
    if(j!=12)
    {
        div_mm.eq(j).css('cursor','').attr('class','aaon').siblings().not(div_mm.eq(12)).attr('class','aa').css('cursor','pointer');
        $('#div_cc>ul').eq(j).show().siblings().hide();
    }
});