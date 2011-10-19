couchdb = require "couchdb"
client  = couchdb.createClient 5984, "localhost", (user: "zach", password: "5984")
db      = client.db "simpleblog"

designDoc =
    _id: "_design/blog"

    views: "posts_by_date":
        map: ''+(document) -> emit document.postedAt, document if document.type is "post"

db.saveDoc(designDoc).then ((response) ->
    console.log "Updated design doc!"
    ), (error) -> console.log "Error updating design doc:\n"+require("util").inspect error
