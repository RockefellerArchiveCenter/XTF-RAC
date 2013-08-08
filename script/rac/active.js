$(document).ready(function() {
if($("#headerlink").is(':visible')){
    $("#headerlinkMenu").addClass("active"); } 
else if ($("#restrictlink").is(':visible')){
    $("#restrictlinkMenu").addClass("active"); } 
else if ($("#arrangementlink").is(':visible')){
    $("#arrangementlinkMenu").addClass("active"); } 
else if ($("#bioghist").is(':visible')){
    $("#bioghistMenu").addClass("active"); }
else if ($("#adminlink").is(':visible')){
    $("#adminlinkMenu").addClass("active"); } 
else if ($("#physdesclink").is(':visible')){
    $("#physdesclinkMenu").addClass("active"); } 
else {}   
    });