$(document).ready(function() {

$('.dropdownButton').click(function() {
$('.dropdownContent').slideUp('normal', function (){
$('.dropdownButton').removeClass('on', 400);});

if($(this).next().is(':hidden') == true) {
$('.dropdownButton').addClass('on')
$('.dropdownContent').slideDown('normal');
} 		  
});
            	 
$('.dropdownButton').mouseover(function() {
$(this).addClass('over');
})
.mouseout(function() {
$(this).removeClass('over');										
});

$('.dropdownContent').click(function(){
$('.dropdownContent').slideUp('normal', function (){
$('.dropdownButton').removeClass('on', 400);});
});

$('.dropdownContent').hide();

});