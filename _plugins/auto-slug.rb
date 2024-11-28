Jekyll::Hooks.register :site, :post_read do |site|
  site.posts.docs.each do |post|
      # 제목을 기반으로 슬러그 생성
      slug = post.data['title']
      post.data['slug'] = slug
  end
end