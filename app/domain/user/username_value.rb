module UserDomain
  module UsernameValue

    extend self

    def get_username(user)
      @user = user

      if user_have_username?
        @user[:username]
      else
        create_new_username
      end
    end


    private

    def create_new_username
      username_with_one_word = @user.name.split.first.downcase
      if username_exist?(username_with_one_word)
        create_username_with_two_words
      else
        username_with_one_word
      end
    end

    def create_username_with_two_words
      username_with_two_words = @user.name.split[0..1].join.downcase
      if username_exist?(username_with_two_words)
        create_username_with_three_words
      else
        username_with_two_words
      end
    end

    def create_username_with_three_words
      if @user.name.split.count > 1
        @user.name.split[0..2].join.downcase
      else
        @user.name.split[0..1].join.downcase + rand(10).to_s
      end
    end

    def user_have_username?
      !@user[:username].blank?
    end

    def username_exist?(username)
      if User.find_by(username: username)
        true
      else
        false
      end
    end

  end
end