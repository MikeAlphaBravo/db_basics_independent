class Project
  attr_reader(:title, :id)

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def self.all
    projects_array = []
    returned_projects = DB.exec("SELECT * FROM projects;")
    returned_projects.each do |project|
      title = project["title"]
      id = project["id"].to_i
      projects_array.push(Project.new({:title => title, :id => id}))
    end
    projects_array
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{title}') RETURNING id;")
    @id = result.first["id"].to_i
  end

  def ==(another_project)
    title.==(another_project.title).&(id.==(another_project.id))
  end

  # def id
  #
  # end

  def self.find(id)
    result = DB.exec("SELECT * FROM projects WHERE id = #{id};")
    title = result.first["title"]
    Project.new({:title => title, :id => id})
  end
end