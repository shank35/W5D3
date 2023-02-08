require "sqlite3"
require "singleton"

class UsersDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("users.db")
    self.type_translation = true #make sure that input type is same
    self.results_as_hash = true  #data come back as hash
  end
end

class Users
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    users = UsersDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM
    users
    WHERE
    id = ?
    SQL
    return nil unless users.empty?
    Users.new(users.first) #{[]} => []
  end

  def self.all
    data = UsersDatabase.instance.execute("SELECT * FROM users")
    data.map { |d| Users.new(d) }
  end

  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def create
    raise "#{self} already in database" if self.id
    UsersDatabase.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO
        users ( fname, lname)
      VALUES
        (?, ?, ? )
    SQL
    self.id = UsersDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" if self.id.nil?
    UsersDatabase.instance.execute(<<-SQL, self.fname, self.lname, self.id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end
end
