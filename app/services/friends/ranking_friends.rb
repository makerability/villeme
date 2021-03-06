module FriendsService
  extend self

  def ranking_friends(user)
    @user = user

    reverse_ranking(get_list_of_friends)
  end


  private

  def get_list_of_friends
    ranking_array ||= Array.new

    @user.accepted_friends[0..25].each do |friend|
      friend_attributes = {id: friend.id, name: friend.name, points: friend.points, slug: friend.slug}
      ranking_array << friend_attributes
    end

    add_user_to_ranking_friends(@user, ranking_array)

    ranking_array
  end

  def add_user_to_ranking_friends(user, ranking_array)
    ranking_array << {id: user.id, name: user.name, points: user.points}
  end

  def reverse_ranking(ranking_array)
    ranking_array.sort_by { |obj| obj[:points] }.reverse!
  end

end