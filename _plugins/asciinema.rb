require 'jekyll'

module Jekyll
  module Asciinema
    class AsciinemaTag < Liquid::Tag
      def initialize(tag_name, markup, token)
        super
        
        @attributes = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def render(context)
        ret = %Q{<asciinema-player src="#{context.registers[:site].config['url']}/assets/#{@attributes['path']}" poster="npt:0:15" speed="2" theme="snazzy"></asciinema-player>}

        if @attributes['title']
          ret += %Q{<figcaption>#{@attributes['title']}</figcaption>}
        end

        %Q{<div class="asciinema-player-section">#{ret}</div>}
      end
    end
  end
end

Liquid::Template.register_tag('asciinema', Jekyll::Asciinema::AsciinemaTag)
