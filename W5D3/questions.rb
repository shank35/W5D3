require "sqlite3"
require "singleton"

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("users.db")
    self.type_translation = true #make sure that input type is same
    self.results_as_hash = true  #data come back as hash
  end
end

class Questions
  attr_accessor :id, :title, :body, :users_id

  def self.find_by_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT *
    FROM
    questions
    WHERE
    id = ?
    SQL
    return nil unless questions.empty?
    Questions.new(questions.first) #{[]} => []
  end

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |d| Questions.new(d) }
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @users_id = options["users_id"]
  end

  def create
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.users_id)
      INSERT INTO
        questions ( title, body, users_id)
      VALUES
        (?, ?, ? )
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" if self.id.nil?
    QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.users_id, self.id)
      UPDATE
        questions
      SET
        title = ?, body = ?, users_id = ?
      WHERE
        id = ?
    SQL
  end
end
