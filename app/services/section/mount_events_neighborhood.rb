module SectionService
  module Neighborhood

    extend self

    def get_events_neighborhood(neighborhoods, options = {})
      @options = options
      @neighborhoods = neighborhoods
      @user = options.fetch(:user, nil)
      @upcoming = options.fetch(:upcoming, true)
      @json = options.fetch(:json, false)
      @limit = options.fetch(:limit, nil)
      @principal_size = options.fetch(:principal_size, 2)
      @snippet_size = options.fetch(:snippet_size, 12)
      @snippet = options.fetch(:snippet, true)

      create_json(events_neighborhood)
    end


    private

    def create_json(events)
      {
        title: create_title,
        items: get_principal_events(events),
        snippet: get_snippet_events(events),
        count: events.count,
        link: create_link,
        link_to_create: '/events/new',
        neighborhood_name: @neighborhoods,
        type: 'neighborhood'
      }
    end

    def events_neighborhood
      Event.all_in_neighborhood(@neighborhoods, @options)
    end

    def create_title
      "Eventos acontecendo no bairro #{get_neighborhoods_name}"
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

    def create_link
      if @neighborhoods
        if @neighborhoods.is_a? Array
          "?#{{neighborhoods: @neighborhoods.map(&:capitalize)}.to_query}"
        else
          "?#{{neighborhoods: @neighborhoods}.to_query}"
        end
      else
        nil
      end
    end

    def get_neighborhoods_name
      if @neighborhoods.is_a? Array
        @neighborhoods.map(&:capitalize).join(" e ")
      else
        @neighborhoods.capitalize
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
