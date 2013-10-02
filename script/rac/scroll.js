$(document).ready(function(){
if ($('#toc > .contentsList').length) {
    setTimeout(function() {
    checkIfInView($('.active'));}, 500);
    }
});

function checkIfInView(element){
    var offset = element.offset().top - $('#tocWrapper').innerHeight();

    if(offset > 0){
        // Not in view
        $('#tocWrapper').animate({scrollTop: offset}, 700);
        return false;
    } 
   return true;
}