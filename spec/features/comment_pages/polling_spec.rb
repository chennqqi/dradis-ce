require 'rails_helper'

describe 'comment pages', js: true do
  include ActivityMacros

  subject { page }

  shared_examples 'a commentable page with poller' do
    describe 'and someone else adds a comment' do
      before do
        @new_comment = create(:comment, commentable: @commentable, user: @other_user)
        track_created(@new_comment, @other_user)
        call_poller
      end

      it 'displays the new comment' do
        within('.comment-list') do
          expect(page).to have_selector("#comment_#{@new_comment.id}") # , visible: :all)
        end
      end
    end

    describe 'and someone else updates a comment' do
      before do
        @comment.update_attributes(content: 'content updated')
        track_updated(@comment, @other_user)
        call_poller
      end

      it 'displays the updated comment' do
        within('.comment-list') do
          expect(page).to have_text('content updated')
        end
      end
    end

    describe 'and someone else deletes a comment' do
      before do
        @comment.destroy
        track_destroyed(@comment, @other_user)
        call_poller
      end

      it 'removes the deleted comment' do
        within('.comment-list') do
          expect(page).not_to have_selector("#comment_#{@comment.id}")
        end
      end
    end

  end

  before do
    login_to_project_as_user
    @other_user = create(:user)
  end

  describe 'when I am viewing an Issue' do
    before do
      @commentable = create(:issue)
      @comment = create(:comment, commentable: @commentable, user: @other_user)
      visit project_issue_path(@project, @commentable)
    end

    it_behaves_like 'a commentable page with poller'
  end
end