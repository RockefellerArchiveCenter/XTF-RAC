$(document).ready(function() {
    $('.facetLess').hide();
    $('.facetGroup').each(function() {
        $(this).children('.facetWrapper').slice(0,5).show();
     })
     
    $(".facetMore").click(function(event){
        event.preventDefault();
        $(this).parent().parent().next(".facetGroup").children().show();
        $(this).parent().prev().children('.facetLess').show();
        $(this).hide();
      });

    $(".facetLess").click(function(event){
        event.preventDefault();
        $(this).parent().parent().next(".facetGroup").children('.facetWrapper').hide();
        $(this).parent().parent().next(".facetGroup").children('.facetWrapper').slice(0,5).show();
        $(this).parent().next().children('.facetMore').show();
        $(this).hide();
        });

});