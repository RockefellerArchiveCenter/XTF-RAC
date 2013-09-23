$(document).ready(function() {
var id = "#" + $(".c01").attr("id");
var menu = id + "Menu";
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
else if ($(id).is(':visible')){
$(".accordionContent").hide();
$(".tocRow").removeClass("on");
$(menu).addClass("active");
if ($(menu).hasClass("accordionButton")){
    $(menu).addClass("on");}
$(menu).next().show();}
else {}
    });