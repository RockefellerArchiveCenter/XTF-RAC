$(document).ready(function() {
    $('div.facetLess').hide();
    $('div.facetGroup > li.facetWrapper').hide();
    $('.facetGroup').each(function() {
        $(this).children('.facetWrapper').slice(0,5).show();
     })
     
    $(".facetMore").click(function(event){
        event.preventDefault();
        $(this).parent(".facetGroup").children().show();
        $(this).hide();
      });

    $(".facetLess").click(function(event){
        event.preventDefault();
        $(this).parent(".facetGroup").children('.facetWrapper').hide();
        $(this).parent(".facetGroup").children('.facetWrapper').slice(0,5).show();
        $(this).parent(".facetGroup").children('.facetMore').show();
        $(this).hide();
        });

});