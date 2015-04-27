require 'faker'
require_relative './app/db'

module RedditDB
	def self.reset
		drop
		create_tables
		seed
		tester
	end

	def self.drop
		puts "dropping..."
		drop_tables = <<-SQL
				DROP TABLE IF EXISTS users;
				DROP TABLE IF EXISTS stories;
				DROP TABLE IF EXISTS comments;
				DROP TABLE IF EXISTS replies;
			SQL
		$db.execute_batch(drop_tables)
	end

	def self.create_tables
		puts "creating_tables..."
		create_tables = <<-SQL
			CREATE TABLE IF NOT EXISTS 	users(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				user_name  	VARCHAR(64)		NOT NULL,
				email 	VARCHAR(64)			NOT NULL
				);

			CREATE TABLE IF NOT EXISTS 	stories(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				title  	VARCHAR(128)			NOT NULL,
				user_id	INT					NOT NULL,
				score 	INT					NOT NULL,
				contents	TEXT			NOT NULL,
				FOREIGN KEY(user_id) REFERENCES users(id)
				);

			CREATE TABLE IF NOT EXISTS 	comments(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				story_id	INT					NOT NULL,
				user_id	INT					NOT NULL,
				score 	INT					NOT NULL,
				contents	TEXT			NOT NULL,
				FOREIGN KEY(story_id) REFERENCES stories(id),
				FOREIGN KEY(user_id) REFERENCES users(id)
				);

			CREATE TABLE IF NOT EXISTS 	replies(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
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
		# $db.execute(".tables")
	end

	def self.seed
		puts "seeding..."
		populate_users = "INSERT INTO users(user_name, email)
											VALUES (?, ?);"
		populate_stories = "INSERT INTO stories(title, user_id, score, contents)
											VALUES (?, ?, ?, ?);"
		populate_comments = "INSERT INTO comments(story_id, user_id, score, contents)
											VALUES (?, ?, ?, ?);"
		populate_replies = "INSERT INTO replies(story_id, reply_id, user_id, score, contents)
											VALUES (?, ?, ?, ?, ?);"

		(1..10).each do |count|
			$db.execute(populate_users, [Faker::Name.first_name, Faker::Internet.free_email])
			$db.execute(populate_stories, [Faker::Lorem.sentence(10), rand(1..100),
																			rand(0..49), Faker::Lorem.paragraph(2)])
			$db.execute(populate_comments, [rand(1..100), rand(1..100), rand(1..20),
																				Faker::Lorem.paragraph(1)])
			$db.execute(populate_replies, [(count%2 === 0) ? rand(1..100) : nil,
																			(count%2 === 0) ? nil : rand(1..100),
																			rand(1..100), rand(1..12), Faker::Lorem.paragraph(1)])
		end
	end

	def self.tester
		puts "testing..."
		puts "tables populated! ready to go" if $db.execute("SELECT user_name FROM users LIMIT 5").length == 5
	end
end

RedditDB.reset
