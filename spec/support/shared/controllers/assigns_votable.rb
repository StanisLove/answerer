shared_examples_for 'Assignable' do |action|
  name = described_class.controller_name.singularize

  it "assigns the request to @#{name}" do
    do_request(action)
    expect(assigns(:votable)).to eq object
  end
end
