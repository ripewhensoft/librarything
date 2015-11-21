require 'sinatra'
require 'gdbm'

# gdbm = GDBM.new("")

users = {'admin' => 'pass', 'admin2' => 'pass2'}
usrclaim = {} #container for what was entered in boxes
saying = ['The violent plunger says "Heyoooo".', 'Betsy dont play like that.', 'That boy aint right.']
randomsaying = saying.sample

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
    return 'Hello world'
end

get '/hello/' do
    erb :hello_form
end

post '/hello/' do
    usr = params[:usr] 
    pass = params[:pass]

    usrclaim[usr] = pass
    usrcheck = users.select { |k,v| k == usr }
    puts usrcheck
    if usrcheck == usrclaim then
    	puts "youdidit"
    	'success'
    else
    	erb :failed, :locals => {'randomsaying' => randomsaying}
    end

end