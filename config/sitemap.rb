# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.villeme.com"

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

  City.where(launch: true) do |city|
    add "/pt-BR/#{city.slug}"
    add "/#{city.slug}"
  end

  Event.find_each do |event|
    add "/events/#{event.slug}", lastmod: event.updated_at
  end

  Activity.find_each do |activity|
    add "/activities/#{activity.slug}", lastmod: activity.updated_at
  end

end
