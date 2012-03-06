# A collection of tools to assist in canvas development.

window.C$ =

  color: (x = 1) ->
    x = x() if x.call
    '#'+("00000"+(x*16777216<<0).toString 16).substr(-6)

  clearCanvas: (canvas, ctx) ->
    ctx.clearRect 0, 0, canvas.width, canvas.height

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

  Math:

    PHI: 1/2*(1 + Math.sqrt 5)

    direction: (p1, p2) ->
      new C$.Vector2 p1.x - p2.x, p1.y - p2.y

    hypotenuse: (a, b) ->
      Math.sqrt a*a + b*b

    distance: (p1, p2) ->
      d = @direction p1, p2
      @hypotenuse d.x, d.y

    roundDigits: (n, digits) ->
      parseFloat \
        ((Math.round (n * (Math.pow 10, digits)).toFixed(digits-1)) / (Math.pow 10,digits)).toFixed digits

    randomBetween: (min, max) -> Math.random() * (max - min) + min

    clipValues: (value, lower, upper) ->
      if value >= lower and value <= upper
        value
      else
        if value < lower then lower else upper

    commonRangeCoefficient: (n, range, coefficient = 1) ->
      if n < range.lower
        @commonRangeCoefficient n * 10, range, coefficient * 10
      else if n > range.upper
        @commonRangeCoefficient n / 10, range, coefficient / 10
      else coefficient

  # Classes
  Vector2: class
    constructor: (@x = 0, @y = 0) ->



# Et cetera.
window.requestFrame = do ->
  window.requestAnimationFrame       or
  window.webkitRequestAnimationFrame or
  window.mozRequestAnimationFrame    or
  window.oRequestAnimationFrame      or
  window.msRequestAnimationFrame     or
  (callback, element) -> window.setTimeout callback, 1000 / 60

Array::random = ->
  @[Math.random() * @length | 0]

Array::toSet = ->
  s = {}
  s[x] = i for x,i in @
  @[v] for k,v of s
