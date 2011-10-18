bogart = require "bogart"
viewEngine = bogart.viewEngine 'mustache'

app = bogart.router (get, post, update, destroy) ->
    get '/', () ->
        bogart.html "Hello, world!"

    get "/posts/new", (request) ->
        title = locals: title: 'New Post'
        viewEngine.respond "new-post.html", title

bogart.start app
