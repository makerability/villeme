module Villeme
  module ShareRules
    class << self

      def title(item)
        @item = item

        return format_title
      end

      private

      def format_title
        if @item.subcategories.empty? and @item.cost.nil?
          "#{title}"
        elsif @item.cost.nil?
          "#{subcategory}: #{title}"
        elsif @item.subcategories.empty?
          "#{title} (#{price})"
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
