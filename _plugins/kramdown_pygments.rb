require 'kramdown'
require 'pygments'

module Kramdown
  module Converter
    class PygmentsHtml < Html
      def convert_codeblock(el, indent)
        attr = el.attr.dup
        lang = extract_code_language!(attr) || @options[:kramdown_default_lang]
        code = pygmentize(el.value, lang)
        code_attr = {}
        code_attr['class'] = "language-#{lang}" if lang
        "#{' '*indent}<div class=\"highlight\"><pre#{html_attributes(attr)}><code#{html_attributes(code_attr)}>#{code}</code></pre></div>\n"
      end

      def convert_codespan(el, indent)
        attr = el.attr.dup
        lang = extract_code_language!(attr) || @options[:kramdown_default_lang]
        code = pygmentize(el.value, lang)

        if lang
          attr['class'] = "highlight language-#{lang}"
        end

        "<code#{html_attributes(attr)}>#{code}</code>"
      end

      def pygmentize(code, lang)
        if lang
          Pygments.highlight(
            code,
            :lexer => lang,
            :options => { :startinline => true, :encoding => 'utf-8', :nowrap => true }
          )
        else
          escape_html(code)
        end
      end
    end
  end
end

class Jekyll::Converters::Markdown::KramdownPygments
  def initialize(config)
    @config = config
  end

  def convert(content)
    Kramdown::Document.new(content, {
      :auto_ids              => @config['kramdown']['auto_ids'],
      :footnote_nr           => @config['kramdown']['footnote_nr'],
      :entity_output         => @config['kramdown']['entity_output'],
      :toc_levels            => @config['kramdown']['toc_levels'],
      :smart_quotes          => @config['kramdown']['smart_quotes'],
      :kramdown_default_lang => @config['kramdown']['default_lang'],
      :input                 => @config['kramdown']['input']
    }).to_pygments_html
  end
end
