doctype 5
html ->
    head ->
        meta charset: "utf-8"
        meta "http-equiv": "X-UA-Compatible", content: "IE=edge,chrome=1"

        title "#{@title or 'Untitled'} | An awesome weblog."
        meta name: "description", content: ""
        meta name: "author", content: ""

        meta name: "viewport", content: "width=device-width,initial-scale=1"

        link rel: "stylesheet", href: "/css/normalize.css"
        link rel: "stylesheet", href: "/css/style.css"
        link rel: "stylesheet", href: "http://fonts.googleapis.com/css?family=Droid+Sans:400,700,700italic,400italic"
        link rel: "stylesheet", href: "http://fonts.googleapis.com/css?family=Ubuntu:500"

        # SyntaxHighlighter
        link rel: "stylesheet", href: "/css/shCore.css"
        link rel: "stylesheet", href: "/css/shCoreDefault.css"
        script src: "/js/libs/xregexp.js"
        script src: "/js/libs/shCore.js"
        script src: "/js/libs/shBrushes/shBrushCoffeeScript.js"
        script src: "/js/libs/shBrushes/shBrushJScript.js"
        script src: "/js/libs/shBrushes/shBrushCSharp.js"
        script -> "SyntaxHighlighter.all()"

        script src: "/js/libs/modernizr-2.0.6.min.js"
        script src: "//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
        coffeescript -> window.jQuery or document.write '<script src="/media/js/libs/jquery-1.6.2.min.js"><\/script>'

    body ->
        div "#container", ->
            @body
