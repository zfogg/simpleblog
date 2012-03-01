# Dependencies: canvas-tools

class CanvasControls
  constructor: ->
    @controls = ($ "#canvas-controls")

  inputElement: (type, defaultValue) ->
    input = document.createElement "input"
    input.type = type
    input.value = defaultValue
    @controls.append input
    input

  pElement: (text) ->
    p = document.createElement 'p'
    p.innerHTML = text
    @controls.append p
    p

  NumberInput: (name, defaultValue) ->
    @pElement name
    numberInput = @inputElement "number", defaultValue
    @resets.push -> numberInput.value = defaultValue
    numberInput

  RangeInput: (name, defaultValue, min = 1, max = 100, step = 10) ->
    @pElement name
    rangeInput = @inputElement "range", defaultValue

    rangeInput.min  = min
    rangeInput.max  = max
    rangeInput.step = step

    @resets.push -> rangeInput.value = defaultValue
    rangeInput

  ButtonInput: (name) ->
    button = @inputElement "button", name
    button

  controlLimit: (limit) ->
    -> @value = Math.clipValues @value, limit.lower, limit.upper

  propertyUpdater: (obj, objProperty, modifier = 1) ->
    -> obj[objProperty] = @value / modifier

  controlValueObj: (value, limitRange) ->
    default:        value
    current:        value
    modifier:       Math.commonRangeCoefficient value, limitRange
    setFromControl: -> @.current = @.getFromControl()
    getFromControl: (control = @self) -> control.value / @modifier
    # self: set this to the parent object after creation if you like.

  resets: []

($ document).ready ->
  ($ "#canvas-controls-container").show()
  ($ "#toggle-menu a").click (event) ->
    if event.which is 1
      ($ "#canvas-controls").slideToggle "slow"
      if (($ "#toggle-menu a").text().indexOf "Show") is -1
        ($ "#toggle-menu a").text "Show"
    else
      ($ "#toggle-menu a").text "Hide"
