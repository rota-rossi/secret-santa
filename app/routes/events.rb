
get '/events' do
  @message = session[:message]
  check_login
  # binding.pry
  @events = find_events(@user)
  erb :'events/index'
end

get '/events/new' do
  check_login
  @event = Event.new
  erb :'events/new'
end

post '/events' do
  check_login
  @event = Event.new
  @event.event_name = params[:event_name]
  @event.event_description = params[:event_description]
  @event.start_date = params[:start_date]
  @event.registration_deadline = params[:registration_deadline]
  @event.event_date = params[:event_date]
  @event.public_event = params[:public_event]
  @event.max_participants = params[:max_participants]
  @event.min_value = params[:min_value]
  @event.max_value = params[:max_value]
  @event.creator = @user
  @event.city = @user.city
  @event.users << @event.creator ## ADDS The creator as a participant
  @event.save
  redirect '/events'
end

get '/events/:id' do
  check_login
  @event = Event.find(params[:id])
  # binding.pry
  erb :'events/details'
end

get '/events/:id/edit' do
  check_login
  @event = Event.find_by(id: params[:id], creator: @user)
  if @event.nil?
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    erb :'events/edit'
  end
end

put '/events/:id' do
  check_login
  @event = Event.find_by(id: params[:id], creator: @user)
  if @event.nil?  
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    @event = Event.find(params[:id])
    @event.event_name = params[:event_name]
    @event.event_description = params[:event_description]
    @event.start_date = params[:start_date]
    @event.registration_deadline = params[:registration_deadline]
    @event.event_date = params[:event_date]
    @event.public_event = params[:public_event]
    @event.max_participants = params[:max_participants]
    @event.min_value = params[:min_value]
    @event.max_value = params[:max_value]
    @event.creator = @user
    @event.city = @user.city
    @event.save
    redirect "/events/#{params[:id]}"
  end
end

delete '/events/:id' do
  check_login
  @event = Event.where(id: params[:id], creator: @user).first
  if @event.nil?  
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    @event.destroy
    redirect '/events'
  end
end


get '/events/:id/enroll' do
  check_login
  @events = find_events(@user).find(nil) {|event| event.id == params[:id].to_i}
    binding.pry
  if @events.nil?
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    @event = Event.find(params[:id])
    @event.users << @user
    @event.save
    redirect "/events/#{params[:id]}"
  end
end


