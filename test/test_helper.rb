require 'test/unit'
require File.dirname(__FILE__) + '/../lib/beenverified'

def requests(request)
  Marshal.load(File.read(File.dirname(__FILE__) + '/fixtures/' + request))
end

