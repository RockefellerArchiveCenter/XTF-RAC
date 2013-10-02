$(document).ready(function(){
    setTimeout(function() {
    checkIfInView($('.active'));}, 500);
});

function checkIfInView(element){
    var offset = element.offset().top - $(window).scrollTop();

    if(offset > $('#tocWrapper').innerHeight()){
        // Not in view
        $('#tocWrapper').animate({scrollTop: offset}, 700);
        return false;
    } 
   return true;
}