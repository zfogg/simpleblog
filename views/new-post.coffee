header -> h1 "New Post"

div "#main", -> 
    h3 style: "margin-top:-50px; margin-bottom:50px;", ->
        a href: "/posts", "Home"
    div "post", ->
        form id: "new-post", method: "post", action: "/posts", ->
            fieldset ->
                div "#title", ->
                    label for: "title", -> "Title"
                    do br
                    input name: "title"

                div "#body", ->
                    label for: "body", -> "Body"
                    do br
                    textarea name: "body", rows: "25"

                div "button", ->
                    input type: "submit", value: "Save Post"
