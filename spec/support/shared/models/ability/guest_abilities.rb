shared_examples_for "Guestable" do
  it { should     be_able_to :read,   :all }
  it { should_not be_able_to :manage, :all }
end
