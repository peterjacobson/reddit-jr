require 'rspec'
require_relative 'spec_helper'
require_relative '../app/story'

describe Story do

  @valid_story = {  title: "test title",
                    user_id: 1,
                    score: 49,
                    contents: "testing testing"}
  @title_query = "SELECT score FROM stories WHERE title = ?;"

  # describe '#delete story' do
  #   it 'deletes all stories with passed title' do
  #     Story.add(@valid_story)
  #     Story.delete(@valid_story[:title])
  #     expect($db.execute(@title_query, @valid_story[:title]).size).to be 0
  #   end
  # end
  #
  # describe '#add story' do
  #   it 'writes a valid story to the db' do
  #     Story.add(@valid_story)
  #     expect($db.execute(@title_query, @valid_story[:title]).size).to be > 0
  #     Story.delete(@valid_story[:title])
  #   end
  # end
end
