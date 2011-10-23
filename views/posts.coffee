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
        if @pageNumber is 2
            a href: "/posts", "Previous Page"
        else
            a href: "/posts/page/" + (@pageNumber - 1), "Previous Page"
        text " <"
    text "|"
    if @posts.length >= 5
        text "> "
        a href: "/posts/page/" + ((@pageNumber or 1) + 1), "Next Page"
