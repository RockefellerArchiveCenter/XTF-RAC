$(document).ready(function() {
    $('span.notesHide').hide();
    $('div.notes > p').each(function() {
            var $elem = $(this); 		// The element or elements with the text to hide
    		var $limit = 300;		// The number of characters to show
    		var $str = $elem.html();	// Getting the text
    		var $strtemp = jQuery.trim($str).substring(0,$limit).split(" ").slice(0, -1).join(" ") + "...";;	// Get the visible part of the string
    		$strNew = '<span class="notesShow">' + $strtemp + '</span>' + '<span class="notesHide">' + $str + '</span><span class="notesLess"><a href="#">less</a></span>';	// Recompose the string with the span tag wrapped around the hidden part of it
    		if ($str.length > $limit) {   // Write the string to the DOM 
    		$elem.html($strNew + '<span class="notesMore"><a href="#">more</a></span>');
    		} else {
    		$elem.html($str);
    		}
    				
     })
     
    $(".notesMore").click(function(event){
        event.preventDefault();
        $(this).prev().prev().prev('span.notesShow').hide();
        $(this).prev().prev('span.notesHide').show();
        $(this).prev('span.notesLess').show();
        $(this).hide();
      });

    $(".notesLess").click(function(event){
        event.preventDefault();
        $(this).prev('span.notesHide').hide();
        $(this).prev().prev('span.notesShow').show();
        $(this).next('span.notesMore').show();
        $(this).hide();
        });

    $('div.component').click(function() {
    var id = $(this).attr("id").split('_')[1]
    var componentid = "#componentInfo_" + id;
    var position = $(this).position();
    var infoheight = $(componentid).height();
    var windowheight = $(window).height();
    var scrolltop = $(window).scrollTop();
    var offset = position.top - scrolltop
    var fraction = (windowheight / offset);
    var setheight = position.top - (infoheight / fraction);
    $('div.componentDefault').hide();
    $('div.activeArrow').hide();
    $('div.component').removeClass('active');
    $('div.componentInfo').hide();
    $(this).addClass('active');
    $(this).children('div.activeArrow').show();
    $(componentid).show().css({top: setheight, right: '1%', position:'absolute'});
    });
    

})