module Villeme
  module Notifies
    class << self

      def newsfeed_notify_count(user)
        if user.has_notify
          user.newsfeed_notify.count
        else
          0
        end
      end

      def has_notify(user)
        if user.notify.nil?
          false
        else
          true
        end
      end

      def get_notifies(user)
        if user.has_notify
          if user.notify.newsfeed_view.blank?
            notify_date = DateTime.current - 300
          else
            notify_date = user.notify.newsfeed_view
          end
          Event.where('created_at BETWEEN ? AND ?', notify_date, DateTime.current)
        end
      end

      def requested_friendships_notifies(user)
        if user.notify.nil?
          user.requested_friendships.where('created_at BETWEEN ? AND ?', DateTime.current - 365, DateTime.current)
        else
          user.requested_friendships.where('created_at BETWEEN ? AND ?', user.notify.bell_view, DateTime.current)
        end
      end

    end
  end
end