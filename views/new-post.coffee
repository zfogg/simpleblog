header -> h1 "New Post"

div "#header-links", ->
    h3 -> a href: "/", "Home"

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
