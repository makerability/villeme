RSpec.shared_examples "neighborhood example" do
  before(:each) do
    allow(Neighborhood).to receive(:find_by).and_return double(Neighborhood, name: 'Capitol Hill')
  end
end
