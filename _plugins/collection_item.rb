module Jekyll
  class CollectionItem < Liquid::Block
    def render(context)
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      attributes = YAML.load(super)
      attributes['description'] = converter.convert(attributes['description'])

      partial = File.read('_includes/collection-item.html')
      template = Liquid::Template.parse(partial)

      template.render!(attributes)
    end
  end
end

Liquid::Template.register_tag('collection_item', Jekyll::CollectionItem)
