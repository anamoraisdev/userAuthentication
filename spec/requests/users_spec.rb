require 'swagger_helper'

RSpec.describe 'users', type: :request do
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            },
            required: ['email', 'password', 'password_confirmation']
          }
        },
        required: ['user']
      }

      response '201', 'User created' do
        let(:user) do
          {
            user: {
              email: 'foo@example.com',
              password: 'bar123',
              password_confirmation: 'bar123'
            }
          }
        end
        run_test!
      end

      response '422', 'Invalid request' do
        let(:user) { { user: { email: 'foo@example.com' } } }
        run_test!
      end
    end
  end
end
