require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { FactoryBot.build(:product) }

  describe 'validate' do
    context 'attributes presence' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
      it { is_expected.to validate_presence_of(:price) }
      it { is_expected.to validate_presence_of(:photo_url) }
      it { is_expected.to validate_presence_of(:status) }
    end

    context 'attribute values' do
      it { is_expected.to validate_length_of(:name).is_at_most(100) }
      it { is_expected.to allow_value('https://foo.com').for(:photo_url) }
      it { is_expected.to define_enum_for(:status).with_values(active: 1, deactive: 0) }

      context 'when price contains more than two decimal places' do
        let(:three_decimal_places_number) { Faker::Number.decimal(l_digits: 3, r_digits: 3).to_f }
        let(:product) { FactoryBot.build(:product, price: three_decimal_places_number) }

        it { expect(product.price).to eq(three_decimal_places_number.round(2)) }
      end
    end
  end
end
