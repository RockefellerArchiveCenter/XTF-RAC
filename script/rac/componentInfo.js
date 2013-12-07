$(document).ready(function() {
    if ($('#docHits').length) {
    var defaultHeight = $('#main_1 .top-level').position().top;
    $('div.componentDefault').css("top", defaultHeight);
    }
    $('div.notesMore').hide();
    $('.notes > div').each(function() {
            var height = $(this).height();
    		var parentHeight = $(this).parent().height();	
    		if (height > parentHeight) { 
    		$(this).parent().next('.notesMore').show();
    		} else {
    		$(this).parent().next('.notesMore').hide();
    	}		
     });
     
    $(".notesMore").click(function(event){
        event.preventDefault();
        $(this).prev('div.notes').css("max-height", "none")
        $(this).next('div.notesLess').show();
        $(this).hide();
      });

    $(".notesLess").click(function(event){
        event.preventDefault();
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
    var offset = position.top - (scrolltop);
    var fraction = (windowheight / offset);
    var setheight = position.top - (infoheight / fraction);

    if($(this).hasClass("active")) {
        $(this).removeClass("active");
        $(componentid).css('visibility','hidden');
        $('div.activeArrow').hide();
    
    } else {
        $('div.component').removeClass("active");
        $('div.componentDefault').hide();
        $('div.componentInfo').css('visibility','hidden');
        $('div.activeArrow').hide();
        $(this).addClass('active');
        if($(window).width() > 485) {
            $(this).next('div.activeArrow').show();
            $(componentid).fadeIn().css({top: setheight, right: '1%', position:'absolute', visibility:'visible'});
        } else {
            $(componentid).css('position', 'relative').show();
    }
    }
    });

})