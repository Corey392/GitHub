/*
	Add the screen Scroll event handler
*/

window.onscroll = function(){
    if(getScrollTop()>300) {
        document.getElementById("header").style.top="150px";
        document.getElementById("header").style.position="fixed";
        
    } else {
        document.getElementById("header").style.top="";
        document.getElementById("header").style.position="";
    }
}

function getScrollTop() {
    if (window.onscroll) {
        // Most browsers
        return window.pageYOffset;
    }

    var d = document.documentElement;
    if (d.clientHeight) {
        // IE in standards mode
        return d.scrollTop;
    }

    // IE in quirks mode
    return document.body.scrollTop;
}
