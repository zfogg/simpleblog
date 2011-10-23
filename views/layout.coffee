doctype 5
html ->
    head ->
        title "#{@title or 'Untitled'} | An awesome weblog."

        link rel: "stylesheet", href: "/public/css/styles.css"
        style """
            .post h3, .post h4 {
                display: inline-block;
            }
        """

body ->
    header ->
    div id: "content"
            @body
