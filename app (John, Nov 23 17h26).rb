require 'sinatra'
require 'gdbm'



users = {'admin' => 'pass', 'admin2' => 'pass2'} #usr/pass combos
usrclaim = {} #login try
saying = ['The violent plunger says "Heyoooo".', 'Betsy dont play like that.', 'That boy aint right.'] #failure responses
randomsaying = saying.sample #grab random failure response
$usrid = "nil" #users username for the session
register = {}



set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"


get '/' do
    erb :hello_form
end

post '/workspace' do
  gdbm = GDBM.open("./users.db")
    usr = params[:usr] #get usr "name" from hello_form.erb
    pass = params[:pass]

    usrclaim[usr] = pass
    usrcheck = gdbm.select { |k, v| k == usr }
    puts usrcheck
    puts usrclaim
    if usrcheck == usrclaim then
    	usrclaim = {}
    	$usrid = usr
    	erb :success, :locals => {'usrcheck' => usrcheck}
    else
    	usrclaim = {}
    	erb :failed, :locals => {'randomsaying' => randomsaying}
      puts gdbm
    end
end

post '/save_image' do
  
  filename = params[:file][:filename]
  file = params[:file][:tempfile]

  File.open("./storage/#{filename}", 'wb') do |f|
    f.write(file.read)
  end
  erb :success
end

post '/chat' do
	msg = params[:usrinput]
	input = "#{$usrid}: #{msg}\n"
	File.open('./chat.txt', 'a') { |file| file.write(input) }
	erb :success
end

post '/register' do
  usreq = params[:usr]
  passreq = params[:pass]



    GDBM.open("./users.db") do |gdbm|
      usrcheck = gdbm.select { |k, v| k == usreq }
      
      if usrcheck.empty? == true then
        gdbm[usreq] = passreq
        $usrid = usreq
      else
        puts "choose another user/pass"
      end


  end
end