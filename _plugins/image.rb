module Jekyll
  class RenderImageTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      @attributes = {}
      @markup = markup

      @markup.scan(::Liquid::TagAttributes) do |key, value|
        # Strip quotes from around attribute values
        @attributes[key] = value.gsub(/^['"]|['"]$/, '')
      end
    end

    def render(context)
      partial = File.read('_includes/thumbnail.html')
      template = Liquid::Template.parse(partial)

      template.render!(@attributes)
    end
  end
end

Liquid::Template.register_tag('image', Jekyll::RenderImageTag)
