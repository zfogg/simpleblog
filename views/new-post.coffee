form method: "post", action: "/posts", ->
    fieldset ->
        legend "New Post"

        div ->
            label for: "title", -> "Title"
            input name: "title"

        div ->
            label for: "body", -> "Body"
            textarea name: "body", rows: "15", columns: "25"

        div "buttons", ->
            input type: "submit", value: "Save Post"
