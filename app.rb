require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
also_reload('lib/**/*.rb')
require('pg')
require('pry')

DB = PG.connect({:dbname => "volunteer_tracker_test"})

get("/") do
  @projects = Project.all()
  erb(:projects)
end

post("/projects") do
  title = params["title"]
  project = Project.new({:title => title, :id => nil})
  project.save()
  redirect '/'
end

post("/projects/:id/volunteers") do
  find_project
  name = params["name"]
  volunteer = Volunteer.new({:name => name, :project_id => @project.id})
  volunteer.save()
  redirect "/projects/#{@project.id}"
end

get("/projects/:id") do
  find_project
  binding.pry
  erb(:project_info)
end

get("/projects/:id/edit") do
  find_project
  erb(:project_edit)
end

post("/projects/:id/update") do
  find_project
  title = params["title"]
  @project.update({:title => title, :id => @project.id})
  redirect "/projects/#{@project.id}"
end

post("/projects/:id/delete") do
  find_project
  @project.delete
  redirect "/"
end

get("/volunteers/:id") do

end

def find_project
  @project = Project.find(params.fetch("id").to_i)
end
