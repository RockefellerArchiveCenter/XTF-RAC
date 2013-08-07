$(document).ready(function() {
if($("#headerlink").is(':visible')){
    $("#headerlinkMenu").parent().parent().addClass("active"); } 
else if ($("#restrictlink").is(':visible')){
    $("#restrictlinkMenu").parent().parent().addClass("active"); } 
else if ($("#arrangementlink").is(':visible')){
    $("#arrangementlinkMenu").parent().parent().addClass("active"); } 
else if ($("#bioghist").is(':visible')){
    $("#bioghistMenu").parent().parent().addClass("active"); }
else if ($("#adminlink").is(':visible')){
    $("#adminlinkMenu").parent().parent().addClass("active"); } 
else if ($("#physdesclink").is(':visible')){
    $("#physdesclinkMenu").parent().parent().addClass("active"); } 
else {$('.tocRow').click(function(event) {
        $('.tocRow').removeClass("active");
       $(this).addClass("active");
    });    }   
    });