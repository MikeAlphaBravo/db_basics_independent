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

  def volunteers
    project_volunteers = []
    volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    volunteers.each() do |volunteer|
      name = volunteer["name"]
      project_id = volunteer["project_id"].to_i
      id = volunteer["id"].to_i
      project_volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    project_volunteers
  end

  def update(attributes)
    title = attributes[:title]
    id = attributes[:id]
    DB.exec("UPDATE projects SET title = '#{title}' WHERE id = #{self.id};")
    @title = title
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id};")
  end
end
