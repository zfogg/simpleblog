header ->
    h2 "simpleblog"

div "#main", ->
    h3 -> a href: "/posts/new", -> "New Post"
    for post in @posts
        div "post", ->
            hgroup ->
                h2 -> a href: "/posts/#{post._id}", -> post.title
                h4 post.date
            div "content", -> post.body

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
