module Villeme
  module ItemsSection
    class << self

      def all_persona_in_city(personas, city, options = {limit: false, user: nil, upcoming: true, json: false})
        personas = personas_to_capitalize(personas)

        if options[:limit] and city.try(:items)
          city.items.includes({personas: :translations}).where(personas_translations: { name: personas }).limit(options[:limit])
        elsif city.try(:items)
          items = if options[:upcoming]
                    city.items.includes({personas: :translations}).where(persona_translations: {name: personas}).upcoming
                  else
                    city.items.includes({personas: :translations}).where(persona_translations: {name: personas})
                  end

          if options[:json]
            return Item.items_to_json(items, options)
          else
            return items
          end
        else
          Item.none
        end
      end


      private

      def personas_to_capitalize(personas)
        if personas.class == Array
          personas.map { |persona| persona.capitalize }
        else
          personas.capitalize
        end
      end

    end
  end
end
