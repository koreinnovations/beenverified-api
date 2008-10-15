class BeenVerified  
  class Client
      attr_reader :access_token, :request_token, :consumer, :format, :site
        #attr_accessor :consumer

      def initialize(options = {})
        options = {
          :debug  => false,
          :format => BeenVerified::FORMAT_XML
        }.merge(options)

        # symbolize keys
        options.map do |k,v|
          options[k.to_sym] = v
        end
        @site = if options[:debug]  && false
          BeenVerified::DEBUG_API_SERVER
        else
          BeenVerified::API_SERVER          
        end
        
        raise BeenVerified::ArgumentError, "OAuth Consumer Key and Secret required" if options[:consumer_key].nil? || options[:consumer_secret].nil?
        @consumer = OAuth::Consumer.new(options[:consumer_key], options[:consumer_secret],{
          :site=>@site,
          :scheme=>:header,
          :http_method=>:post,
          :request_token_path=>BeenVerified::REQUEST_TOKEN_PATH,
          :access_token_path=>BeenVerified::ACCESS_TOKEN_PATH,
          :authorize_path=>BeenVerified::AUTHORIZE_PATH
         })
        @debug    = options[:debug]
        @format   = options[:format]
       # @app_id   = options[:app_id]
        if options[:access_token] && options[:access_token_secret]
          @access_token = OAuth::AccessToken.new(@consumer, options[:access_token], options[:access_token_secret])
        else
          @access_token = nil
        end
        if options[:request_token] && options[:request_token_secret]
          @request_token = OAuth::RequestToken.new(@consumer, options[:request_token], options[:request_token_secret])
        else
          @request_token = nil
        end
      end

      def get_request_token(force_token_regeneration = false)
        if force_token_regeneration || @request_token.nil?
          @request_token = consumer.get_request_token
        end
        @request_token
      end
      
      def authorization_url
        raise BeenVerified::ArgumentError, "call #get_request_token first" if @request_token.nil?
        request_token.authorize_url
      end
      
      def convert_to_access_token
        raise BeenVerified::ArgumentError, "call #get_request_token and have user authorize the token first" if @request_token.nil?
        @access_token = request_token.get_access_token
      end
      
      def user(options={})
        raise BeenVerified::ArgumentError, "OAuth Access Token Required" unless @access_token
        response = get(BeenVerified::USER_API_PATH + ".#{format}", options)
        response
        BeenVerified::Response.new(response.body).user
      end
      
      
      alias_method :method_missing_with_type_filter, :method_missing
      def method_missing_with_type_filter(method_id, *arguments)
        if match = /^get_([_a-zA-Z]\w*|[_a-zA-Z]\w*s)$/.match(method_id.to_s) 
          if credential_type_match(match.captures.first)
           credential_type = match.captures.first
           if credential_type[-1..credential_type.length]=='s'
             get("#{API_PREFIX}/#{credential_type}.xml")           
           else
             get("#{API_PREFIX}/#{credential_type}s/#{arguments[0]}.xml")
           end
         else
           method_missing_without_type_filter(method_id, *arguments)
         end
        else
          method_missing_without_type_filter(method_id, *arguments)
        end
      end
      alias_method :method_missing, :method_missing_with_type_filter


      private
      def credential_type_match(cred_type)
        compare =  cred_type[-1..cred_type.length]=='s' ? cred_type[0..cred_type.length-2] : cred_type
        if BeenVerified::CREDENTIAL_TYPES.include?(compare)
          true
        else
          false
        end
      end
      
      protected
      
      def get(url, options = {}) #:nodoc:
        puts "URL TO BE GOTTEN: #{site}#{url}"
        request(:get, url, options)
      end
      
      def request(method, url, options) #:nodoc:
        response = case method
        #when :post
        #  access_token.request(:post, url, options[:params])
        when :get
          qs = options[:params].collect { |k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&") if options[:params]
          access_token.request(:get, "#{url}?#{qs}")
        else
          raise ArgumentError, "method #{method} not supported"
        end

        case response.code
        when '500'; then raise BeenVerified::BeenVerifiedException, "Internal Server Error"
        when '400'; then raise BeenVerified::BeenVerifiedException, "Method Not Implemented Yet"
        when '401'; then raise BeenVerified::BeenVerifiedException, "Token not Found"  
        else response
        end
      end


  end
end