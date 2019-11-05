theVersion= navigator.appVersion
isDOM = (document.getElementById) ? true : false;
isIE = (document.all) ? true : false; 
isIE4 = isIE && !isDOM; 
isIE5 = isIE && isDOM; 
isMac = (navigator.appVersion.indexOf("Mac") != -1); 
isMacIE = isMac && isIE;
if (isMac && theVersion == "4.0 (compatible; MSIE 4.01; Macintosh; I; PPC)") {  var isMacIE40 = 1;  }
if (isMac && theVersion == "4.0 (compatible; MSIE 4.0; Macintosh; I; PPC)") {   var isMacIE40 = 1;  }

isMacIE5 = isIE5 && isMac; 
isIEW = isIE && !isMac;
isIE4W = isIE4 && isIEW; 
isIE5W = isIE5 && isIEW; 
isNS = navigator.appName == ("Netscape");
isNS4 = (document.layers) ? true : false; 
isMacNS = isNS4 && isMac;
isNS6 = navigator.vendor == ("Netscape6"); 
if(isMacIE5) {
	isDOM = false;
	isIE4 = true;  
}

if (isMacIE && !isMacIE40 && !isMacIE5) {   var isMacIE45 = 1;  }


function NSresize() {
  if (document.FIX.NSfix.initWindowWidth != window.innerWidth || document.FIX.NSfix.initWindowHeight != window.innerHeight) {
    document.location = document.location;
  }
}

function NSCheck() {
  if ((navigator.appName == 'Netscape') && (parseInt(navigator.appVersion) == 4)) {
    if (typeof document.FIX == 'undefined'){
      document.FIX = new Object;
    }
    if (typeof document.FIX.FIX_scaleFont == 'undefined') {
      document.FIX.NSfix = new Object;
      document.FIX.NSfix.initWindowWidth = window.innerWidth;
      document.FIX.NSfix.initWindowHeight = window.innerHeight;
    }
    window.onresize = NSresize;
  }
}

NSCheck()
