module Villeme
  module Agenda
    class << self

      def which_friends_will_this_event?(user, event, options = {json: false})
        @user = user
        @event = event
        @friends = @user.accepted_friends
        @friends_will_this_event = get_friends_will_the_event

        if options[:json]
          create_json_response
        else
          @friends_will_this_event
        end
      end


      private

      def get_friends_will_the_event
        friends_will_this_event = []

        @friends.each do |friend|
          if friend.agended?(@event)
            friends_will_this_event << friend
          end
        end
        friends_will_this_event
      end

      def create_json_response
        @friends_will_this_event.map do |friend|
          {
              name: friend.name,
              avatar: {
                  url: friend.get_avatar_url,
                  origin: friend.get_avatar_origin
              }
          }
        end
      end

    end
  end
end