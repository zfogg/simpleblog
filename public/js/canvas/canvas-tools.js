(function canvasMath() {
    Math.direction = function(p1, p2) {
        return { x: p1.x-p2.x, y: p1.y-p2.y };
    };

    Math.hypotenuse = function(a, b) {
        return Math.sqrt( a*a + b*b );
    };

    Math.distance = function(p1, p2) {
        var d = Math.direction(p1, p2);
        return Math.hypotenuse(d.x, d.y);
    };

    Math.negateVector2 = function(v) {
        return { x: -v.x, y: -v.y };
    };

    Math.randomBetween = function(min, max) {
        return Math.random() * (max - min) + min;
    };

    Math.clipValues = function(value, lower, upper) {
        if (value >= lower && value <= upper)
            return value;
        else
            return value < lower ? lower : upper;
    };
})();

function color(x) {
	x = x.call ? x() : (x || 1);
    return '#'+('00000'+(x*16777216<<0).toString(16)).substr(-6);
}

function clearCanvas(canvas, ctx) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
}

function keyWasPressed(e, code) {
    if (window.event)
        return window.event.keyCode === code;
    else
        return e.which === code;
}

function cursorUpdater(cursor, element) {
    return function(e) {
        var x, y;
        if (e.pageX || e.pageY)
          x = e.pageX, y = e.pageY;
        else {
          x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
          y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
        }
        var p = findElementPosition(element);

        cursor.x = x - element.offsetLeft - p.x, cursor.y = y - element.offsetTop - p.y;
    };
}

function findElementPosition(obj) {
    if (obj.offsetParent) {
        var curleft = 0, curtop = 0;
        do {
            curleft += obj.offsetLeft;
            curtop += obj.offsetTop;
        } while (obj = obj.offsetParent);
        return { x: curleft, y: curtop };
    }

    return undefined;
}

window.requestFrame = (function(){
 return  window.requestAnimationFrame       ||
         window.webkitRequestAnimationFrame ||
         window.mozRequestAnimationFrame    ||
         window.oRequestAnimationFrame      ||
         window.msRequestAnimationFrame     ||
         function(/* function */ callback, /* DOMElement */ element){
           window.setTimeout(callback, 1000 / 60);
         };
})();