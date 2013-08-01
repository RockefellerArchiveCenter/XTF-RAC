$(document).ready(function() {
var active = "#" + $.cookie('openContent');

$('.accordionButton').click(function() {
$('.accordionButton').removeClass('on');
$('.accordionContent').slideUp('normal');

if($(this).next().is(':hidden') == true) {
$(this).addClass('on');
$(this).next().slideDown('normal');}
$.cookie('openContent', $(this).attr("id")); 
});

$('.accordionButton').mouseover(function() {
$(this).addClass('over');})
.mouseout(function() {
$(this).removeClass('over');										
            	});
$('.accordionContent').click(function(){
$('.accordionButton').removeClass('on');
});

$('.accordionContent').hide();
$(active).next().show();
$.removeCookie('openContent');
});