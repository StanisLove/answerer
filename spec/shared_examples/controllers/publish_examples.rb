shared_examples "publishable" do |model|
  it "publishes #{model} to PrivatePub" do
    expect(PrivatePub).to receive(:publish_to)
    subject
  end
end

shared_examples "unpublishable" do |model|
  it "does not publish #{model} to PrivatePub" do
    expect(PrivatePub).not_to receive(:publish_to)
    subject
  end
end
