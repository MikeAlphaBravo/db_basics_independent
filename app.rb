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
  @projects = Project.all()
  erb(:projects)
end



get("/projects/:id") do
  @project = Project.find(params.fetch("id").to_i())
  @volunteers = Volunteer.all()
  erb(:project_info)
end
