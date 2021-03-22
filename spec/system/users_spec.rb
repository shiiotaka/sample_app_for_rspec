require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) {create(:user)}
  let(:task) {create(:task)}

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規登録が成功する' do
          visit sign_up_path
          
          fill_in 'Email', with: 'test@test.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'

          expect(current_path).to eq login_path
          expect(page).to have_content "User was successfully created."
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'

          expect(current_path).to eq users_path
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
  
          expect(current_path).to eq users_path
          expect(page).to have_content "Email has already been taken"
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)

          expect(current_path).to eq login_path
          expect(page).to have_content "Login required"
        end
      end
    end
  end

  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit login_path
          login(user)
          visit user_path(user)
          click_on 'Edit'
          fill_in 'Email', with: 'test@test.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Update'

          expect(current_path).to eq user_path(user)
          expect(page).to have_content "User was successfully updated."
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit login_path
          login(user)
          visit user_path(user)
          click_on 'Edit'
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Update'

          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '登録済のメールアドレスを使用' do
        before do
          @user = User.new(email: "test@gmail.com", password: "password", password_confirmation: "password")
          @user.save
        end
        it 'ユーザーの編集が失敗する' do
          visit login_path
          login(user)
          visit user_path(user)
          click_on 'Edit'
          fill_in 'Email', with: @user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'Update'

          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email has already been taken"
        end
      end

      context '他ユーザーの編集ページのアクセス' do
        before do
          @user = User.new(email: "test@gmail.com", password: "password", password_confirmation: "password")
          @user.save
        end

        it '編集ページへのアクセスが失敗する' do
          visit login_path
          login(user)
          visit edit_user_path(@user)

          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Forbidden access."
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        # before do
        #   @task = Task.new(title: "test", content: "content", status: :todo, deadline: 1.week.from_now)
        #   @task.save
        # end
        it '新規作成したタスクが表示される' do
          visit login_path
          login(user)
          click_on 'New task'
          fill_in 'Title', with: 'title'
          fill_in 'Content', with: task.content
          select task.status, from: 'Status'
          fill_in 'Deadline', with: task.deadline
          click_button 'Create Task'
          
          # expect(current_path).to eq task_path(task)
          
          save_and_open_page
          expect(page).to have_content "Task was successfully created."
        end
      end
    end
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
end
