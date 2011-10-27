# Maths

Math.direction = (p1, p2) -> (x: p1.x - p2.x, y: p1.y - p2.y)

Math.hypotenuse = (a, b) -> Math.sqrt a*a + b*b

Math.distance = (p1, p2) ->
    d = Math.direction p1, p2
    Math.hypotenuse d.x, d.y

Math.randomBetween = (min, max) -> Math.random() * (max - min) + min

Math.clipValues = (value, lower, upper) ->
    if value >= lower and value <= upper
        value
    else
        value < lower ? lower : upper

#
# Assorted helper functions
#

color = (x = 1) ->
    x = x() if x.call
    '#'+("00000"+(x*16777216<<0).toString 16).substr(-6)

clearCanvas = (canvas, ctx) -> ctx.clearRect 0, 0, canvas.width, canvas.height

keyWasPressed = (e, code) ->
    if window.event
        window.event.keyCode is code
    else
        e.which is code

cursorUpdater = (cursor, element) ->
    (e) ->
        x = y = 0
        if e.pageX or e.pageY
            x = e.pageX
            y = e.pageY
        else
            x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
            y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
        p = findElementPosition element
        cursor.x = x - element.offsetLeft - p.x
        cursor.y = y - element.offsetTop - p.y

findElementPosition = (obj) ->
    if obj.offsetParent
        curleft = curtop = 0
        loop
            curleft += obj.offsetLeft
            curtop += obj.offsetTop
            break unless obj = obj.offsetParent
        (x: curleft, y: curtop)

    else
        undefined

window.requestFrame = do ->
    window.requestAnimationFrame       or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame    or
    window.oRequestAnimationFrame      or
    window.msRequestAnimationFrame     or
    (callback, element) -> window.setTimeout callback, 1000 / 60
