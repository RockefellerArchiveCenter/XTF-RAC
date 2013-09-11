$(document).ready(function() {
var open = "#" + $.cookie('openContent');

$('.accordionButton').click(function() {
$.removeCookie('openContent');
$('.accordionButton').removeClass('on');
$('.accordionContent').slideUp('normal');

if($(this).next().is(':hidden') == true) {
$(this).addClass('on');
$(this).next().slideDown('normal');}
$.removeCookie('openContent');
$.cookie('openContent', $(this).attr("id")); 
});

$('.tocRow a').click(function() {
$.removeCookie('openContent');
});

$('.accordionContent').hide();
$(open).next().show();
$(open).addClass('on');

});