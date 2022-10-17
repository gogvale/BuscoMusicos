# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SessionControllers', type: :request do
  let(:password) { Faker::Internet.password }
  let(:user) { create(:musician, password:) }
  describe 'Sign Up' do
    let(:new_password) { Faker::Internet.password }
    describe 'for musicians' do
      let(:params) do
        {
          email: Faker::Internet.email,
          password: new_password,
          password_confirmation: new_password,

          role: :musician,
          name: Faker::Name.name,
          birth_date: [*18..60].sample.years.ago
        }
      end
      context 'with correct information' do
        before do
          post '/users/sign_up', params:
        end
        it 'returns http success' do
          expect(response).to(have_http_status(:success))
        end
        it 'creates new user' do
          expect(User.count).to(be_positive)
        end
      end
      describe 'with incorrect information' do
        context 'missing password' do
          before do
            params[:password] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'incorrect password_confirmation' do
          before do
            params[:password_confirmation] = Faker::Internet.password
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'missing name' do
          before do
            params[:name] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'missing role' do
          before do
            params[:role] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'missing birth_date' do
          before do
            params[:birth_date] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'too young' do
          before do
            params[:password] = 10.years.ago
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
      end
    end
    describe 'for musician_groups' do
      let(:params) do
        {
          email: Faker::Internet.email,
          password: new_password,
          password_confirmation: new_password,

          role: :musician_group,
          name: Faker::Name.name,
          birth_date: [*18..60].sample.years.ago,
          number_of_participants: Faker::Number.between(from: 1, to: 10)
        }
      end
      context 'with correct information' do
        before do
          post '/users/sign_up', params:
        end
        it 'returns http success' do
          expect(response).to(have_http_status(:success))
        end
        it 'creates new user' do
          expect(User.musician_group.count).to(be_positive)
        end
      end
      describe 'with incorrect information' do
        context 'missing password' do
          before do
            params[:password] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'incorrect password_confirmation' do
          before do
            params[:password_confirmation] = Faker::Internet.password
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'missing name' do
          before do
            params[:name] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'missing role' do
          before do
            params[:role] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'missing birth_date' do
          before do
            params[:birth_date] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'too young' do
          before do
            params[:password] = 10.years.ago
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'missing number_of_participants' do
          before do
            params[:number_of_participants] = nil
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
        context 'wrong number_of_participants' do
          before do
            params[:number_of_participants] = 0
            post '/users/sign_up', params:
          end
          it 'returns http unprocessable_entity' do
            expect(response).to(have_http_status(:unprocessable_entity))
          end
        end
      end
    end
  end
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
        expect(response.headers.dig('Access-Token')).not_to(be_blank)
        expect(response.headers.dig('Expire-At')).not_to(be_blank)
        expect(response.headers.dig('Refresh-Token')).not_to(be_blank)
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
      post '/users/tokens', headers:
    end
    it 'returns http success' do
      expect(response).to(have_http_status(:success))
    end
    it 'refreshes token' do
      expect(response.headers.dig('Access-Token')).not_to(be_blank)
      expect(response.headers.dig('Expire-At')).not_to(be_blank)
      expect(response.headers.dig('Refresh-Token')).not_to(be_blank)
    end
  end
end
