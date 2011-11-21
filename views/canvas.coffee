header -> h1 @title

div "#canvas-container", ->
    link rel: "stylesheet", href: "/css/canvas.css"
    canvas id: "canvas", oncontextmenu: "return false;"

    div "#canvas-controls-container", ->
        div id: "canvas-controls", -> h3 "Canvas Controls"
        h3 id: "toggle-menu", ->
            a "Show"
            text " controls."

    script src: "/js/canvas/canvas-tools.js"
    script src: "/js/canvas/canvas-controls.js"
    script src: "/js/canvas/#{@title}.js"
