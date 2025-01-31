require_relative( '../db/sql_runner' )

class Activity

  attr_reader( :id, :activity_name, :day, :start_time, :duration, :capacity)

  def initialize ( options )
    @id = options['id'].to_i if options['id']
    @activity_name = options['activity_name']
    @day = options['day']
    @start_time = options['start_time']
    @duration = options['duration'].to_i
    @capacity = options['capacity'].to_i
  end

  def save()
    sql = "INSERT INTO activities
    (
      activity_name,
      day,
      start_time,
      duration,
      capacity
      )
      VALUES
      (
        $1, $2, $3, $4, $5
        )
        RETURNING id"
        values = [@activity_name, @day, @start_time, @duration, @capacity]
        results = SqlRunner.run(sql, values)
        @id = results.first()['id'].to_i
  end

  def update()
  sql = "UPDATE activities
  SET
  (
    activity_name,
    day,
    start_time,
    duration,
    capacity
  ) =
  (
    $1, $2, $3, $4, $5
  )
  WHERE id = $6"
  values = [@activity_name, @day, @start_time, @duration, @capacity, @id]
  SqlRunner.run( sql, values )
end

  def members()
    sql = "SELECT m.* FROM members m INNER JOIN bookings b on b.member_id = m.id WHERE b.activity_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |hash| Member.new( hash) }
  end

  def self.all()
    sql = "SELECT * FROM activities"
    results = SqlRunner.run( sql )
    return results.map { |activity| Activity.new( activity )}
  end

  def self.find( id )
    sql = "SELECT * FROM activities
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run( sql, values )
    return Activity.new( results.first )
  end

  def self.delete_all
    sql = "DELETE FROM activities"
    SqlRunner.run( sql )
  end

  def self.all_with_empty_spaces()
    activities = self.all()
    acitivites_with_spaces = activities.select {|activity| activity.capacity > activity.members.length() }
    return acitivites_with_spaces
  end

  def delete()
  sql = "DELETE FROM activities
  WHERE id = $1"
  values = [@id]
  SqlRunner.run( sql, values )
end

end
