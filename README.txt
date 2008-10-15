=  beenverified

http://beenverified.rubyforge.net/

== VERSION: 0.1.0

== DESCRIPTION:

BeenVerified is a web service designed to build trust into the meetings
and interactions that take place on websites and online communities. 
Built using the OAuth protocol and with a focus on keeping the user in 
complete control of their data, the BeenVerified API allows users to 
present third-party, verified information about themselves within your 
application. That verified user data (such as their identity and 
credentials) can then be integrated directly into your application's 
look and feel, providing a more trustworthy user experience for 
everyone.

== INSTALL:

  sudo gem install beenverified

== FEATURES/PROBLEMS:

* Wraps OAuth authentication
* Wraps XML responses into a User object
* User object has control of a hash of Credential objects

== DEVELOPER KEY:

Before you can access data from the BeenVerified Library, you must obtain a developer key at: 
http://www.beenverified.com/developer/new?d=t

== USAGE:

Three Steps

  
==== 1) Obtaining a request token & sending user to Auth[sz]

  >> require 'beenverified  
  >> client = BeenVerified::Client.new( :consumer_key    => "consumer_key",
                                     :consumer_secret => "consumer_secret")               
  >> request_token = client.get_request_token

  #save your request_token data to your database
  #send user to request_token.authorize_url  
  #User comes back to app to notify of authorization 
  #(in a web flow it would be a redirect to the callback URL)
  
==== 2) Getting the access token

  >> client = BeenVerified::Client.new( :consumer_key    => "consumer_key",
                                      :consumer_secret => "consumer_secret",
                                      :request_token        => "request_token",
                                      :request_token_secret => "request_token_secret")
  >> access_token = client.convert_to_access_token
  
  #save access_token data to your database

==== 3) Accessing BeenVerified Resources

  >> user = BeenVerified::Client.new( :consumer_key    => "consumer_key",
                                      :consumer_secret => "consumer_secret",
                                      :access_token        => "access_token",
                                      :access_token_secret => "access_token_secret").user
  
=> <BeenVerified::User:0x02cf909 ...>

  #showing a users full name if they are sharing it
  >> user.identity.full_name if user.identity
  => "Jason Amster"
  
  #showing the name of the organization where a user worked
  >> user.work_experiences[0].organization if user.work_experiences[0].size > 0
  => "BeenVerified"
  
  #showing the date the work_experience credential was verified
  user.work_experiences[0].verified_on
  
  #displaying the raw xml of a user
  >> user.raw_xml
  =>  <?xml version="1.0" encoding="UTF-8"?>
  	<user>
  		<link_back>http://localhost/personas/cb79d21f</link_back>
  		<credentials>
  			...
  		</credentials>
  	</user>

== REQUIREMENTS:

	* oauth
	* net/https
	* activesupport

   
== SUPPORT:
 Please direct any questions or comments to the BeenVerified API Google Group (http://groups.google.com/group/beenverified-api).

	Contact Info
	Jason Amster
	E: jayamster at gmail dot com
	AIM: bvjamster


If you want to submit any patches please read Dr. Nic's 8 steps for fixing other people's code (http://drnicwilliams.com/2007/06/01/8-steps-for-fixing-other-peoples-code/).  For step 8, please utilize 8b or 8z (submit patch to google gropus, or email project owner jayamster at gmail dot com, respectively))


ACKNOWLEDGEMENTS:
Special thanks to the OAuth Group for coming up with the protocol and for those who wrote the OAuth Ruby Library which this library sits on top of.

Also, thanks to Jesse Newland who wrote the FireEagle Ruby Library, which was used as an excellent template in building out this library.  



== LICENSE:

(The MIT License)

Copyright (c) 2008 BeenVerified

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
