class CanvasControls
    constructor: ->
        @controls = document.getElementById "canvas-controls"

    inputElement: (type, defaultValue) ->
        input = document.createElement "input"
        input.type = type
        input.value = defaultValue
        @controls.appendChild input
        input

    pElement: (text) ->
        p = document.createElement 'p'
        p.innerHTML = text
        @controls.appendChild p
        p

    NumberInput: (name, defaultValue, eventType, event) ->
        @pElement name
        numberInput = @inputElement "number", defaultValue
        numberInput[eventType] = event if event

        @resets.push ->
            numberInput.value = defaultValue
            numberInput.onchange() if numberInput.onchange

        numberInput

    ButtonInput: (name, eventType, event) ->
        button = @inputElement "button", name
        button[eventType] = event if event

        button

    controlLimit: (limit) ->
        -> @value = Math.clipValues @value, limit.lower, limit.upper

    propertyUpdater: (obj, objProperty, modifier) ->
        -> obj[objProperty] = @value / (modifier or 1)


    resets: []

($ document).ready ->
    ($ "#canvas-controls-container").show()
    toggleText = (text, first, second) -> if text.indexOf first then first else second
    ($ "#toggle-menu a").mousedown (event) ->
        if event.which is 1
            ($ "#canvas-controls").slideToggle "slow"
            ($ "#togle-menu a").text(
                toggleText ($ "#toggle-menu a").text(), "Hide", "Show"
            )
