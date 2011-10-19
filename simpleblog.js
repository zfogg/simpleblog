var app, bogart, couchdb, dbConfig;
bogart = require("bogart");
couchdb = require("couchdb");
dbConfig = {
  user: "zach",
  password: "5984"
};
app = bogart.router(function(get, post, update, destroy) {
  var client, db, viewEngine;
  client = couchdb.createClient(5984, "localhost", dbConfig);
  db = client.db("simpleblog");
  viewEngine = bogart.viewEngine("mustache");
  get('/', function() {
    return bogart.html("Hello, node!");
  });
  get("/posts/new", function(request) {
    return viewEngine.respond("new-post.html", {
      locals: {
        title: 'New Post'
      }
    });
  });
  get("/posts", function(request) {
    return db.view("blog", "posts_by_date").then(function(response) {
      var posts;
      posts = response.rows.map(function(x) {
        return x.value;
      });
      return viewEngine.respond("posts.html", {
        locals: {
          posts: posts,
          title: "simpleblog"
        }
      });
    });
  });
  post("/posts", function(request) {
    post = request.params;
    post.type = "post";
    return db.saveDoc(post).then(function(response) {
      return bogart.redirect("/posts");
    });
  });
  get("/posts/:id", function(request) {
    return db.openDoc(request.params.id).then(function(post) {
      return viewEngine.respond("posts.html", {
        locals: post
      });
    });
  });
  return post("/posts/:id/comments", function(request) {
    var comment;
    comment = req.params;
    return db.openDoc(comment.id).then(function(post) {
      post.comments = post.comments || [];
      post.comments.push(comment);
      return db.saveDoc(post).then(function(response) {
        return bogart.redirect("/posts/" + comment.id);
      });
    });
  });
});
app = bogart.middleware.ParseForm(app);
bogart.start(app);