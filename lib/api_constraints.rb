# To make use of the matches? constraint, send an 'Accept' header as follows:
# curl -H 'Accept: application/example-mobile-pns.v1' http://localhost:3000/api/users
#
# Credit goes to Ryan Bates: http://railscasts.com/episodes/350-rest-api-versioning?view=asciicast
class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end
    
  def matches?(req)
    @default || req.headers['Accept'].include?("application/toddler.v#{@version}")
  end
end