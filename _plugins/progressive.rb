require 'jekyll'

module Jekyll
  module Progressive
    class ProgressiveTag < Liquid::Tag
      def initialize(tag_name, markup, token)
        super
        
        @attributes = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def render(context)
        original_url = "#{context.registers[:site].config['url']}#{@attributes['path']}"
        thumb_url = original_url[0...(original_url.rindex('.'))] + "_thumb.jpg"

        absolute_root_path = context.registers[:site].config['absolute_root_path']
        original_path = "#{absolute_root_path}#{@attributes['path']}"
        thumb_path = original_path[0...(original_path.rindex('.'))] + "_thumb.jpg"
        w,h = `identify -format "%wx%h" "#{original_path}"`.split('x').map { |s| s.to_f }

        title = @attributes['title']

        cmd = "convert \"#{original_path}\" -thumbnail 60 -quality 20 \"#{thumb_path}\""
        `${cmd}`

        %Q{<figure>
                <div class="aspect-ratio-placeholder" style="max-width: 100%; max-height: 666px;">
                    <div class="aspect-ratio-placeholder-fill" style="padding-bottom: #{h/w*100}%;"></div>
                    <div class="progressive-media js-progressive-media" style="background-image: url('#{thumb_url}')"></div>
                    <img class="progressive-media-image js-progressive-media-image" data-src="#{original_url}" alt="#{title}" />
                    <noscript class="js-progressive-media-inner">
                        <img src="#{original_url}" alt="#{title}" />
                    </noscript>
                </div>
            </figure>}
      end
    end
  end
end

Liquid::Template.register_tag('progressive', Jekyll::Progressive::ProgressiveTag)
