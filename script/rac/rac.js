//Custom Javascript for Rockefeller Archives Center

//Get parameter for expandable menu
function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

//Show hide layers
function showHide(shID) {           
           var second = getUrlVars()["menu"];
           
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
