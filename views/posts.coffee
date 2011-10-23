h2 "Posts"
a href: "/posts/new", -> "New Post"

ul ->
    for post in @posts
        li ->
            div "post", ->
                h3 -> a href: "/posts/#{post._id}", -> post.title
                h4 " -> " + post.date
                p post.body
                do hr

div "pagenav", style: "text-align: center;", ->
    if @pageNumber > 1 and @posts.length
        a href: "/posts/page/" + (@pageNumber - 1).toString(), "<-- Previous Page"
        text "  |  "
    if @posts.length >= 5
        a href: "/posts/page/" + (@pageNumber + 1).toString(), "Next Page -->"
