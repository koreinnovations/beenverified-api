class BeenVerified
    class Credential
      attr_accessor :id
      def initialize(data=nil)
        unless data
          @data_hash = nil
          return
        else
          @id = data.attributes["id"]
          @data_hash ={}
          data.elements.each do |data_point|
           @data_hash[data_point.name.to_sym]=data_point.text
          end
        end        
        
        methods = @data_hash.reject{|key, val| key==:verified_on}
        self.extend methods.to_mod
      end

      def [](index)
        if @data_hash==nil
          return nil
        else
          return @data_hash[index]
        end
      end
      
      def verified_on
        Date.parse(@data_hash[:verified_on])
      end
    
    end

    class Identity < Credential
      def full_name
        "#{@data_hash[:first_name]} #{@data_hash[:last_name]}"
      end
    end
    
    class WorkExperience < Credential;end
    class Education < Credential;end
    class ProfessionalLicense < Credential;end
    class Certification < Credential;end
    class PersonalReference < Credential;end
    class Email < Credential;end
    class WebSite < Credential;end

  
end