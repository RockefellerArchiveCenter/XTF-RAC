$(document).ready(function() {
    $('div.facetLess').hide();
    $('div.facetGroup > li.facetWrapper').hide();
    $('.facetGroup').each(function() {
        $(this).children('.facetWrapper').slice(0,5).show();
     })
     
    $(".facetMore").click(function(event){
        event.preventDefault();
        $(this).parent().next(".facetGroup").children().show();
        $(this).prev('.facetLess').show();
        $(this).hide();
      });

    $(".facetLess").click(function(event){
        event.preventDefault();
        $(this).parent().next(".facetGroup").children('.facetWrapper').hide();
        $(this).parent().next(".facetGroup").children('.facetWrapper').slice(0,5).show();
        $(this).next('.facetMore').show();
        $(this).hide();
        });

});