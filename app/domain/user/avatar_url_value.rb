module UserDomain
  module AvatarUrlValue

    extend self

    def get_avatar_url(user)
      if user.avatar_file_name != nil
        user.avatar.url(:thumb)
      elsif user.facebook_avatar
        user.facebook_avatar
      else
        'thumb/missing.png'
      end
    end

    def get_avatar_origin(user)
      if user.avatar_file_name != nil
        'aws'
      elsif user.facebook_avatar
        'facebook'
      else
        'default'
      end
    end

  end
end
