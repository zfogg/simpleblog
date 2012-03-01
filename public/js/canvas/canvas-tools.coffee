# A collection of tools to assist in canvas development.
C$ =

    color: (x = 1) ->
        x = x() if x.call
        '#'+("00000"+(x*16777216<<0).toString 16).substr(-6)

    clearCanvas: (canvas, ctx) -> ctx.clearRect 0, 0, canvas.width, canvas.height

    keyWasPressed: (e, code) ->
        if window.event
            window.event.keyCode is code
        else e.which is code

    cursorUpdater: (cursor, element) ->
        (e) ->
            x = y = 0
            if e.pageX or e.pageY
                x = e.pageX
                y = e.pageY
            else
                x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
                y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
            p = C$.findElementPosition element
            cursor.x = x - element.offsetLeft - p.x
            cursor.y = y - element.offsetTop - p.y

    findElementPosition: (obj) ->
        if obj.offsetParent
            curleft = curtop = 0
            loop
                curleft += obj.offsetLeft
                curtop += obj.offsetTop
                break unless obj = obj.offsetParent
            (x: curleft, y: curtop)

        else undefined

    $Id: (id) ->
      document.getElementById id

# Maths

Math.direction = (p1, p2) -> new Vector2 p1.x - p2.x, p1.y - p2.y

Math.hypotenuse = (a, b) -> Math.sqrt a*a + b*b

Math.distance = (p1, p2) ->
    d = Math.direction p1, p2
    Math.hypotenuse d.x, d.y

Math.roundDigits = (n, digits) ->
    parseFloat (
        ((Math.round (n * (Math.pow 10, digits)).toFixed(digits-1)) / (Math.pow 10,digits)).toFixed digits
    )

Math.randomBetween = (min, max) -> Math.random() * (max - min) + min

Math.clipValues = (value, lower, upper) ->
    if value >= lower and value <= upper
        value
    else
        if value < lower then lower else upper

Math.commonRangeCoefficient = (n, range, coefficient = 1) ->
    if n < range.lower
        Math.commonRangeCoefficient n * 10, range, coefficient * 10
    else if n > range.upper
        Math.commonRangeCoefficient n / 10, range, coefficient / 10
    else coefficient

class Vector2
  constructor: (@x = 0, @y = 0) ->

# Et cetera.
window.requestFrame = do ->
    window.requestAnimationFrame       or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame    or
    window.oRequestAnimationFrame      or
    window.msRequestAnimationFrame     or
    (callback, element) -> window.setTimeout callback, 1000 / 60

