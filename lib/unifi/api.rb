require 'net/http'
require 'uri'
require 'openssl'
require 'json'
require 'jwt'
require 'unifi/errors/errors'

module UniFi
  class Api
  
    attr_accessor :address, :username, :password, :csrf, :token
  
    # Define our init/new method so our class builds out the needed instance vars
    # This calls out to the system API to obtain a JWT and derive our CSRF token
    def initialize(address = 'unifi', username = 'ubnt', password = 'ubnt')
      self.address = address
      self.username = username
      self.password = password
      self.csrf = nil
      self.token = nil
  
      endpoint = "https://#{self.address}/api/system"
    
      call_api(endpoint, 'GET')
      login 
    end
  
    # This method calls the stat_ips_events API which returns all unarchived IPS events.
    def fetch_all_ips_alerts
      endpoint = "https://#{self.address}/proxy/network/api/s/default/stat/alarm"
      data = { '_limit' => 500, '_start' => 0, '_withcount' => true, 'archived' => false }
      
      return call_api(endpoint, 'POST', data)
    end
  
    # Archive "alarm" events. If alarm_id is passed in, it archives only the targeted event, else it archives them all.
    def archive_alarm(alarm_id = nil)
      endpoint = "https://#{self.address}/proxy/network/api/s/default/cmd/evtmgr"
  
      if alarm_id == nil
        data = {'cmd' => 'archive-all-alarms'}
      else
        data = {'cmd' => 'archive-alarm', '_id' => alarm_id}
      end
      
      call_api(endpoint, 'POST', data)
      
    end
  
    private
  
    # Login to the UniFi OS Platform.
    def login
      endpoint = "https://#{self.address}/api/auth/login"
      data = { 'username' => self.username, 'password' => self.password }
  
      call_api(endpoint, 'POST', data, true)
    end
  
    # This is a DRY'd Net:HTTP interface. It also updates our JWT and CSRF tokens if they have changed.
    def call_api(endpoint, req_type, data = nil, login_attempt = nil)
      uri = URI.parse(endpoint)
      if req_type == 'POST'
        request = Net::HTTP::Post.new(uri)
      else
        request = Net::HTTP::Get.new(uri)
      end
  
      request["Cookie"] = "TOKEN=#{self.token}" unless self.token == nil
      request["X-Csrf-Token"] = self.csrf unless self.csrf == nil
      request["Content-Type"] = 'application/json'
  
      request.body = JSON.dump(data) unless data == nil
      
      req_options = {
        use_ssl: uri.scheme == "https",
        verify_mode: OpenSSL::SSL::VERIFY_NONE,
      }
      
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
  
      if response.code == '200'    
        self.token = response.read_header["Set-Cookie"].split(';')[0].split('=')[1]
        self.csrf = JWT.decode(self.token, '', false, {algorithm: 'HS256'})[0]['csrfToken']
        json = JSON.load(response.body)
        return json
      elsif response.code == '401'
        if login_attempt 
          raise UniFi::Errors::InvalidCredentials
        else
          login
          call_api(endpoint, req_type, data, login_attempt)
        end
      end
    end
  end
end
