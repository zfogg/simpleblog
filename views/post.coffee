header -> h1 "simpleblog"

div "#header-links", ->
    h3 ->
        a href: "/", "Home"
        a href: "/posts/new", "New Post"

div "post", ->
    hgroup ->
        h2 @title
        h4 @date
    div "content", -> @body

    do hr
    form id: "comment-form", method: "post", style: "display:none;", action: "/posts/#{@_id}/comment", ->
        fieldset ->

            div ->
                label for: "author", -> "Your name:"
                do br
                input name: "author"

            div ->
                label for: "body", -> "Your comment:"
                textarea name: "body", rows: 10

            div "button", ->
                input type: "submit", value: "Post Comment"

    h4 "#toggle-form", ->
        text "Something to say? "
        a "Click here."
        script -> """
            $("#toggle-form").click(function() {
                $("#toggle-form").fadeOut(450);
                $("#comment-form").toggle("slow");
            });
        """

    if @comments
        div "#comments", ->
            do hr
            h3 "Comments"
            for comment in @comments
                div "comment", ->
                    span "author", -> h4 comment.author
                    div "body", -> comment.body
