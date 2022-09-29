# frozen_string_literal: true

module DraftjsHtml
  module Draftjs
    Block = Struct.new(:key, :text, :type, :inline_style_ranges, keyword_init: true) do
      def self.parse(raw)
        new(key: raw['key'], text: raw['text'], type: raw['type'], inline_style_ranges: Array(raw['inlineStyleRanges']))
      end

      def length
        text.length
      end

      def each_char
        return to_enum(:each_char) unless block_given?

        text.chars.map.with_index do |char, index|
          yield CharacterMeta.new(char: char, style_names: inline_styles.select { _1.range.cover?(index) }.map(&:name))
        end
      end

      CharRange = Struct.new(:text, :style_names, keyword_init: true)
      def each_range
        return to_enum(:each_range) unless block_given?

        current_styles = []
        ranges = [CharRange.new(text: '', style_names: current_styles)]

        each_char.with_index do |char, index|
          if char.style_names != current_styles
            current_styles = char.style_names
            yield(ranges.last) unless index == 0
            ranges << CharRange.new(text: '', style_names: current_styles)
          end

          ranges.last.text += char.char
        end

        yield ranges.last
      end

      alias plaintext text

      private

      def inline_styles
        @inline_styles ||= inline_style_ranges.map do |raw|
          StyleRange.parse(raw)
        end
      end
    end
  end
end