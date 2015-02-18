$(document).ready(function () {
    if ($('div#toc > div.contentsList').length) {
        setTimeout(function () {
            checkIfInView($('div.active'), 'load');
        },
        500);
        $('#content-wrapper').scroll(function () {
            clearTimeout($.data(this, "scrollCheck"));
            $.data(this, "scrollCheck", setTimeout(function () {
                checkIfInView($('#toc div.active'), 'scroll');
            },
            50));
        });
    }
});

function checkIfInView(element, action) {
    
    if (action === 'load') {
        var offset = element.offset().top - $('div#tocWrapper').innerHeight();
        if (offset > 250) {
            console.log(action)
            // Not in view
            $('div#tocWrapper').animate({
                scrollTop: offset
            },
            700);
            return false;
        }
    } else if (action === 'scroll') {
        var tocHeight = $('div#tocWrapper .contentsList').innerHeight();
        var visibleTocHeight = $('div#tocWrapper').innerHeight();
        var tocTop = 267;
        var footerHeight = $('.fixedFooter').innerHeight();
        var elementTop = element.offset().top;
        var moveUp = tocTop + visibleTocHeight - 100;
        var maxScroll = tocHeight + tocTop - $(window).height() + footerHeight;
        if (moveUp < elementTop) {
            var distance = elementTop - tocHeight;
            var currentScrollTop = $('div#tocWrapper').scrollTop();
            var newScrollTop = currentScrollTop + distance
            if (newScrollTop < maxScroll) {
                $('div#tocWrapper').animate({
                    scrollTop: newScrollTop
                },
                300);
            } else if (newScrollTop > maxScroll) {
                $('div#tocWrapper').animate({
                    scrollTop: maxScroll
                },
                300);
            } else {
                return false;
            }
        } else if (tocTop > elementTop) {
            var distance = elementTop - tocHeight;
            var currentScrollTop = $('div#tocWrapper').scrollTop();
            var newScrollTop = currentScrollTop + distance
            if (newScrollTop > 0) {
                $('div#tocWrapper').animate({
                    scrollTop: newScrollTop
                },
                300);
            } else if (newScrollTop < 0) {
                $('div#tocWrapper').animate({
                    scrollTop: 0
                },
                300);
            } else {
                return false;
            }
        }
    }
    return true;
}