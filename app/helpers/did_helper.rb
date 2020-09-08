module DidHelper
    def defaultHeaders(token)
        { 'Accept' => '*/*',
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer ' + token }
    end

    def getToken(server_url, app_key, app_secret)
        auth_url = server_url + '/oauth/token'
        auth_credentials = { username: app_key, 
                             password: app_secret }
        response = HTTParty.post(auth_url,
                                 basic_auth: auth_credentials,
                                 body: { grant_type: 'client_credentials' })
        token = response.parsed_response["access_token"]
        if token.nil?
            nil
        else
            token
        end
    end

end
