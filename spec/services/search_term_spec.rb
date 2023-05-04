require 'rails_helper'

RSpec.describe SearchTerm do
  context 'when search a product by name' do
    let!(:product_matching) { FactoryBot.create(:product) }
    let(:searching_term) { product_matching.name[1..2] }
    let(:product_name_not_matching) { product_matching.name.gsub(searching_term, '')}
    let!(:product_not_matching) { FactoryBot.create(:product, name: product_name_not_matching) }

    before { FactoryBot.create_list(:product, 5) }

    subject(:search_product) { described_class.new(resource: Product, column: :name, term: searching_term) }

    it { expect(Product.count).to           eq(7) }
    it { expect(search_product.call).to     include(product_matching) }
    it { expect(search_product.call).to_not include(product_not_matching) }
  end
end
