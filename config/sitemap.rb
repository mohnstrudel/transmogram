# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://transmogram.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  add '/about'
  add '/contact'
  add '/help'

  add posts_path, priority: 0.9, changefreq: 'daily'

  Post.find_each(batch_size: 500) do |post|
    add post_path(post), lastmod: post.updated_at
  end

  User.find_each(batch_size: 500) do |user|
    add user_path(user), lastmod: user.updated_at
  end
end
