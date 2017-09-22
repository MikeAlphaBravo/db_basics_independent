class Volunteer
  attr_reader(:name, :project_id, :id)

  def initialize(attributes)
    @name = attributes[:name]
    @project_id = attributes[:project_id]
    @id = attributes[:id]
  end

  def self.all
    volunteers_array = []
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    returned_volunteers.each do |volunteer|
      name = volunteer["name"]
      project_id = volunteer["project_id"]
      id = volunteer["id"].to_i
      volunteers_array.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    volunteers_array
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{name}', #{project_id}) RETURNING id, project_id;")
    @id = result.first["id"].to_i
    @project_id = result.first["project_id"].to_i
  end

  def ==(another_volunteer)
    name.==(another_volunteer.name).&(id.==(another_volunteer.id))
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM volunteers WHERE id = #{id};")
    name = result.first["name"]
    project_id = result.first["project_id"].to_i
    id = result.first["id"].to_i
    Volunteer.new({:name => name, :project_id => project_id, :id => id})
  end

end
