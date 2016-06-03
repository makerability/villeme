RSpec.shared_examples "user example" do
  before(:each) do

    # Merit
    allow(user).to receive(:add_points).and_return double(Merit, id: 1, score_id: 1, num_points: 10)
    allow(user).to receive(:points).and_return 10
    allow(user).to receive_message_chain(:level, :points).and_return 0
    allow(user).to receive_message_chain(:level, :nivel).and_return 1
    allow(user).to receive_message_chain(:next_level, :points).and_return 30
    allow(user).to receive_message_chain(:next_level, :nivel).and_return 2
  end
end
