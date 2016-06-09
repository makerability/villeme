module Villeme
  module MountSections
    module Categories
      extend self

      def get_events_categories(categories, city, options = {})
        @options = options
        @categories = categories
        @city = city
        @user = options.fetch(:user, nil)
        @upcoming = options.fetch(:upcoming, true)
        @json = options.fetch(:json, false)
        @limit = options.fetch(:limit, nil)
        @principal_size = options.fetch(:principal_size, 2)
        @snippet_size = options.fetch(:snippet_size, 12)
        @snippet = options.fetch(:snippet, true)

        create_json(events_category)
      end


      private

      def create_json(events)
        {
            title: "Eventos de #{get_categories_name}",
            items: get_principal_events(events),
            snippet: get_snippet_events(events),
            count: events.count,
            link: create_link,
            link_to_create: '/events/new',
            type: 'category'
        }
      end

      def get_categories_name
        if @categories.is_a? Array
          @categories.map(&:capitalize).join(" e ")
        else
          @categories.capitalize
        end
      end

      def get_principal_events(events)
        if is_snippet?
          events[0...get_principal_size]
        else
          events
        end
      end

      def get_snippet_events(events)
        if is_snippet?
          events[get_principal_size..get_snippet_size]
        else
          Event.none
        end
      end

      def events_category
        Event.all_categories_in_city(@categories, @city, @options)
      end

      def create_link
        if @categories
          "?#{{categories: @categories}.to_query}"
        else
          ""
        end
      end

      def get_principal_size
        @principal_size.nil? ? 2 : @principal_size
      end

      def get_snippet_size
        @snippet_size.nil? ? 12 : @snippet_size
      end

      def is_snippet?
        @snippet == nil ? true : @snippet
      end

    end
  end
end
