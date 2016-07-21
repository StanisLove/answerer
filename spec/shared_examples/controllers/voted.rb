shared_examples_for 'Voted' do

  name = described_class.controller_name.singularize

  describe 'PATCH #vote_up!' do
    it_behaves_like 'Assignable', :vote_up

    it "increase #{name}'s votes only once" do
      expect{ do_request(:vote_up) }.to change(object, :voting_result).by(1)
      expect{ do_request(:vote_up) }.to change(object.votes, :count).by(0)
    end
  end

  describe 'PATCH #vote_down' do
    it_behaves_like 'Assignable', :vote_down

    it "decrease #{name}'s votes only once" do
      expect{ do_request(:vote_down) }.to change(object, :voting_result).by(-1)
      expect{ do_request(:vote_down) }.to change(object.votes, :count).by(0)
    end
  end

  describe 'PATCH #vote_reset' do
    let!(:vote)  { create(:vote_up, user_id: user.id, votable: object) }

    it_behaves_like 'Assignable', :vote_reset

    it "cancel user vote for #{name}" do
      expect(object.voting_result).to eq 1
      expect{ do_request(:vote_reset) }.to change(object, :voting_result).by(-1)
    end
  end

  def do_request(action)
    patch action, id: object, format: :json
  end
end
