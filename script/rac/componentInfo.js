$(document).ready(function () {
    
    $('div.notesMore').hide();
    $('.notes > div').each(function () {
        var height = $(this).height();
        var parentHeight = $(this).parent().height();
        if (height > parentHeight) {
            $(this).parent().next('.notesMore').show();
        } else {
            $(this).parent().next('.notesMore').hide();
        }
    });
    
    $(".notesMore").click(function (event) {
        event.preventDefault();
        $(this).prev('div.notes').css("max-height", "none")
        $(this).next('div.notesLess').show();
        $(this).hide();
    });
    
    $(".notesLess").click(function (event) {
        event.preventDefault();
        $(this).prev().prev('div.notes').css("max-height", "7.5em")
        $(this).prev('div.notesMore').show();
        $(this).hide();
    });
    
    if ($(window).width() > 768) {
        
        $('div.component').mouseenter(function () {
            var firstcomponent = '#' + $('.docHit').attr('id') + '> .top-level';
            var id = $(this).attr("id").split('_')[1]
            var componentid = "#componentInfo_" + id;
            var position = $(this).position();
            var infoheight = $(componentid).height();
            var windowheight = $(window).height();
            var windowheightnoscroll = $(window).height() + $(firstcomponent).position().top;
            var scrolltop = $(window).scrollTop();
            var scrolltopnoscroll = $(firstcomponent).position().top - $(window).scrollTop();
            var offset = position.top - (scrolltop);
            var offsetnoscroll = position.top - (scrolltopnoscroll);
            var fraction = (windowheight / offset);
            var fractionnoscroll = (windowheight + $(firstcomponent).position().top) / offsetnoscroll;
            var setheight = position.top - (infoheight / fraction);
            var setheightnoscroll = position.top - (infoheight / fractionnoscroll);
            
            if ($(this).hasClass("active")) {
            } else {
                $('div.component').removeClass("active");
                $('div.componentInfo').css('visibility', 'hidden');
                $('div.activeArrow').css('visibility', 'hidden');
                $(componentid).prev('div.activeArrow').css('visibility', 'visible');
                $(this).addClass('active');
                setTimeout(function () {
                    $('div.componentInfo').css('visibility', 'hidden');
                    if (scrolltop < 261) {
                        $(componentid).css({
                            top: setheightnoscroll, right: '1%', position: 'absolute', visibility: 'visible'
                        }).hide().show("slide", { direction: "left" }, 500, 'easeInCirc');
                    } else {
                        $(componentid).css({
                            top: setheight, right: '1%', position: 'absolute', visibility: 'visible'
                        }).hide().show("slide", { direction: "left" }, 500, 'easeInCirc');
                    }
                }, 200);
            }
        });
    }
})