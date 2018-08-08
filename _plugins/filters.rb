require 'sanitize'

module Jekyll
  module SanitizeFilter
    def sanitize(html)
      preserve_elements = %w[
        a
        blockquote
        b strong i em small
        p br
        h2 h3 h4 h5 h6
        pre code
        span div
        ul ol li
      ]

      # Remove any Kramdown table of contents
      toc_remover = lambda do |env|
        return unless env[:node_name] == 'ul'

        node = env[:node]

        if node['id'] == 'markdown-toc'
          node.unlink
        end
      end

      # Remove spans but keep their content
      span_transformer = lambda do |env|
        return unless env[:node_name] == 'span'

        env[:node].replace(env[:node].content)
      end

      caption_remover = lambda do |env|
        node = env[:node]
        className = node['class']

        if className && className.split.include?('caption') then
          node.unlink
        end
      end

      Sanitize.fragment(html,
        :remove_contents => true,
        :elements        => preserve_elements,
        :transformers    => [toc_remover, span_transformer, caption_remover],
        :attributes      => {
          'a' => ['href'],
        }
      )
    end
  end
end

Liquid::Template.register_filter(Jekyll::SanitizeFilter)
