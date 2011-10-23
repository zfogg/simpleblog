a href: "/posts", -> "Home"
h1 @title

div "post-content", -> @body
do br

if @comments
    div -> h2 "Comments"
    for comment in @comments
        ul id: "comments", ->
            li ->
                div "comment-head", -> span "author", -> comment.author
                div "comment", -> comment.body

form method: "post", action: "/posts/#{@_id}/comment", ->
    fieldset ->
        legend "Something to say?"

        div ->
            label for: "author", -> "Your name:"
            input name: "author"

        div ->
            label for: "body", -> "Your comment:"
            input name: "body"

        div "button", ->
            input type: "submit", value: "Post Comment"
