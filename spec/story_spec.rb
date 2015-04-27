require 'rspec'
require_relative 'spec_helper'
require_relative '../app/story'

describe Story do
  describe '#add story' do
    before do
      @valid_story = {  title:"test title",
                        user_id:1,
                        score:49,
                        contents:"testing testing"}
    end
    it 'executes a valid story without error' do
      expect(Story.add(@valid_story)).to_not raise_exception
    end

    it 'writes a valid story to the db' do
      q = "SELECT score FROM stories WHERE title = ?;"
      expect($db.execute(q, @valid_story[:title]).class).to eq(Array)
    end
  end
end
