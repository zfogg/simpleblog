header ->
    h1 "Identification"

form method: "post", action: "/login", ->
    fieldset ->
        legend "Login"

        div ->
            label for: "username", -> "Username:"
            input name: "username"

        div ->
            label for: "password", -> "Password:"
            input name: "password"
