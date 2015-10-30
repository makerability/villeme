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
          return "#{name}"
        elsif @item.cost.nil?
          return "#{subcategory}: #{name}"
        elsif @item.subcategories.empty?
          return "#{name} (#{price})"
        else
          return "#{subcategory}: #{name} (#{price})"
        end
      end

      def subcategory
        @item.subcategories.try(:first).try(:name)
      end

      def name
        @item.name
      end

      def price
        @item.price[:value]
      end

    end
  end
end
