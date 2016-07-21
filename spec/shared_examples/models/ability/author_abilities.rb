shared_examples_for "Author" do |author|
  if author
    it { should     be_able_to :update,     object, user: user }
    it { should_not be_able_to :vote_up,    object, user: user }
    it { should_not be_able_to :vote_down,  object, user: user }
    it { should_not be_able_to :vote_reset, object, user: user }
    it { should     be_able_to :destroy,    object, user: user }
  else
    it { should_not be_able_to :update,     object, user: user }
    it { should     be_able_to :vote_up,    object, user: user }
    it { should     be_able_to :vote_down,  object, user: user }
    it { should     be_able_to :vote_reset, object, user: user }
    it { should_not be_able_to :destroy,    object, user: user }
  end
end
