$(document).ready(function() {
    $('.subdocument').click(function() {
    var id = $(this).attr("id").substring(11)
    var componentid = "#componentInfo" + id;
    var position = $(this).position();
    var infoheight = $(componentid).height();
    var windowheight = $(window).height();
    var scrolltop = $(window).scrollTop();
    var offset = position.top - scrolltop
    var fraction = (windowheight / offset);
    var setheight = position.top - (infoheight / fraction);
    $('div.componentDefault').hide();
    $('div.showLess').hide();
    $('div.showMore').show();
    $('div.subdocument').removeClass('active');
    $('div.componentInfo').hide();
    $(this).addClass('active');
    $(componentid).show().css({top: setheight, right: '1%', position:'absolute'});
    $(this).children('div.showMore').hide();
    $(this).children('div.showLess').show();
    });
});