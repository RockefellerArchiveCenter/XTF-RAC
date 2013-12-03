$(document).ready(function() {
    //$('.notesHide').hide();
    $('div.notesMore').hide();
    $('div.notes > p').each(function() {
            var $elem = $(this); 		// The element or elements with the text to hide
    		var $limit = 300;		// The number of characters to show
    		var $str = $elem.html();	// Getting the text
    		//var $strtemp = jQuery.trim($str).substring(0,$limit).split(" ").slice(0, -1).join(" ") + "...";;	// Get the visible part of the string
    		//$strNew = '<span class="notesShow">' + $strtemp + '</span>' + '<span class="notesHide">' + $str + '</span>';	// Recompose the string with the span tag wrapped around the hidden part of it
    		if ($str.length > $limit) {   // Write the string to the DOM 
    		$elem.parent().next('.notesMore').show();
    		} else {
    		$elem.parent().next('.notesMore').hide();
    	}		
     });
     
    $(".notesMore").click(function(event){
        event.preventDefault();
        //$(this).prev().prev().prev('span.notesShow').hide();
        //$(this).prev().prev('span.notesHide').show();
        $(this).prev('div.notes').css("max-height", "none")
        $(this).next('div.notesLess').show();
        $(this).hide();
      });

    $(".notesLess").click(function(event){
        event.preventDefault();
        //$(this).prev('span.notesHide').hide();
        //$(this).prev().prev('span.notesShow').show();
        $(this).prev().prev('div.notes').css("max-height", "7.5em")
        $(this).prev('div.notesMore').show();
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

    if($(this).hasClass("active")) {
        $(this).removeClass("active");
        $(componentid).hide();
        $('div.activeArrow').hide();
    
    } else {
        $('div.component').removeClass("active");
        $('div.componentDefault').hide();
        $('div.componentInfo').hide();
        $('div.activeArrow').hide();
        $(this).addClass('active');
        if($(window).width() > 485) {
            $(this).next('div.activeArrow').show();
            $(componentid).fadeIn().css({top: setheight, right: '1%', position:'absolute'});
        } else {
            $(componentid).fadeIn();
    }
    }
    });

})