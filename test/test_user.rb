require 'rubygems'
require "rexml/document"
require File.dirname(__FILE__) + '/test_helper.rb'


class TestUser < Test::Unit::TestCase

  def setup
    @basic_user = <<DATA
    <?xml version="1.0" encoding="UTF-8"?>
    <user>
      <link_back>http://localhost/personas/cb79d21f</link_back>
      <credentials>
        <identities>
          <identity id="2">
            <first_name>Jason</first_name>
            <last_name>Amster</last_name>
            <middle_name></middle_name>
            <suffix></suffix>
            <verified_on>09/26/2007</verified_on>
            <source></source>
            <notes></notes>
          </identity>
        </identities>
        <educations>
          <education id="1">
            <school>Rutgers University</school>
            <major>Computer Science</major>
            <minor></minor>
            <start_date></start_date>
            <graduation_date>2003-06-01</graduation_date>
            <verified_on>09/15/2007</verified_on>
            <source></source>
            <notes> 
          </notes>
          </education>
        </educations>
        <work_experiences>
          <work_experience id="1">
            <organization>Redken/L'Oreal USA</organization>
            <title>Manager - Interactive Development</title>
            <start_date>2004-08-01</start_date>
            <end_date>2007-08-01</end_date>
            <verified_on>09/22/2007</verified_on>
            <source></source>
            <notes></notes>
          </work_experience>
          <work_experience id="2">
            <organization>BeenVerified.com</organization>
            <title>CTO</title>
            <start_date>2007-08-01</start_date>
            <end_date></end_date>
            <verified_on>10/31/2007</verified_on>
            <source></source>
            <notes></notes>
          </work_experience>
        </work_experiences>
      </credentials>
    </user>
DATA
    
    
    @empty_user = <<DATA
    <?xml version="1.0" encoding="UTF-8"?>
    <user>
      <link_back>http://localhost/personas/cb79d21f</link_back>
      <credentials>
        
      </credentials>
    </user>
DATA
    
    @basic_user = REXML::Document.new(@basic_user, {:compress_whitespace => %(credentials)})#file
    @empty_user = REXML::Document.new(@empty_user, {:compress_whitespace => %(credentials)})#file


  end
  
  def test_initialize
    user = BeenVerified::User.new(@basic_user)
    assert user
    
  end
  def test_basic_user
    user = BeenVerified::User.new(@basic_user)
    assert_equal 4, user.number_of_credentials
    assert_equal 2, user.work_experiences.size
    assert_equal 1, user.educations.size
    assert user.web_sites, nil
    assert_equal 'http://localhost/personas/cb79d21f', user.link_back
    assert user.identity
    
  end
  def test_credential_values
    user = BeenVerified::User.new(@basic_user)
    assert_equal "Jason Amster", user.identity.full_name
    assert_equal "Redken/L'Oreal USA", user.work_experiences.first[:organization]
    assert_equal Date, user.work_experiences.first.verified_on.class
    assert_equal '1', user.work_experiences.first.id
    assert_equal '2', user.work_experiences[1].id
    assert_equal 'Computer Science', user.educations[0].major
    assert_equal 'Computer Science', user.educations[0][:major]
  end

  
  def test_simple_user
    user = BeenVerified::User.new(@empty_user)
    assert_equal 0, user.number_of_credentials
    BeenVerified::CREDENTIALS.map{|type| type[1][:plural]}.each do |type|
      assert eval("user.#{type}.empty?")
    end
  end
end
