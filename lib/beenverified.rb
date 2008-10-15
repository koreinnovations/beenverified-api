require 'net/https'
require 'rubygems'
gem 'oauth', ">= 0.2.1"
require 'oauth/helper'
require 'oauth/client/helper'
require 'oauth/request_proxy/net_http'
require 'activesupport'

#require 'hpricot'

class BeenVerified
  VERSION = '0.1.0'
  API_SERVER = "https://api.beenverified.com"
  AUTH_SERVER = "https://www.beenverified.com"
  DEBUG_API_SERVER = "http://localhost"
  DEBUG_AUTH_SERVER = "http://localhost"
  
  API_PREFIX = "/rest/1.0"
  FORMAT_XML = "xml"
  REQUEST_TOKEN_PATH= "/oauth/request_token"
  ACCESS_TOKEN_PATH= "/oauth/access_token"
  AUTHORIZE_PATH= "/oauth/authorize"
  USER_API_PATH="#{BeenVerified::API_PREFIX}/user/show"
  
  #CREDENTIAL_TYPES_PLURAL = %w(work_experiences  educations  professional_licenses  certifications  personal_references  emails web_sites)
  #CREDENTIAL_TYPES =        %w(work_experience education professional_license certification personal_reference email web_site)
  #CREDENTAIL_CLASSES =      %w(WorkExperience  Education  ProfessionalLicense  Certification  PersonalReference  Email  WebSite)
  CREDENTIALS = {:identity=>{:singular=>'identity', :plural=>'identities', :class=>'Identity'}, 
                 :work_experience=>{:singular=>'work_experience', :plural=>'work_experiences', :class=>'WorkExperience'},
                 :education=>{:singular=>'education', :plural=>'educations', :class=>'Education'},
                 :professional_license=>{:singular=>'professional_license', :plural=>'professional_licenses', :class=>'ProfessionalLicense'},
                 :certification=>{:singular=>'certification', :plural=>'certifications', :class=>'Certification'},
                 :personal_reference=>{:singular=>'personal_reference', :plural=>'personal_references', :class=>'PersonalReference'},
                 :email=>{:singular=>'email', :plural=>'emails', :class=>'Email'},
                 :web_site=>{:singular=>'web_site', :plural=>'web_sites', :class=>'WebSite'}}
  
  class Error < RuntimeError #:nodoc:
  end

  class ArgumentError < Error #:nodoc:
  end

  class BeenVerifiedException < Error #:nodoc:
  end
  
  #To convert each key to a getter method for the class
  #as seen at: http://blog.jayfields.com/2008/02/ruby-dynamically-define-method.html

end
class Hash
  def to_mod
    hash = self
    Module.new do
      hash.each_pair do |key, value|
        define_method key do
          value
        end
      end
    end
  end
end

#Dir['beenverified/**/*.rb'].sort.each { |lib| require lib }\
#require File.dirname(__FILE__) + '/beenverified/client'

require File.dirname(__FILE__) + '/beenverified/client'
require File.dirname(__FILE__) + '/beenverified/response'
require File.dirname(__FILE__) + '/beenverified/user'
require File.dirname(__FILE__) + '/beenverified/credentials'