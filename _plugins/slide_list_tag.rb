# スライド一覧を取得するタグ

module Jekyll
  class SlideListTag < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      context.registers[:loop_directory] ||= Hash.new(0)

      slides = Dir.glob("_slide/**/*.md").map do |path|
        path.match(/^_slide\/(.*)\.md$/)[1]
      end

      slides.sort!

      length = slides.length
      result = []

      context.stack do
        slides.each_with_index do |item, index|
          context['slide'] = item
          context['forloop'] =
          {
              'name' => 'slide',
              'length' => length,
              'index' => index + 1,
              'index0' => index,
              'rindex' => length - index,
              'rindex0' => length - index - 1,
              'first' => (index == 0),
              'last' => (index == length - 1) 
          }

          result << render_all(@nodelist, context)
        end
      end

      result
    end
  end
end

Liquid::Template.register_tag 'slide_list', Jekyll::SlideListTag
