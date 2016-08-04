require 'rails_helper'

shared_examples_for "attachable" do
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  it "#file" do
    expect(model.attachments.first.file.identifier).to eq "spec_helper.rb"
  end
end
