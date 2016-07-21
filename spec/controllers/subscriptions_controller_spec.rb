require 'rails_helper'

RSpec.describe SubscriptionsController, :auth, type: :controller do
  let!(:question) { create :question }

  describe 'POST #create' do
    it 'creates subscription in DB' do
      expect { post :create, question_id: question, format: :js }.
          to change(user.subscriptions,     :count).by(1).
         and change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    before { create :subscription, user: user, question: question }

    it 'destroys subscription in DB' do
      expect { delete :destroy, question_id: question, format: :js }.
          to change(user.subscriptions,     :count).by(-1).
         and change(question.subscriptions, :count).by(-1)
    end
  end

  context 'User is not signed in', :unauth do
    describe 'POST #create' do
      it 'does not create subscription in DB' do
          expect { post :create, question_id: question, format: :js }.
          to_not change(Subscription, :count)
      end
    end

    describe 'DELETE #destroy' do
      before { create :subscription, question: question }

      it 'does not destroy subscription in DB' do
          expect { delete :destroy, question_id: question, format: :js }.
          to_not change(Subscription, :count)
      end
    end
  end
end
