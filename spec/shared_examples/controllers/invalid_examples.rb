shared_examples "invalid params" do |model|
  if model
    it "does not save the new #{model} into DB" do
      expect{ subject }.to_not change(model, :count)
    end
  end
end
