
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;


PRAGMA foreign_keys = ON;
-- This statement makes sqlite3 actually respect
--the foreign key constraints you've added in your CREATE TABLE statements.


CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
    );

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    users_id INTEGER NOT NULL,
    FOREIGN KEY (users_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL,
    FOREIGN KEY (users_id) REFERENCES users(id),
    FOREIGN KEY (questions_id) REFERENCES questions(id)
);


CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    body INTEGER NOT NULL, --  question id
    user_reply_id INTEGER NOT NULL, --user_Id
    parents_id INTEGER, -- index of table

    FOREIGN KEY (body) REFERENCES questions(id)
    FOREIGN KEY (parents_id) REFERENCES replies(id)

);

CREATE TABLE question_likes(
id INTEGER PRIMARY KEY,
user INTEGER NOT NULL,
question INTEGER NOT NULL,

FOREIGN KEY (user) REFERENCES users(id),
FOREIGN KEY (question) REFERENCES questions(id)

);


INSERT INTO
question_likes(user,question)

VALUES
(1,1);


INSERT INTO
replies(body,user_reply_id)
VALUES
(1,1);


INSERT INTO
    users(fname,lname)
    VALUES
    ('Sara','Ryu'),
    ('Shan','Kim');

INSERT INTO
  questions(title, body, users_id)
VALUES
  ("what is 1 + 1 ?","first grade math", (SELECT id FROM users WHERE fname = 'Sara')),
  ("what is 2 x 2 ?","2nd grade math", (SELECT id FROM users WHERE fname = 'Shan'));


INSERT INTO
question_follows(questions_id, users_id)
VALUES
  (1, 1),
  (2, 2);

