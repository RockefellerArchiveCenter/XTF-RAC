$(document).ready(function() {
var open = "#" + $.cookie('openContent');
//var active = "#" + $.cookie('activeComponent');

$('.accordionButton').click(function() {
$('.accordionButton').removeClass('on');
$('.accordionContent').slideUp('normal');

if($(this).next().is(':hidden') == true) {
$(this).addClass('on');
$(this).next().slideDown('normal');}
$.removeCookie('openContent');
$.cookie('openContent', $(this).attr("id")); 
});

$('.tocRow a').click(function() {
//$('.accordionButton').removeClass('active');
//$(this).parent().addClass('active');
$.removeCookie('openContent');
//$.removeCookie('activeComponent');
//$.cookie('activeComponent', $(this).parent().attr("id"));
});

////$('.tocSubrow a').click(function() {
//$('.accordionButton').removeClass('active');
//$(this).parent().addClass('active');
//$.removeCookie('activeComponent');
//$.cookie('activeComponent', $(this).parent().attr("id"));
//});

//$('.accordionButton').mouseover(function() {
//$(this).addClass('over');})
//$('.accordionButton').mouseout(function() {
//$(this).removeClass('over');										
//            	});
//$('.accordionContent').click(function(){
//$('.accordionButton').removeClass('on');
//});

$('.accordionContent').hide();
$(open).next().show();
$(open).addClass('on');
//$(active).addClass('active');

// id = $.url('&chunk.id')
//alert(id)
});