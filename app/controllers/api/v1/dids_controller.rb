module Api
    module V1
        class DidsController < ApiController
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            include DidHelper

            def resolve
                did = params[:id].to_s
                if did.starts_with?("did:")
                    if did == "did:web:data-vault.eu:u:GTmRFQ2PhHIEgZzeUtA_u4j7cWiKDNaC3sBOwrldxqXoy5"
                        # for testing purpose only
                        retVal = {
                            "data": [{
                                "name": "John Doe",
                                "tel": "00436785551212",
                                "email": "john.doe@acme.org",
                                "adr": {
                                    "street": "Hauptstraße 1",
                                    "locality": "Unterstinkenbrunn",
                                    "code": "2154",
                                    "country": "at"
                                },
                                "notes": []
                            }]
                        }.deep_stringify_keys
                        render json: retVal, 
                               status: 200
                        return                        
                    end
                    # !!! fix me: acutally resolve DID using uniresolver.io
                    # however, uniresolver can't currently resolve did:web:data-vault.eu correctly
                    token = getToken(ENV["PDS_URL"], ENV["PDS_KEY"], ENV["PDS_SECRET"])
                    did_url = ENV["PDS_URL"] + '/api/dec112/query/' + did
                    response = HTTParty.get(did_url, headers: defaultHeaders(token))
                    if response.code == 200
                        message = response.parsed_response

                        key2 = JSON.parse(Store.pluck(:item).select{|i| JSON.parse(i)["did"] == did}.first)["key"] rescue ""

                        if key2 != ""
                            # decrypt
                            cipher = [message["value"]].pack('H*')
                            nonce = [message["nonce"]].pack('H*')
                            private_key = RbNaCl::PrivateKey.new([ShamirSecretSharing::Base58.combine([message["key1"], key2])].pack('H*'))

                            authHash = RbNaCl::Hash.sha256('auth'.force_encoding('ASCII-8BIT'))
                            auth_key = RbNaCl::PrivateKey.new(authHash).public_key
                            box = RbNaCl::Box.new(auth_key, private_key)
                            pr = JSON.parse(box.decrypt(nonce, cipher)) rescue []

                            # build return JSON
                            retVal = {
                                "data": [{
                                    "name": (pr["title"].to_s.strip + " " + pr["surName"].to_s.strip + " " + pr["familyName"]).strip,
                                    "tel": pr["phone"].to_s.strip,
                                    "email": pr["mail"].to_s.strip,
                                    "adr": {
                                        "street": pr["street"].to_s.strip,
                                        "locality": pr["city"].to_s.strip,
                                        "code": pr["zipCode"].to_s.strip,
                                        "country": pr["country"].to_s.strip
                                    },
                                    "notes": JSON.parse(pr["additionalData"].to_json)
                                }]
                            }.deep_stringify_keys
                            render json: retVal, 
                                   status: 200
                        else
                            render json: {"error": "Cannot resolve DID"},
                                   status: response.code
                        end
                    else
                        render json: {"error": response.parsed_response["error"].to_s},
                               status: response.code
                    end
                else
                    render json: {"error": "invalid DID"},
                           status: 412
                end
            end
        end
    end
end