require_relative 'db'

class Story
	def self.add(args)
		q = <<-SQL
				INSERT INTO stories(title, user_id, score, contents)
				VALUES (?, ?, ?, ?);
				SQL
		$db.execute(q, [args[:title],
										args[:user_id],
										args[:score], 
										args[:contents]])
	end
end
