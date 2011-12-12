//Custom Javascript for Rockefeller Archives Center

//Show hide layers
           function showHide(shID) {
               if (document.getElementById(shID)) {
                   if (document.getElementById(shID + '-show') .style.display != 'none') {
                       document.getElementById(shID + '-show') .style.display = 'none';
                       document.getElementById(shID) .style.display = 'block';
                       document.getElementById(shID + '-hide') .style.display = 'inline';
                   }
                   else {
                       document.getElementById(shID + '-show') .style.display = 'inline';
                       document.getElementById(shID + '-hide') .style.display = 'none';
                       document.getElementById(shID) .style.display = 'none';
                   }
               }
           }
           
// launch new window
         var newwindow;
         function openWin(url) {
             newwindow = window.open(url, 'name', 'height=400,width=500,resizable,scrollbars');
             if (window.focus) {
                 newwindow.focus()
             }
         }
         
// Fixed menu uses the jquery library
        $(function () {
  
          var msie6 = $.browser == 'msie' && $.browser.version < 7;
          
          if (!msie6) {
            var top = $('#toc').offset().top - parseFloat($('#toc').css('margin-top').replace(/auto/, 0));
            $(window).scroll(function (event) {
              // what the y position of the scroll is
              var y = $(this).scrollTop();
              
              // whether that's below the form
              if (y >= top) {
                // if so, ad the fixed class
                $('#toc').addClass('fixed');
              } else {
                // otherwise remove it
                $('#toc').removeClass('fixed');
              }
            });
          }  
        });
     
// This function creates a new anchor element and uses location
// properties (inherent) to get the desired URL data. Some String
// operations are used (to normalize results across browsers).
// source: http://james.padolsey.com/javascript/parsing-urls-with-the-dom/
function parseURL(url) {
    var a =  document.createElement('a');
    a.href = url;
    return {
        source: url,
        protocol: a.protocol.replace(':',''),
        host: a.hostname,
        port: a.port,
        query: a.search,
        params: (function(){
            var ret = {},
                seg = a.search.replace(/^\?/,'').split('&'),
                len = seg.length, i = 0, s;
            for (;i<len;i++) {
                if (!seg[i]) { continue; }
                s = seg[i].split('=');
                ret[s[0]] = s[1];
            }
            return ret;
        })(),
        file: (a.pathname.match(/\/([^\/?#]+)$/i) || [,''])[1],
        hash: a.hash.replace('#',''),
        path: a.pathname.replace(/^([^\/])/,'/$1'),
        relative: (a.href.match(/tps?:\/\/[^\/]+(.+)/) || [,''])[1],
        segments: a.pathname.replace(/^\//,'').split('/')
    };
}

$(document).ready(function() {
    $('a[rel="external"]').live('click', function() {
        window.open( $(this).attr('href') );
        return false;
    });
});

$(document).ready(function() {
    $(".returnTop").live('click', function() {
        window.location = window.location;
        $.scrollTo('#top', {duration: 800, axis:"y"});
        return false;
    });
});

//Load external content
$(function() {
    var newHash      = "",
        $mainContent = $("#content-right"),
        $pageWrap    = $("#main"),
        baseHeight   = 0,
        $el;
        
    $pageWrap.height($pageWrap.height());
    baseHeight = $pageWrap.height() - $mainContent.height();
    
    //build url in location bar for bookmarking
    $(".ajaxtrigger").click(function() {
        var myURL = parseURL($(this).attr('href'));
        window.location.hash = myURL.file.replace('.html','');
        window.location.search = '';
        return false;
    });
    
    //build url in location bar for bookmarking, with parameters for anchors in submenus
    $(".ajaxanchor").click(function() {
        var myURL = parseURL($(this).attr('href'));
        window.location.hash = myURL.file.replace('.html','');
        if(myURL.hash){
            window.location.search = ("?anchor=" + myURL.hash);
        }
        else{
            window.location.search = '';
        };
        return false;
    });

    $(window).bind('hashchange', function(){
        myURL = parseURL(window.location),
        newHash = myURL.hash;
        
        //load external content if hash has changed
        if (newHash) {
            $mainContent
                .find("#ajaxContent")
                .fadeOut(200, function() {
                    $mainContent.hide().load(newHash+".html" + " #ajaxContent", function() {
                        $mainContent.fadeIn(200, function() {
                            $pageWrap.animate({
                                height: baseHeight + $mainContent.height() + "px"
                            });
                            //if url includes query parameters use scrollto plugin to go to anchor
                            if(myURL.query) {
                            var anchor = myURL.query.substring(8)
                                $.scrollTo('#'+anchor, {duration: 800, axis:"y"});
                            };
                        });                  

                });

            });
             
        };

    });
    
    $(window).trigger('hashchange');

});