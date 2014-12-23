require 'sanitize'

module Jekyll
  module SanitizeFilter
    def sanitize(html, preserve_elements = nil)
      if preserve_elements
        preserve_elements = preserve_elements.split
      else
        # Default, sane elements
        preserve_elements = %w[a b strong i em p br h2 h3 h4 h5 h6 pre code]
      end

      Sanitize.fragment(html, :elements => preserve_elements, :remove_contents => true)
    end
  end
end

Liquid::Template.register_filter(Jekyll::SanitizeFilter)
