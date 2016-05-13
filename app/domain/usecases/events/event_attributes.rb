module Villeme
  module UseCases
    class EventAttributes
      class << self

        def name_with_limit(entity)
          name = entity.name

          if name.length > 45
            "#{name[0..45]}..."
          else
            name
          end
        end


        def description_with_limit(entity)

          return nil if entity.description.nil?

          name = entity.name
          description = ActionController::Base.helpers.strip_tags(entity.description)
          if name.length > 25
            "#{description[0..70]}..."
          else
            "#{description[0..100]}..."
          end
        end

        def description_without_html(item)
          ActionController::Base.helpers.strip_tags(item.description).gsub("&nbsp;", " ")
        end

        def price(entity)
          response = Hash.new(value: nil, currency: nil)

          if entity.cost.nil?
            return response
          elsif I18n.locale == 'pt-BR'
            response[:value] = '%.2f' % entity.cost
            response[:currency] = 'R$'
          elsif I18n.locale == :en
            response[:value] = '%.2f' % entity.cost
            response[:currency] = 'R$'
          else
            response[:value] = '%.2f' % entity.cost
          end

          return response
        end



        def period_that_occurs(entity)
          if entity.all_year?
            'O ano todo'
          else
            "#{entity.date_start.strftime("%d/%m")} - #{entity.date_finish.strftime("%d/%m")}"
          end
        end


        def get_start_hour(entity)
          if entity.allday?
            'AM-PM'
          elsif !entity.hour_start_first.nil?
            hour = entity.hour_start_first.strftime('%H:%M')
            hour.include?(':00') ? hour.chomp(':00') << 'h' : hour << 'h'
          else
            ''
          end
        end

      end
    end
  end
end
