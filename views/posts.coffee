h2 "Posts"
a href: "/posts/new", -> "New Post"

ul ->
    for post in @posts
        li div "post", ->
            h3 ->a href: "/posts/#{post._id}", -> post.title
            h4 " -> " + post.date
            p post.body
            do hr
