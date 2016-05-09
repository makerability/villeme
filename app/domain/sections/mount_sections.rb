module Villeme
  module MountSections
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