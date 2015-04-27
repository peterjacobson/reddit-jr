require 'rspec'
require_relative 'spec_helper'
require_relative '../app/story'

describe Story do

  before do
    @valid_story = {  title: "test title",
                      user_id: 1,
                      score: 49,
                      contents: "testing testing"}
    @title_query = "SELECT score FROM stories WHERE title = ?;"
    Story.add(@valid_story)
  end

  after do
    Story.delete(@valid_story[:title])
  end

  describe '#delete story' do
    it 'deletes all stories with passed title' do
      Story.delete(@valid_story[:title])
      expect($db.execute(@title_query, @valid_story[:title]).size).to be 0
    end
  end

  describe '#add story' do
    it 'writes a valid story to the db' do
      Story.add(@valid_story)
      expect($db.execute(@title_query, @valid_story[:title]).size).to be > 0
    end
  end
end
