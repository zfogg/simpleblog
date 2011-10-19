var app, bogart, couchdb, dbConfig;
bogart = require("bogart");
couchdb = require("couchdb");
dbConfig = {
  user: "zach",
  pass: "5984"
};
app = bogart.router(function(get, post, update, destroy) {
  var client, db, viewEngine;
  client = couchdb.createClient(8080, "127.0.0.1", dbConfig);
  db = client.db("blog");
  viewEngine = bogart.viewEngine("mustache");
  get('/', function() {
    return bogart.html("Hello, node!");
  });
  get("/posts/new", function(request) {
    var title;
    title = {
      locals: {
        title: 'New Post'
      }
    };
    return viewEngine.respond("new-post.html", title);
  });
  return post("/posts", function(request) {
    var pos;
    pos = request.params;
    post.type = "post";
    return db.saveDoc.then(function(response) {
      return bogart.redirect("/posts");
    });
  });
});
app = bogart.middleware.ParseForm(app);
bogart.start(app);