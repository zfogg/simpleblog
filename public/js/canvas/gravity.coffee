Gravity = (canvas) ->
    ctx      = canvas.getContext  "2d"
    gameTime = 0
    squares  = []

    defaultGravity        = 6.67 * Math.pow 10, -6
    defaultFriction       = 1.15 * Math.pow 10, -4
    defaultDistance       = 3
    defaultCursorFriction = 25
    defaultCursorMass     = 2500
    defaultCursorForce    = 0.75


    currentFriction = value: defaultFriction

    class PhysicalBody
        constructor: (@position = new Vector2, @mass = 1, @size = 1, @restitution = 1, @velocity = new Vector2) ->

        updatePosition: ->
            @position.x += @velocity.x
            @position.y += @velocity.y
        applyForce: (acceleration) ->
            @velocity.x += 0.5 * acceleration.x * @mass
            @velocity.y += 0.5 * acceleration.y * @mass

    class Square extends PhysicalBody
        constructor: (@position, @mass, @size, @index, @color) ->
            super @position, @mass, @size, 0.85

        update: (gameTime) ->
            applyGravity @, cursor
            if not cursor.isClicked.right and not cursor.isClicked.left
                @bounceOffLimits canvas.width, canvas.height, @mass*2
            do @updatePosition
            @decayVelocity frictionCVals.current
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
            @position        = new Vector2
            @trackedPosition = new Vector2
            @canvasCenter    = -> new Vector2 canvas.width / 2, canvas.height / 2

            ($ canvas).mousedown (e) => @toggleClicks e, true
            ($ canvas).mousedown @mouseDown
            ($ "body").mouseup   (e) => @toggleClicks e, false
            ($ "body").mouseup   @mouseUp
            ($ canvas).mousemove (cursorUpdater @trackedPosition, canvas)

            super

        isClicked:
            left:   false
            middle: false
            right:  false

        toggleClicks: (e, value) =>
            switch e.which
                when 1 then @isClicked.left   = value
                when 2 then @isClicked.middle = value
                when 3 then @isClicked.right  = value
            true

        mouseDown: =>
            if @isClicked.left
                @mass = cursorMassCVals.getFromControl cursorMassControl
                frictionCVals.current = frictionControl.value / frictionCVals.modifier * cursorFrictionControl.value

            else if @isClicked.right
                @mass = 0.25 * cursorMassCVals.getFromControl cursorMassControl
                frictionCVals.current = 0.2 * (frictionControl.value / frictionCVals.modifier * cursorFrictionControl.value)
            true

        mouseUp: =>
            unless @isClicked.left
                squares.forEach (s) =>
                    if 75 > Math.distance s.position, @position
                        s.applyForce forceTowards s.position, @position, cursorForceCVals.getFromControl cursorForceControl
                @mass = 0
                frictionCVals.setWithControl frictionControl
                gravityCVals.setWithControl gravityControl
            true

        rightHeldDown: =>
            @position = do @canvasCenter
            @position.x += (Math.sin gameTime / 14) * 124
            @position.y += (Math.cos gameTime / 14) * 124

        updatePosition: ->
            @position.x = @trackedPosition.x
            @position.y = @trackedPosition.y

        update: ->
            if @isClicked.right
                do @rightHeldDown
                do @draw
            else do @updatePosition

        draw: ->
            do ctx.beginPath
            ctx.arc @position.x, @position.y, 10, 0, Math.PI*2, true
            do ctx.closePath
            do ctx.fill

    applyGravity = do ->
        attractionOfGravity = (b1, b2) ->
            d = Math.direction b1.position, b2.position
            r = hypotenuse d.x, d.y

            if r isnt 0 and r > distanceCVals.current
                g = gravity gravityCVals.current, b1.mass, b2.mass, r
                new Vector2 -d.x / r*g, -d.y / r*g
            else do new Vector2

        gravity = (G, m1, m2, r) -> G*m1*m2 / r*r
        negateVector2 = (v) -> new Vector2 -v.x, -v.y
        (body1, body2) ->
            f = attractionOfGravity body1, body2
            body1.applyForce f
            body2.applyForce negateVector2 f

    forceTowards = (from, to, coEf = 1) ->
        d = Math.direction from, to
        r = hypotenuse d.x, d.y
        new Vector2 -d.x/r * coEf, -d.y/r * coEf

    mapOverUniquePairs = (f, set) ->
        i = set.length
        while j = --i
            while j--
                f set[i], set[j]
        return

    hypotenuseLookup = (digits, minSquare = 0, maxSquare) ->
        sqrtTable = do ->
            pow   = Math.pow 10, digits
            sqrts = (Math.sqrt x for x in [minSquare .. maxSquare * pow] by 1.0 / pow)
            (n) -> sqrts[(n / 100 * pow) | 0] or Math.sqrt n
        (a, b) -> sqrtTable (a*a + b*b)

    # Returns a square of squares the size of the argument.
    resetSquares = do ->
        constructSquares = do ->
            initPositions = (rows, columns) ->
                position = (x, y) ->
                    new Vector2 x * canvas.width / columns, y * canvas.height / rows
                position (n / columns) | 0, n % rows for n in [0...rows*columns]

            newSquare = (p, i, size) ->
                new Square p, size, size, i, color Math.random

            (rows, columns, size) ->
                newSquare position, index, size for position, index in initPositions rows, columns

        (size) ->
            cursor.isClicked.left = true
            setTimeout (-> cursor.isClicked.left = false), 7000
            squares = constructSquares size, size, (Math.randomBetween 3, 6)

# Canvas Controls
    controls     = new CanvasControls
    controlLimit = lower: 10, upper: 100

    controlValueObj = (value) -> (
            default: value
            current: value
            modifier: toCommonRange value, controlLimit
            setWithControl: (control) -> @current = control.value / @modifier
            getFromControl: (control) -> control.value / @modifier
        )
    toCommonRange = (n, range, coefficient = 1) ->
        if n < range.lower
            toCommonRange n * 10, range, coefficient * 10
        else if n > range.upper
            toCommonRange n / 10, range, coefficient / 10
        else coefficient

    rangeInput = (name, cValObj) ->
        control = controls.RangeInput(
            name, cValObj.default * cValObj.modifier,
            controlLimit.lower, controlLimit.upper, 1
        )
        ($ control).blur controls.propertyUpdater cValObj, "current", cValObj.modifier
        ($ control).blur controls.controlLimit controlLimit
        control

    gravityCVals        = controlValueObj defaultGravity
    frictionCVals       = controlValueObj defaultFriction
    distanceCVals       = controlValueObj defaultDistance
    cursorFrictionCVals = controlValueObj defaultCursorFriction
    cursorMassCVals     = controlValueObj defaultCursorMass
    cursorForceCVals    = controlValueObj defaultCursorForce

    gravityControl        = rangeInput "Gravitational Attraction",    gravityCVals
    frictionControl       = rangeInput "Atmospheric Friction",        frictionCVals
    distanceControl       = rangeInput "Gravity Deadzone Radius",     distanceCVals
    cursorFrictionControl = rangeInput "Cursor Friction Coefficient", cursorFrictionCVals
    cursorMassControl     = rangeInput "Cursor Body Mass",            cursorMassCVals
    cursorForceControl    = rangeInput "Cursor Release Force",        cursorForceCVals


    defaultButton = controls.ButtonInput "Defaults Values"
    ($ defaultButton).click -> controls.resets.forEach (x) -> do x

    particleCountControl = controls.NumberInput "Rows of Squares", 16
    ($ particleCountControl).blur controls.controlLimit (lower: 1, upper: 30)

    resetButton = controls.ButtonInput("Reset Squares")
    ($ resetButton).click (e) -> resetSquares particleCountControl.value

    main = ->
        clearCanvas canvas, ctx
        do cursor.update

        mapOverUniquePairs applyGravity, squares
        square.update gameTime for square in squares

        gameTime++
        window.requestFrame main, canvas

# Init.
    hypotenuse = hypotenuseLookup 3, 0, ((Math.pow canvas.width, 2) + (Math.pow canvas.height, 2)) / Math.pow 10, 5
    cursor = new Cursor
    resetSquares 16
    do main

window.onload = ->
    canvas        = document.getElementById "canvas"
    canvas.width  = 800
    canvas.height = 480

    if canvas.getContext
        Gravity canvas
