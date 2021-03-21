require 'rails_helper'

RSpec.describe Task, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  describe 'バリデーション' do
    it '全ての属性があれば有効な状態であること' do
      expect(FactoryBot.build(:task)).to be_valid
    end

    it 'タイトルがなければ無効な状態であること' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it 'ステータスがなければ無効な状態であること' do
      task = Task.new(status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end

    it '重複したタイトルが無効な状態であること' do
      FactoryBot.create(:task, title: 'title')
      task = FactoryBot.build(:task, title: 'title')
      task.valid?
      expect(task.errors[:title]).to include('has already been taken')
    end

    it 'タイトルが重複してなければ有効な状態であること' do
      FactoryBot.create(:task, title: 'title')
    end
  end
end
