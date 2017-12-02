require 'jekyll'

module Jekyll
  module Googleads
    class GoogleadsTag < Liquid::Tag
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

        %Q{<div align="center" class="googleads #{@attributes['class_name']}">
                <ins class="adsbygoogle"
                    style="display:block"
                    data-ad-client="#{context.registers[:site].config['google_ad_client']}"
                    data-ad-slot="#{context.registers[:site].config[@attributes['ads_id']]}"
                    data-ad-format="auto"></ins>
                <script>(adsbygoogle = window.adsbygoogle || []).push({});</script>
            </div>}
      end
    end
  end
end

Liquid::Template.register_tag('googleads', Jekyll::Googleads::GoogleadsTag)
