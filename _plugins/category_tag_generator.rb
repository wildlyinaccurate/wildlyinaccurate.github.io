module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      tag_title_prefix = site.config['tag_title_prefix'] || 'Tag: '

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag
      self.data['title'] = "#{tag_title_prefix}#{tag}"
    end
  end

  class CategoryTagPageGenerator < Generator
    safe true

    def generate(site)
      tag_dir = site.config['tag_dir'] || 'tags'
      category_dir = site.config['category_dir'] || 'categories'

      site.categories.each_key do |category|
        site.pages << CategoryPage.new(site, site.source, File.join(category_dir, category), category)
      end

      site.tags.each_key do |tag|
        site.pages << TagPage.new(site, site.source, File.join(tag_dir, tag), tag)
      end
    end
  end

end
