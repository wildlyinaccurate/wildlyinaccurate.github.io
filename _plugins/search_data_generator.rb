require 'json'

module Jekyll

  # Generates JSON data to be used by a client-side search form
  class SearchDataGenerator < Generator
    safe true

    def generate(site)
      post_json = lambda do |post|
        {
          title:      post.data['title'],
          tags:       post.data['tags'],
          categories: post.data['categories'],
          url:        post.url,
        }
      end

      posts = site.posts.map(&post_json)
      tags = site.tags.keys
      categories = site.categories.keys

      File.write('search.json', {
        posts: posts,
        tags: tags,
        categories: categories,
      }.to_json)
    end
  end

end
