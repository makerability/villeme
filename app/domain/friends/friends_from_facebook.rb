module Villeme
  module FriendsModule
    class << self

      def get_friends_from_facebook(user)
        @user = user

        if user_have_token?
          facebook_api_via_koala = Koala::Facebook::API.new(@user.token)
          friends_from_facebook = get_friends_list(facebook_api_via_koala)
          cut_list_of_friends(friends_from_facebook, 150)
        else
          false
        end
      end


      private

      def get_friends_list(access_facebook_api_via_koala)
        access_facebook_api_via_koala.get_connections("me", "friends_from_facebook?fields=id,name,picture.type(square)")
      end

      def cut_list_of_friends(friends_from_facebook, limit)
        friends_from_facebook[0..limit]
      end

      def user_have_token?
        @user.token
      end

    end
  end
end