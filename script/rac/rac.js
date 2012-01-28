//Custom Javascript for Rockefeller Archives Center

function getParameterByName(name) {
 
    name = String(name).replace(/[.*+?|()[\]{}\\]/g, '\\$&');
 
    var match = RegExp('[?&]' + name + '=([^&]*)')
                    .exec(window.location.search);
 
    return match ?
        decodeURIComponent(match[1].replace(/\+/g, ' '))
        : null;
 
}


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
         