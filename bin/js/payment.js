var ua = navigator.userAgent.toLowerCase();
var browser = (ua.match(/(^|\s)(firefox|safari|opera|msie|chrome)[\/:\s]([\d\.]+)/) || ['', '', '', '0.0'])[2];

function openIframeDoiXu(url)
{
	showPaymentDialog(url, 500, 500);
}

function openIframeNapThe(url)
{
	showPaymentDialog(url, 500, 500);
}

function showPaymentDialog(ifUrl, width, height) {	
	balance_changed = false;
	if (!document.getElementById('payment')) {
		var e = document.createElement('iframe');
		e.id = 'payment';
		e.scrolling = 'no';
		e.scroll = 'no';
		e.src = ifUrl;		
		e.frameBorder = '0';
		e.allowTransparency = 'true';
		e.style.width = width+'px';
		e.style.height = height+'px';		
		e.style.top = '-9999px';
		e.style.left = '0px';
		e.style.zIndex = '999999';				
		e.style.position = browser == 'msie' ? 'absolute' : 'fixed';
		document.body.appendChild(e);
	}
	else{
		document.getElementById('payment').src = ifUrl;
	}	
	var frame = document.getElementById('payment');
	var view = getViewport();
	frame.style.top = (view.offsetY + (view.height-height)/2) + 'px';
	frame.style.left = (view.offsetX + (view.width-width)/2) + 'px';
}


var flash_width = 1260;
var flash_height = 650;
var screen_height = 895;

// var offset = (document.documentElement.clientWidth - flash_width + 219);
// $("#content").animate({"margin-left": offset / 2}, 300, function(){});

function setLayerOffset(off)
{
    // var offSetX = (document.documentElement.clientWidth - flash_width + off);
    $("#content").animate({"margin-left": off}, 300, function(){});
    var nWidthFlash = $(window).width() - off;
    nWidthFlash = Math.min(flash_width, nWidthFlash);
    var nHeightFlash = Math.min(flash_height, $(window).height());
    if (nWidthFlash >= flash_width && nHeightFlash < flash_height)
        nWidthFlash = nHeightFlash * flash_width / flash_height;
    else if (nWidthFlash < flash_width && nHeightFlash >= flash_height)
        nHeightFlash = nWidthFlash * flash_height / flash_width;
    else if (nWidthFlash < flash_width && nHeightFlash < flash_height)
    {
        var nWidthFlashTemp = nHeightFlash * flash_width / flash_height;
        var nHeightFlashTemp = nWidthFlash * flash_height / flash_width;
        nWidthFlash = Math.min(nWidthFlashTemp, nWidthFlash);
        nHeightFlash = Math.min(nHeightFlashTemp, nHeightFlash);
    }
    $('#flashContain').css({
        'width': nWidthFlash,
        'height': nHeightFlash
    });

    if ($(window).height() < screen_height)
    {
        var nScrollY = (screen_height - nHeightFlash) / 2;
        var nDelta = ($(window).height() - nHeightFlash) / 2;
        nScrollY -= nDelta;
        setTimeout(function(){window.scrollTo(0, nScrollY)}, 1000);
    }
}

var isSideBarOn = true;
function onSideBar()
{
    if(isSideBarOn)
    {
        $("#sideBar").animate({"margin-left":'-220'}, 300, function(){});
        setLayerOffset(17);
        isSideBarOn = false;
        $("#toggle").removeClass("CloseBtn");
        $("#toggle").addClass("OpenBtn");
    }
    else
    {
        $("#sideBar").animate({"margin-left":'0'}, 300, function(){});
        setLayerOffset(237);
        isSideBarOn = true;
        $("#toggle").removeClass("OpenBtn");
        $("#toggle").addClass("CloseBtn");
    }
}

function onResize()
{
    if(isSideBarOn)
        setLayerOffset(237);
    else
        setLayerOffset(17);
}

$(document).ready(function () {
    var nWidthFlash = $(window).width() - 237;
    if (nWidthFlash < flash_width)
    	onSideBar();
    else
		setLayerOffset(237);
	$(window).resize(onResize);
});

function hidePaymentDialog(obj){
	var elem = document.getElementById('payment');
	elem.style.top = '-9999px';
	elem.style.left = '0px';
	elem.src = '';
	
	//var p = obj.message.split('_');
	//if(p[1] === 'true') {
		// var flashObj = getFlashMovieObject("myfarm");
		//flashObj.updateG();		
		var flash = document.getElementById("myfarm");
		flash.UpdateUserInfo();
	//}
}

function getViewport() {
	var result = {}, docElem = document.documentElement, body = document.body;
	if (window.innerWidth) {
		result.width = window.innerWidth;
		result.height = window.innerHeight;
	}
	else {
		result.width = docElem.clientWidth;
		if (result.width == 0) {
			result.width = body.clientWidth;
			result.height = body.clientHeight;
		}
		else
			result.height = docElem.clientHeight;
	}
	if (typeof window.pageYOffset === 'number') {
		result.offsetY = window.pageYOffset;
		result.offsetX = window.pageXOffset;
	}
	else if ( docElem && (docElem.scrollLeft || docElem.scrollTop)) {
		result.offsetY = docElem.scrollTop;
		result.offsetX = docElem.scrollLeft;
	}
	else if (body && (typeof body.scrollLeft === 'number')) {
		result.offsetY = body.scrollTop;
		result.offsetX = body.scrollLeft;
	}
	return result;
}

function proxyCall(obj) {
	if (obj.message.indexOf('hide') >= 0) {
		hidePaymentDialog(obj);
	}
}

function getFlashMovieObject(movieName){
	if (window.document[movieName]){
		return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName])
			return document.embeds[movieName];
	}
	else{
		return document.getElementById(movieName);
	}
}

function openPaymentATM(url)
{
	window.open(url,'_blank');
}
