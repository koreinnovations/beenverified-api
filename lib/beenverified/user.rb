class BeenVerified
  class User
    attr_accessor :raw_xml, :link_back, :credentials, *BeenVerified::CREDENTIALS.map{|credential_type| credential_type[1][:plural].to_sym}
    def initialize(doc)
      @raw_xml = doc.root
      @link_back = doc.root.elements['link_back'].text
      
      #Cycle through all element types and see if there are any of them in the xml response
      @credentials = {}
      BeenVerified::CREDENTIALS.each do |credential_type|
        
        #set array to empty set
        type_array = []
        
        #Get the matching xml node
        credentials = doc.root.elements['credentials'].elements[credential_type[1][:plural]]
        
        #if there are credentials of this type, cycle through and instantiate objects of them
        #and add it to the array
        if credentials
          klass = "BeenVerified::#{credential_type[1][:class]}".constantize
          credentials.elements.each do |credential|
            type_array << klass.new(credential)
          end                    
        end
        eval("@#{credential_type[1][:plural]} = type_array")    
        @credentials[credential_type[1][:plural]] = type_array
        #puts @credentials.size
      end        
      
      def number_of_credentials
        credentials.inject(0){|sum, type| sum = sum+type[1].size }
      end
      
      def identity
        unless  identities.empty?
          identities[0]
        else
          nil
        end
      end
    end
  end
end


