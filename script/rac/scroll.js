$(document).ready(function(){
if ($('div#toc > div.contentsList').length) {
    setTimeout(function() {
    checkIfInView($('div.active'));}, 500);
    }
});

function checkIfInView(element){
    var offset = element.offset().top - $('div#tocWrapper').innerHeight();

    if(offset > 0){
        // Not in view
        $('div#tocWrapper').animate({scrollTop: offset}, 700);
        return false;
    } 
   return true;
}