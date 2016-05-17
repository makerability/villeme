module Villeme
  module MountSections
    class << self

      def get_events_categories(categories, city, options = {user: nil, upcoming: true, json: false, limit: nil, principal_size: 2, snippet_size: 12, snippet: true})
        @categories = categories
        @city = city
        @options = options


        create_json(events_category)
      end


      private

      def create_json(events)
        {
            title: 'Eventos indicados para você',
            items: get_principal_events(events),
            snippet: get_snippet_events(events),
            count: events.count,
            link: create_link,
            link_to_create: '/events/new',
            type: 'category'
        }
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
        if @city and @categories
          Rails.application.routes.url_helpers.newsfeed_city_category_path(
              city: @city,
              categories: Category.find_by(slug: @categories)
          )
        else
          ""
        end
      end

      def get_principal_size
        @options[:principal_size].nil? ? 2 : @options[:principal_size]
      end

      def get_snippet_size
        @options[:snippet_size].nil? ? 12 : @options[:snippet_size]
      end

      def is_snippet?
        @options[:snippet] == nil ? true : @options[:snippet]
      end

    end
  end
end
