module Jekyll
  class CollectionItem < Liquid::Block
    def render(context)
      site = context.registers[:site]
      # Note: getConverterImpl should be find_converter_instance after upgrading to 3.0
      converter = site.getConverterImpl(Jekyll::Converters::Markdown)

      attributes = YAML.load(super)
      attributes['description'] = converter.convert(attributes['description'])

      partial = File.read('_includes/collection-item.html')
      template = Liquid::Template.parse(partial)

      template.render!(attributes)
    end
  end
end

Liquid::Template.register_tag('collection_item', Jekyll::CollectionItem)
