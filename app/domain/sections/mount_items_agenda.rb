module Villeme
  module MountSections
    module Agenda
      require_relative '../../domain/items/get_items_agenda'

      class << self

        def get_items_agenda(user, options = {city: nil, json: false, limit: nil})
          @user = user
          @options = options

          create_json(items_agenda)
        end


        private

        def items_agenda
          Villeme::ItemsSection.agenda(@user, @options)
        end

        def create_json(items)
          {
              title: create_title,
              items: get_principal_events(items),
              snippet: get_snippet_events(items),
              count: items.count,
              city_name: @user.city_name,
              type: 'agenda'
          }
        end

        def create_link
          if @city
            Rails.application.routes.url_helpers.agenda_path(
                user: @user
            )
          else
            nil
          end
        end

        def get_principal_events(items)
          items.count <= 2 ? items[0...2] : items[0...5]
        end

        def get_snippet_events(items)
          items.count <= 2 ? items[2...12] : items[5...15]
        end

        def create_title
          "Items na agenda de #{@user.try(:first_name)}"
        end

      end
    end
  end
end
