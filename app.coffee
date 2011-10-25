###
# Dependencies
###
require.paths.push "./lib"

require "date-utils"
express  = require "express"
couchdb  = require "couchdb"
_        = require "underscore"
markdown = require "github-flavored-markdown"

###
# Config
###
app = express.createServer()
app.register '.coffee', require('coffeekup').adapters.express

app.configure ->
    app.set 'views', __dirname + '/views'
    app.set 'view engine', "coffee"
    app.set 'view options', format: true
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.static __dirname + "/public"
    app.use express.favicon()

app.configure "development", ->
    app.use express.errorHandler (dumbExceptions: true, showStack: true)
    app.use express.logger (format: ":method :referrer --> :url")

app.configure "production", -> app.use express.errorHandler()

client = couchdb.createClient 5984, "localhost", (user: "simpleblog", password: "5984")
db     = client.db "simpleblog"

POST_LIMIT    = 5

###
# Routes
###
app.get '/', (req, res) -> res.redirect "/posts"

app.get "/posts/new", (req, res) -> res.render "new-post", (title: 'New Post')

app.get "/posts", (req, res) ->
    (db.view "blog", "posts_by_date").then (results) ->
        res.render "posts", (
            title: "simpleblog",
            posts: (postToHTML results.rows)
        )

app.get "/posts/page/:pageNumber", (req, res) ->
    for x in req.params.pageNumber.split ""
        res.redirect "/posts" if isNaN x

    pageNumber = parseInt req.params.pageNumber, 10
    (db.view "blog", "posts_by_date").then (results) ->
        posts = (_ results.rows).initial POST_LIMIT * (pageNumber - 1)
        res.render "posts", (
            title: "Page #{pageNumber}|simpleblog",
            posts: (postToHTML posts),
            pageNumber: pageNumber
        )

app.get "/posts/:id", (req, res) ->
    (db.openDoc req.params.id).then (post) ->
        res.render "post", postToHTML post

app.post "/posts", (req, res) ->
    post = req.body

    post.type = "post"
    if validPost post
        db.saveDoc timeStamped post, DATE_FORMAT_DB
        res.redirect "/posts"
    else
        res.redirect "/posts/new"

app.post "/posts/:id/comment", (req, res) ->
    comment = req.body
    id = req.params.id
    (db.openDoc id).then (post) ->
        post.comments = post.comments or []
        if validComment comment
            post.comments.push timeStamped comment, DATE_FORMAT_DB

        (db.saveDoc post).then () ->
            res.redirect "/posts/"+id

###
# Helper Functions
####
postToHTML = (posts) ->
    if (_ posts).isArray()
        if posts.length > POST_LIMIT
            posts = (_ posts).last POST_LIMIT
        (_ posts).reverse()
        (_ posts).map (post) ->
            post.value.body = markdown.parse post.value.body
            timeStamped post.value, DATE_FORMAT_HTML
    else
        posts.body = markdown.parse posts.body
        timeStamped posts, DATE_FORMAT_HTML

validPost    = (post)    -> post.title and post.body
validComment = (comment) -> comment.author and comment.body

timeStamped = (o = {}, toFormat = (d) -> d) ->
    o.date = toFormat new Date o.date or new Date
    o
DATE_FORMAT_DB  = (d) -> d.toFormat "MM-DD-YYYY HH24:MI:SS"
DATE_FORMAT_HTML = (d) -> d.getMonthName() + d.toFormat " DD, YYYY - HH24:MI"

# Start app.
app.listen 8080
