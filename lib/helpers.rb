require 'ostruct'
require 'yaml'
require 'psych'
require 'pry'
require 'net/http'
require 'json'

module OauthHelpers
  def config
    @config ||= begin
      path = File.absolute_path(__FILE__ + '/../../config.yaml')
      OpenStruct.new(Psych.load_file(path))
    end
  end

  def auth_url
    'https://accounts.google.com/o/oauth2/v2/auth?' \
    'scope=email'\
    '&access_type=offline'\
    '&redirect_uri='\
      "#{config.redirect_uri}"\
    '&response_type=code&'\
    '&state='\
      "#{config.state}"\
    '&client_id='\
      "#{config.client_id}"
  end

  def get_access_token(code)
    uri = URI('https://www.googleapis.com/oauth2/v4/token')
    data = {
      code: code,
      client_id: config.client_id,
      client_secret: config.client_secret,
      redirect_uri: config.redirect_uri,
      grant_type: 'authorization_code'
    }
    Net::HTTP.post_form(uri, data).body
  end

  def get_my_info(token)
    token = JSON.parse(token)
    uri = URI(
      'https://www.googleapis.com/plus/v1/people/me?'\
      "access_token=#{token['access_token']}"
    )
    JSON.parse(Net::HTTP.get(uri))
  end

  def _render(template, options = {})
    options.each { |k, v| instance_variable_set("@#{k}", v) }
    template = File. read(template)
    ERB.new(template).result(binding)
  end

end