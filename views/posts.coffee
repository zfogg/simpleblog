header ->
    h1 @title

div "#header-links", ->
    h3 ->
        a href: "/", "Home"
        a href: "/posts/new", "New Post"

for post in @posts
    div "post", ->
        hgroup ->
            h4 post.date
            h2 -> a href: "/posts/#{post._id}", -> post.title
            h3 ->
                if post.comments
                    "#{post.comments.length} comment" + ( # Pluralize if necessary.
                        if post.comments.length > 1 then "s" else ""
                    )
                else "no comments"
        div "content", -> post.body

div "pagenav", style: "text-align: center;", ->
    h3 ->
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
