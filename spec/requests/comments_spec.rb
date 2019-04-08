require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)  #create the user
    @article = FactoryBot.create(:article) #create the article


    visit root_path
    expect(current_path).to eq(new_user_session_path)
    expect(current_path).to_not eq(root_path)

    within('#new_user') do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end

    #after logged in, check if the application redirect us to the right path
    expect(current_path).to eq(root_path)
    expect(current_path).to_not eq(new_user_session_path)
    expect(page).to have_content('Signed in successfully')
  end

  #Testing valid Index
  describe 'GET #index' do
     describe 'valid: ' do
        it 'should return a list of comments' do
          @comment = FactoryBot.create(:comment, article: @article)
          click_link 'comments'
          expect(current_path).to eq(comments_path)
          expect(page).to have_content(@comment.message)
        end
    end
  end

  #Testing valid and invalid show
  describe 'GET #show' do
    describe 'valid: ' do
      it 'should return a comment' do
        @comment = FactoryBot.create(:comment, article: @article)
        click_link 'comments'
        expect(current_path).to eq(comments_path)
        expect(page).to have_content(@comment.message)

        click_link "Show"
        expect(page).to have_content(@comment.message)
        expect(page).to have_content(@comment.article.title)
        expect(page).to have_content(@comment.user.email)
      end
    end
    describe 'invalid: ' do
      it 'should not return a comment if it doesn not exist' do
        visti comment_parth(99999)
        expect(current_path).to eq(comments_path)
        expect(page).to have_content("The comment you're looking for cannot be found")
      end
    end
  end

  #Testing valid and invalid New
  describe 'GET #new' do
    describe 'valid: ' do
      it 'should create a new comment' do
        click_link "comments"
        expect(current_path).to eq(comments_path)

        click_link "New Comment"
        expect(current_path).to eq(new_comment_path)
        fill_in 'comment_message', with: 'New_Message'
        select @article.title, from: 'comment[article_id]'
        click_button 'create comment'
        expect(page).to have_content('Comment was successfully created')
        expect(page).to have_content('New Message')
        expect(page).to have_content('@user.email')
      end
    end

    describe 'invalid: ' do
      it 'should not create a new comment' do
        click_link 'comments'
        expect(current_path).to eq(comments_path)
        click_link 'New Comment'
        expect(current_path).to eq(new_comment_path)
        fill_in 'comment_message', with: ''
        select @article.title, from: 'comment[article_id]'
        click_button 'Create Comment'
        expect(page).to have_content("Message can not be blank")
      end
    end
  end

  # Testing valid and invalid Edit
  describe 'GET #edit' do
    describe 'valid: ' do
      it 'should updatean comment with valid attributes' do
        @comment = FactoryBot.create(:comment, aricle: @article)
        click_link 'comments'
        expect(current_path).to eq(comments_path)
        expect(page).to have_content(@comment.message)

        click_link 'Show'
        expect(current_path).to eq(comment_path(@comment))
        expect(page).to have_content(@comment.message)
        expect(page).to have_content(@comment.article.title)
        expect(page).to have_content(@comment.user.email)
        @new_user = FactoryBot.create(:user)
        @new_article = FactoryBot.create(:article)

        click_link 'Edit'
        expect(current_path).to eq(edit_comment_path(@comment))
        fill_in 'comment_message', with: 'Edited_Comment_Message'
        select @new_article.title, from: 'comment[article_id]'
        select @new_user.email, from: 'comment[user_id]'

        click_button 'Update Comment'
        expect(page).to have_content('Comment was successfully updated.')
        expect(page).to have_content('Edited_Comment_Message')
        expect(page).to have_content(@new_user.email)
        expect(page).to have_content(@new_article.title)
        expect(current_path).to eq(comment_path(@comment))
      end
    end

    describe 'invalid: 'do
      it 'should not update an comment' do
        @comment = FactoryBot.create(:comment, article: @article)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)
        expect(page).to have_content(@comment.message)

        click_link 'Show'
        expect(current_path).to eq(comments_path(@comment))
        expect(page).to have_content(@comment.message)
        expect(page).to have_content(@comment.article.title)
        expect(page).to have_content(@comment.user.email)

        click_link 'Edit'
        expect(current_path).to eq(edit_comment_path(@comment))
        fill_in 'comment_message', with: ''
        select @article.title, from: 'comment[article_id]'
        select @user.email, from: 'comment[user_id]'
        click_button 'Update Comment'
        expect(page).to have_content("Message can't be blank")
      end
    end
  end

  # Testing Valid Destroy
  describe 'GET #destroy' do
    describe 'valid: ' do
      it 'should destroy an comment' do
        @comment = FactoryBot.create(:comment)
        click_link 'Comments'
        expect(current_path).to eq(comments_path)
        expect(page).to have_content(@comment.message)

        click_link 'Destroy'
        expect(current_path).to eq(comments_path)
        expect(page).to have_content("Comment was successfully destroyed.")
      end
    end
  end

  describe "GET /comments" do
    it "works! (now write some real specs)" do
      get comments_path
      expect(response).to have_http_status(200)
    end
  end
end
