(function() {
  var app, bogart, viewEngine;
  bogart = require("bogart");
  viewEngine = bogart.viewEngine('mustache');
  app = bogart.router(function(get, post, update, destroy) {
    get('/', function() {
      return bogart.html("Hello, world!");
    });
    return get("/posts/new", function(request) {
      var title;
      title = {
        locals: {
          title: 'New Post'
        }
      };
      return viewEngine.respond("new-post.html", title);
    });
  });
  bogart.start(app);
}).call(this);
