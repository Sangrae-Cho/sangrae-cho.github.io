Jekyll::Hooks.register :posts, :post_render do |post|
  post.output = post.output.gsub(/<a (?!.*?target="_blank").*?href="(http.*?)"(.*?)>/, '<a href="\1" \2 target="_blank">')
end
