module Villeme
  module LevelsModule
    class << self

      def next_level(entity)
        if entity.level.nil?
          false
        else
          next_level_nivel = entity.level.nivel + 1
          Level.find_by(nivel: next_level_nivel)
        end
      end

      def percentage_of_current_level(entity)
        if entity.level.nil? || entity.level.points.nil?
          0
        elsif entity.next_level
          ((entity.points - entity.level.points) * 100) / (entity.next_level.points - entity.level.points)
        else
          0
        end
      end

      def points_to_next_level(entity)
        if entity.next_level
          next_level_points = entity.next_level.points.to_i
          current_user_points = entity.points.to_i

          next_level_points - current_user_points
        else
          0
        end
      end

      def get_icon(entity)
        entity.level.icon.url(:original) unless entity.level.nil?
      end

    end
  end
end