require "rails_helper"

describe "/sections" do
  describe "/:resource" do
    describe "/:city" do

      describe "?categories=:categories" do

        before(:all) do
          @user = create(:user, invited: true, account_complete: true)
          login_as(@user, :scope => :user)
        end

        it "should returns section categories mounted object" do
          get "/pt-BR/api/v1/sections/items/albany?categories=leisure"

          # expect(response).to eq("section_categories")
          expect(response).to match_response_schema("section_categories")
        end

      end

    end
  end
end
