$(document).ready(function () {
    (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s);
        js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.3";
        js.onload = function () {
            FB.Event.subscribe('xfbml.render',
            function (response) {
                var menu = d.getElementById('bookmarkMenu');
                function fadeIn(el) {
                    el.style.opacity = 0;
                    var tick = function () {
                        el.style.opacity = + el.style.opacity + 0.05;
                        if (+ el.style.opacity < 1) {
                            (window.requestAnimationFrame && requestAnimationFrame(tick)) || setTimeout(tick, 16)
                        }
                    };
                    tick();
                }
                fadeIn(menu);
            });
        };
        fjs.parentNode.insertBefore(js, fjs);
    }
    (document, 'script', 'facebook-jssdk'));
});