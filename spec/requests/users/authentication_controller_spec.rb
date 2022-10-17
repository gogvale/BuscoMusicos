# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AuthenticationController, type: :request do
  let(:password) { Faker::Internet.password }
  let(:user) { create(:musician, password:) }
  describe 'Sign In' do
    describe 'with correct information' do
      let(:params) do
        {
          email: user.email,
          password:
        }
      end
      before do
        post '/users/sign_in', params:
      end
      it 'returns http success' do
        expect(response).to(have_http_status(:success))
      end
      it 'returns token' do
        expect(response.headers.dig("Access-Token")).not_to(be_blank)
        expect(response.headers.dig("Expire-At")).not_to(be_blank)
        expect(response.headers.dig("Refresh-Token")).not_to(be_blank)
      end
    end
    describe 'with incorrect information' do
      let(:params) do
        {
          email: user.email,
          password:
        }
      end
      context 'missing password' do
        before do
          params[:password] = nil
          post '/users/sign_up', params:
        end
        it 'returns http unprocessable_entity' do
          expect(response).to(have_http_status(:unprocessable_entity))
        end
      end
      context 'incorrect password' do
        before do
          params[:password] = Faker::Internet.password
          post '/users/sign_up', params:
        end
        it 'returns http unprocessable_entity' do
          expect(response).to(have_http_status(:unprocessable_entity))
        end
      end
      context 'non-existent email' do
        before do
          params[:email] = Faker::Internet.email
          post '/users/sign_up', params:
        end
        it 'returns http unprocessable_entity' do
          expect(response).to(have_http_status(:unprocessable_entity))
        end
      end
    end
  end
  describe 'Refresh Token' do
    let(:headers) { Support::User.new(expired: true).headers }
    before do
      post '/users/tokens', headers: headers
    end
    it "returns http success" do
      expect(response).to(have_http_status(:success))
    end
    it "refreshes token" do
      expect(response.headers.dig("Access-Token")).not_to(be_blank)
      expect(response.headers.dig("Expire-At")).not_to(be_blank)
      expect(response.headers.dig("Refresh-Token")).not_to(be_blank)
    end
  end
end
