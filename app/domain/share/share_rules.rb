module Villeme
  module ShareRules
    class << self

      def title(item)
        @item = item

        format_title
      end

      private

      def format_title
        if @item.subcategories.empty? and @item.cost.nil?
          return "#{title}"
        elsif @item.cost.nil?
          return "#{subcategory}: #{title}"
        elsif @item.subcategories.empty?
          return "#{title} (#{price})"
        end
      end

      def subcategory
        @item.subcategories.try(:first).try(:name)
      end

      def title
        @item.title
      end

      def price
        @item.price[:value]
      end

    end
  end
end
