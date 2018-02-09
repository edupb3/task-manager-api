require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) {create(:user)}
  let!(:user_id) {user.id}
  before { host! 'api.taskmanager.dev' } 
  
  describe 'GET /users/:id' do
    before do
      headers = {'Accept' => 'application/vnd.taskmanager.v1'}
      get "/api/users/#{user_id}", params: {}, headers: headers
    end
    
    context 'when the user exist' do
      it 'return the user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:id]).to eq(user.id)
      end
      
      it 'return status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end
    
    context 'when the user not exist' do
      let!(:user_id) {10000}
      it 'return status code 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
  
  describe 'POST /users' do
    
    before do
      headers = {'Accept:' => 'application/vnd.taskmanager.v1'}
      post '/api/users', params: {user: user_params}, headers: headers
    end
    
    context 'when the request params are valid' do
      let(:user_params) {attributes_for(:user)}
      it 'return status code 201 - created' do
        expect(response).to have_http_status(:created)
      end
      it 'return json data' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(user_params[:email])
      end
    end
    
    context 'when the request params are invalid' do
      let!(:user_params) {attributes_for(:user, email: 'mesa@rest.com', password: '123456', password_confirmation: '12345')}
      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'return json data for errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
      it 'return message error doesnt match Password' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors]).to eq({:password_confirmation=>["doesn't match Password"]})
      end
    end
  end
  
  describe 'PUT /users/:id' do
    
    before do
      headers = {'Accept:' => 'application/vnd.taskmanager.v1'}
      put "/api/users/#{user_id}", params: {user: user_params}, headers: headers
    end
    
    context 'when the request params are valid' do
      let(:user_params) { {email: 'novo@mail.com'}}
      
      it 'return status code 200 - ok' do
        expect(response).to have_http_status(:ok)
      end
      
      it 'return json data for updated user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(user_params[:email])
      end
      
    end
     
    context 'when the request params are invalid' do
      let!(:user_params) {attributes_for(:user, email: 'mesa@rest.com', password: '123456', password_confirmation: '12345')}
      
      it 'return status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it 'return json data for errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
    end
  end
  
  describe 'DELETE /users/:id' do
    before do
      headers = {'Accept' => 'application/vnd.taskmanager.v1'}
      delete "/api/users/#{user_id}", params: {}, headers: headers
    end
    
    context 'delete the user' do
      it 'return status code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end
    
  end
  
end