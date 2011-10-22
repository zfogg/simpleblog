module.exports.simpleauth = (db, user, password, callback) ->
    db.get "simpleblog/users/"+login, (err, doc) ->
        if doc and not err and doc.password is password
            callback doc
        else
            callback null
        console.log err or doc
