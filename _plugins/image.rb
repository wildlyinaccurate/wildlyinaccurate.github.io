require 'rmagick'

module Jekyll
  class RenderImageTag < Liquid::Tag

    DEFAULT_QUALITY = 85

    def initialize(tag_name, markup, tokens)
      super

      @attributes = {}
      @markup = markup

      @markup.scan(::Liquid::TagAttributes) do |key, value|
        # Strip quotes from around attribute values
        @attributes[key] = value.gsub(/^['"]|['"]$/, '')
      end

      @attributes['src'] = @attributes['path']
    end

    def resize_image(path, config)
      output_dir = config['output_dir']

      unless Dir.exists?(output_dir)
        Jekyll.logger.info "Creating output directory #{output_dir}"
        Dir.mkdir(output_dir)
      end

      resized = []
      img = Magick::Image::read(path).first

      config['sizes'].each do |size|
        width = size['width']
        ratio = width.to_f / img.columns.to_f
        height = (img.rows.to_f * ratio).round

        filename = File.basename(path).sub(/\.([^.]+)$/, "-#{width}x#{height}.\\1")
        newpath = "#{output_dir}/#{@prefix}#{filename}"

        next unless needs_resizing?(img, width)

        resized.push image_hash(width, height, newpath)

        next if File.exists?(newpath)

        Jekyll.logger.info "Generating #{newpath}"

        i = img.scale(ratio)

        i.write(newpath) do |f|
          f.quality = size['quality'] || DEFAULT_QUALITY
        end

        i.destroy!
      end

      resized
    end

    def image_hash(width, height, path)
      {
        'width'  => width,
        'height' => height,
        'path'   => path,
      }
    end

    def needs_resizing?(img, width)
      img.columns > width
    end

    def render(context)
      config = context.registers[:site].config['responsive_images']
      config['output_dir'] ||= 'assets/resized'
      config['sizes'] ||= []

      @attributes['resized'] = resize_image(@attributes['path'], config)

      partial = File.read('_includes/thumbnail.html')
      template = Liquid::Template.parse(partial)

      template.render!(@attributes)
    end
  end
end

Liquid::Template.register_tag('image', Jekyll::RenderImageTag)
