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

    end
  end
end