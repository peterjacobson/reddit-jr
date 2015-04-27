require 'sqlite3'
require 'faker'

$db = SQLite3::Database.new('reddit.sqlite')

create_tables = <<-SQL

	CREATE TABLE IF NOT EXISTS 	users(
		id		INT PRIMARY KEY 	NOT NULL,
		user_name  	VARCHAR(64)		NOT NULL,
		email 	VARCHAR(64)			NOT NULL		
		);

	CREATE TABLE IF NOT EXISTS 	stories(
		id		INT PRIMARY KEY 	NOT NULL,
		title  	VARCHAR(128)			NOT NULL,
		user_id	INT					NOT NULL,
		score 	INT					NOT NULL,
		contents	TEXT			NOT NULL,
		FOREIGN KEY(user_id) REFERENCES users(id)
		);

	CREATE TABLE IF NOT EXISTS 	comments(
		id		INT PRIMARY KEY 	NOT NULL,		
		story_id	INT					NOT NULL,
		user_id	INT					NOT NULL,
		score 	INT					NOT NULL,
		contents	TEXT			NOT NULL,
		FOREIGN KEY(story_id) REFERENCES stories(id),
		FOREIGN KEY(user_id) REFERENCES users(id)
		);

	CREATE TABLE IF NOT EXISTS 	replies(
		id		INT PRIMARY KEY 	NOT NULL,		
		story_id	INT,
		reply_id	INT,
		user_id	INT,
		score 	INT					NOT NULL,
		contents	TEXT			NOT NULL,
		FOREIGN KEY(story_id) REFERENCES stories(id),
		FOREIGN KEY(reply_id) REFERENCES replies(id),
		FOREIGN KEY(user_id) REFERENCES users(id)
		);

	SQL

$db.execute_batch(create_tables)

populate_users = "INSERT INTO users(id, user_name, email) 
									VALUES (?, ?, ?);"
populate_stories = "INSERT INTO stories(id, title, user_id, score, contents) 
									VALUES (?, ?, ?, ?, ?);"
populate_comments = "INSERT INTO comments(id, story_id, user_id, score, contents) 
									VALUES (?, ?, ?, ?, ?);"
populate_replies = "INSERT INTO replies(id, story_id, reply_id, user_id, score, contents) 
									VALUES (?, ?, ?, ?, ?, ?);"

(3..100).each do |count|
	$db.execute(populate_users, [count, Faker::Name.first_name, Faker::Internet.free_email])
	$db.execute(populate_stories, [count, Faker::Lorem.sentence(10), rand(1..100), 
																	rand(0..49), Faker::Lorem.paragraph(2)])
	$db.execute(populate_comments, [count, rand(1..100), rand(1..100), rand(1..20), 
																		Faker::Lorem.paragraph(1)])
	$db.execute(populate_replies, [count, (count%2 === 0) ? rand(1..100) : nil, 
																	(count%2 === 0) ? nil : rand(1..100), 
																	rand(1..100), rand(1..12), Faker::Lorem.paragraph(1)])

end