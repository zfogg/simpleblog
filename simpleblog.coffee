bogart = require "bogart"
couchdb = require "couchdb"
dbConfig =
    user: "zach"
    pass: "5984"

app = bogart.router (get, post, update, destroy) ->
    client     = couchdb.createClient 8080, "127.0.0.1", dbConfig
    db         = client.db "blog"
    viewEngine = bogart.viewEngine "mustache"

    get '/', () ->
        bogart.html "Hello, node!"

    get "/posts/new", (request) ->
        title = locals: title: 'New Post'
        viewEngine.respond "new-post.html", title

    post "/posts", (request) ->
        pos = request.params
        post.type = "post"

        db.saveDoc.then (response) ->
            bogart.redirect "/posts"

app = bogart.middleware.ParseForm app
bogart.start app
