$(document).ready(function() {
    $('.subdocument').click(function() {
    $('div.componentDefault').hide();
    $('div.showLess').hide();
    $('div.showMore').show();
    $('div.subdocument').removeClass('active');
    $('div.componentInfo').hide();
    $(this).addClass('active');
    $(this).next('div.componentInfo').show();
    $(this).children('div.showMore').hide();
    $(this).children('div.showLess').show();
    });
});