Gravity = (canvas) ->
  ctx = canvas.getContext "2d"
  gameTime = 0
  squares = []

  defaultGravity  = 6.67 * (Math.pow 10, -11) * 100000
  defaultFriction = 0.000115
  defaultDistance = Math.PI

  currentGravity  = { value: defaultGravity }
  currentFriction = { value: defaultFriction }
  currentDistance = { value: defaultDistance }

  class PhysicalBody
    constructor: (@position = new Vector2, @mass = 1, @size = 1, @restitution = 1, @velocity = new Vector2) ->

    updatePosition: -> @position.add @velocity
    applyForce: (acceleration) ->
      @velocity.x += 0.5 * acceleration.x * @mass
      @velocity.y += 0.5 * acceleration.y * @mass

  class Square extends PhysicalBody
    constructor: (@position, @mass, @size, @index, @color) ->
      super @position, @mass, @size, 0.85

    update: (gameTime) ->
      @applyForce attractionOfGravity @, cursor
      @bounceOffLimits canvas.width, canvas.height, @mass*2
      do @updatePosition

      # Decay velocity for an 'arcade' feel.
      @decayVelocity currentFriction.value

      do @draw

    decayVelocity: (n) ->
      @velocity.x -= @velocity.x * n * @mass
      @velocity.y -= @velocity.y * n * @mass

    draw: ->
      ctx.fillStyle = @color
      ctx.fillRect @position.x, @position.y, @mass, @mass

    bounceOffLimits: do ->
      bounce = (dimension, coEf = 1) -> coEf * Math.abs dimension
      (width, height, offset) ->
        if @position.x > width - offset
          @velocity.x = -bounce @velocity.x
        else if @position.x < 0 + offset
          @velocity.x = bounce @velocity.x

        if @position.y > height - offset
          @velocity.y = -bounce @velocity.y
        else if @position.y < 0 + offset
          @velocity.y = bounce @velocity.y

  class Cursor extends PhysicalBody
    constructor: ->
      canvas.addEventListener "mousedown", @mouseDown, false
      canvas.addEventListener "mouseup", @mouseUp, false
      super

    mouseDown: => @mass = cursorMassControl.value

    mouseUp: =>
      squares.forEach (s) =>
        if 75 > Math.distance s.position, @position
          s.applyForce forceTowards s.position, @position, cursorReleaseForceControl.value
      @mass = 0

  main = ->
    clearCanvas canvas, ctx
    cursor.updatePosition cursor

    applyFunctionToUniquePairs applyGravity, squares
    square.update gameTime for square in squares

    gameTime++
    window.requestFrame main, canvas

  constructSquares = (rows, columns, size) ->
    newSquare = (p, i) -> new Square p, size, size, i, color Math.random
    newSquare position, index for position, index in initPositions rows, columns

  initPositions = (rows, columns) ->
    positions = []
    position = (x, y) -> new Vector2 x * canvas.width / columns, y * canvas.height / rows
    for x in [0 .. columns]
      for y in [0 .. rows]
        positions.push position x, y
    positions

  applyFunctionToUniquePairs = (f, set) ->
    i = set.length
    while j = --i
      while j--
        f set[i], set[j]
    return

  applyGravity = (b1, b2) ->
    f = attractionOfGravity b1, b2
    b1.applyForce f
    b2.applyForce new Vector2 -f.x, -f.y

  forceTowards = (from, to, coEf) ->
    coEf or= 1
    d = Math.direction from, to
    r = hypotenuse d.x, d.y
    new Vector2 -d.x/r * coEf, -d.y/r * coEf

  attractionOfGravity = (b1, b2) ->
    d = Math.direction b1.position, b2.position
    r = hypotenuse d.x, d.y

    if r isnt 0 and r > currentDistance.value
      g = gravity currentGravity.value, b1.mass, b2.mass, r
      new Vector2 -d.x / r*g, -d.y / r*g
    else
      do new Vector2

  gravity = (G, m1, m2, r) -> G*m1*m2 / r*r

  hypotenuseLookup = (digits, maxSquare) ->
    sqrtTable = do ->
        pow = Math.pow 10, digits
        sqrts = (Math.sqrt x for x in [0 .. maxSquare * pow] by 1.0 / pow)
        (n) -> sqrts[(n / 100 * pow) | 0] or Math.sqrt n
    (a, b) -> sqrtTable (a*a + b*b)

  resetSquares = (n) -> squares = constructSquares n, n, 5
  hypotenuse = hypotenuseLookup 3, ((Math.pow canvas.width, 2) + (Math.pow canvas.height, 2)) / Math.pow 10, 5
  cursor = new Cursor
  resetSquares 16

# Canvas Controls
  controls         = new CanvasControls
  gravityModifier  = 1000000
  frictionModifier = 10000
  distanceModifier = 1
  gravityLimit     = lower: 0, upper: 100
  frictionLimit    = lower: 0.25, upper: 15
  distanceLimit    = lower: 0.25, upper: 15

  gravityControl = controls.NumberInput(
    "Gravitational Attraction", currentGravity.value * gravityModifier
    "oninput", controls.controlLimit gravityLimit
  )
  gravityControl.onchange = controls.propertyUpdater currentGravity, "value", gravityModifier

  frictionControl = controls.NumberInput(
    "Atmospheric Friction", (Math.floor currentFriction.value * frictionModifier * 100) / 100,
    "oninput", controls.controlLimit frictionLimit
  )
  frictionControl.onchange = controls.propertyUpdater currentFriction, "value", frictionModifier

  distanceControl = controls.NumberInput(
    "Gravity Deadzone Radius", currentDistance.value * distanceModifier,
    "oninput", controls.controlLimit distanceLimit
  )
  distanceControl.onchange = controls.propertyUpdater currentDistance, "value", distanceModifier

  cursorFrictionControl = controls.NumberInput(
    "Cursor Friction Coefficient", 25,
    "oninput", controls.controlLimit (lower: 0, upper: 100)
  )

  cursorMassControl = controls.NumberInput(
    "Cursor Body Mass", 2500,
    "oninput", controls.controlLimit (lower: 0, upper: 10 * 1000)
  )

  cursorReleaseForceControl = controls.NumberInput(
    "Cursor Release Force", 0.75,
    "oninput", controls.controlLimit (lower: -5, upper: 5)
  )

  defaultButton = controls.ButtonInput(
    "Defaults Values", "onclick", (e) ->
      do gravityControl.reset
      do frictionControl.reset
      do distanceControl.reset
      do cursorMassControl.reset
      do cursorMassControl.reset
      do cursorFrictionControl.reset
      do cursorReleaseForceControl.reset
  )

  particleCountControl = controls.NumberInput(
    "Rows of Squares", 16,
    "oninput", controls.controlLimit (lower: 1, upper: 80)
  )

  resetButton = controls.ButtonInput(
    "Reset Squares", "onclick", (e) -> resetSquares particleCountControl.value
  )

  mouseDown = ->
    currentFriction.value = frictionControl.value/frictionModifier * cursorFrictionControl.value
    currentGravity.value = gravityControl.value/gravityModifier

  mouseUp = ->
    currentFriction.value = frictionControl.value/frictionModifier
    currentGravity.value = gravityControl.value/gravityModifier

  canvas.addEventListener "mousemove", cursorUpdater cursor.position, canvas, false
  canvas.addEventListener "mousedown", mouseDown, false
  canvas.addEventListener "mouseup", mouseUp, false

  do main

window.onload = ->
  canvas = document.getElementById "canvas"
  canvas.width = 800
  canvas.height = 480

  if canvas.getContext
    Gravity canvas
