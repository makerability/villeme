module FriendsRepository
  extend self

  def get_friends_from_facebook(user)
    @user = user

    if user_have_token?
      koala_api = Koala::Facebook::API.new(@user.token)
      list_of_friends = get_friends_list(koala_api)
      cut_list_of_friends(list_of_friends, 150)
    else
      false
    end
  end


  private

  def get_friends_list(koala_api)
    koala_api.get_connections("me", "friends_from_facebook?fields=id,name,picture.type(square)")
  end

  def cut_list_of_friends(list_of_friends, limit)
    list_of_friends[0..limit]
  end

  def user_have_token?
    @user.token
  end

end