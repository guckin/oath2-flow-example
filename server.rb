require 'sinatra/base'
require 'sinatra/cookies'

require_relative 'lib/helpers'

class Server < Sinatra::Base
  include OauthHelpers

  helpers Sinatra::Cookies

  set :port, 8080
  set :bind, '0.0.0.0'

  get '/' do
    cookies[:state] = (0...30).map { ('a'..'z').to_a[rand(26)] }.join
    _render 'lib/template/index.erb', url: auth_url
  end

  get '/auth' do
    cookies[:token_data] = get_access_token params['code']
    _render 'lib/template/auth.erb', url: '/content'
  end

  get '/content' do
    result = get_my_info(cookies[:token_data])
    data = {}
    data[:first_name] = result['name']['givenName']
    data[:last_name] = result['name']['familyName']
    data[:email] = result['emails'][0]['value'] if result['emails'].is_a? Array
    data[:glink] = result['url']
    data[:state] = cookies[:state]
    _render 'lib/template/content.erb', data
  end
end

Server.run!
