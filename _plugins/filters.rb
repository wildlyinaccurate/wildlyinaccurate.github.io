require 'sanitize'

module Jekyll
  module SanitizeFilter
    def sanitize(html, preserve_elements = nil)
      if preserve_elements
        preserve_elements = preserve_elements.split
      else
        # Default, sane elements
        preserve_elements = %w[b strong i em p br pre code]
      end

      Sanitize.fragment(html, :elements => preserve_elements)
    end
  end
end

Liquid::Template.register_filter(Jekyll::SanitizeFilter)
