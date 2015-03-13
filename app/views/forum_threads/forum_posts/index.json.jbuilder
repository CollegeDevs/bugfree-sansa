json.array!(@forum_posts) do |forum_post|
  json.extract! forum_post, :id, :body
  json.url forum_post_url(forum_post, format: :json)
end
