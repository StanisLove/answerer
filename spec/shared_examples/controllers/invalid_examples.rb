shared_examples "invalid params" do |model|
  if model
    it "does not save the new #{model} into DB" do
      expect { subject }.not_to change(model, :count)
    end
  end
end
