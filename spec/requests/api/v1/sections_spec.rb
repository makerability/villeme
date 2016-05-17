require "rails_helper"

describe "/sections" do
  describe "/:resource" do
    describe "/:city" do

      describe "?categories=:categories" do

        it "should returns section categories mounted" do
          user = create(:user)

          get "/pt-BR/api/v1/sections/items/rio-de-janeiro?categories=leisure"

          expect(response.status).to eq 200
          expect(response).to match_response_schema("section_categories")
        end

      end

    end
  end
end
