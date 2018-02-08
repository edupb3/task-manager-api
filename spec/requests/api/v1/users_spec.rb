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
        puts response.body
        user_response = JSON.parse(response.body)
        expect(user_response['id']).to eq(user.id)
      end
      
      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the user not exist' do
      let!(:user_id) {10}
      it 'return status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'POST /users' do
    context 'when the request params are valid' do
    end
    
    context 'when the request params are invalid' do
    end
    
  end
  
end