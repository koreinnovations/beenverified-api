class BeenVerified
  class Response

    #Parses the XML response from BeenVerified
    def initialize(doc)
      doc = REXML::Document.new(doc) unless doc.is_a?(REXML::Document || REXML::Element)
      @doc = doc
      raise BeenVerified::BeenVerifiedException, @doc.elements['error'].attributes["error_code"] if !success? 
    end

    #does the response indicate success?
    def success?
      @doc.elements['error'].nil? 
    end

    def user
      @user ||= BeenVerified::User.new(@doc)      
    end


  end
end