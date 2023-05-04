require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:valid_attributes) { FactoryBot.attributes_for(:product) }
  let(:invalid_attributes) {
    valid_attributes[:name] = Faker::Lorem.paragraph_by_chars(number: 101)
    valid_attributes
  }

  describe "GET /index" do
    context 'without search params' do
      before { FactoryBot.create_list(:product, 10) }

      it "renders a successful response" do
        get products_url, as: :json
        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.is_a? Array).to be_truthy

        # Pagination max elements
        expect(parsed_response.count).to eq(5)
      end
    end

    context 'with search params' do
      context 'when match name' do
        let(:search_chars) { valid_attributes[:name][3..5] }
        let!(:matching_product) { FactoryBot.create(:product, valid_attributes) }
        let!(:not_matching_product) { FactoryBot.create(:product, name: matching_product.name.gsub(search_chars, '')) }

        before { FactoryBot.create_list(:product, 5) }

        it 'return only matching products' do
          get products_url(term: search_chars), as: :json

          expect(response).to be_successful

          parsed_response = JSON.parse(response.body)
          expect(parsed_response.is_a? Array).to be_truthy

          response_product_ids = parsed_response.map { |el| el['id']}
          expect(response_product_ids).to     include(matching_product.id)
          expect(response_product_ids).to_not include(not_matching_product.id)
        end
      end
    end
  end

  describe "GET /show" do
    let(:product) { FactoryBot.create(:product) }

    context 'passing an existing product by param' do
      it "renders a successful response" do
        get product_url(product), as: :json
        expect(response).to be_successful

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.is_a? Hash).to   be_truthy
        expect(parsed_response['name']).to      eq(product.name)
        expect(parsed_response['price']).to     eq(product.price.to_f.to_s)
        expect(parsed_response['photo_url']).to eq(product.photo_url)
      end
    end

    context 'passing an inexisting product by param' do
      let(:product) { FactoryBot.build(:product) }

      it "renders a not found response" do
        get product_url(id: rand(500..600)), as: :json
        expect(response).to be_not_found
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Product" do
        expect { post products_url, params: { product: valid_attributes }, as: :json }
          .to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post products_url, params: { product: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect { post products_url, params: { product: invalid_attributes }, as: :json }
          .to change(Product, :count).by(0)
      end

      it "renders a JSON response with errors for the new product" do
        post products_url, params: { product: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    let(:product) { FactoryBot.create(:product) }

    context "with valid parameters" do
      let(:new_attributes) { FactoryBot.attributes_for(:product) }

      it "updates the requested product" do
        patch product_url(product), params: { product: new_attributes }, as: :json
        product.reload

        expect(product.name).to       eq(new_attributes[:name])
        expect(product.price.to_f).to eq(new_attributes[:price].to_f)
        expect(product.photo_url).to  eq(new_attributes[:photo_url])
        expect(product.status).to     eq('active')
      end

      it "renders a JSON response with the product" do
        patch product_url(product), params: { product: new_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the product" do
        patch product_url(product), params: { product: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:product) { FactoryBot.create(:product) }
    it { expect { delete product_url(product), as: :json }.to change(Product, :count).by(-1) }
  end

  describe "PUT /deactivate" do
    let(:active_product)   { FactoryBot.create(:product) }
    let(:deactive_product) { FactoryBot.create(:product, status: :deactive) }

    it 'change product to deactive' do
      put product_deactivate_url(active_product), as: :json

      expect(response).to be_successful
      active_product.reload
      expect(active_product.status).to eq('deactive')
    end

    it 'return error' do
      put product_deactivate_url(deactive_product), as: :json

      expect(response).to be_bad_request
      deactive_product.reload
      expect(deactive_product.status).to eq('deactive')
    end
  end
end
