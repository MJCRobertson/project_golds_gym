require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative("./controllers/activities_controller")
require_relative("./controllers/members_controller")
require_relative("./controllers/bookings_controller")
also_reload("./models/*")

get '/' do
  erb( :"homepage/homepage" )
end
