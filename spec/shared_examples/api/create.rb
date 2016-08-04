shared_examples_for "API Creatable" do
  object_name = metadata[:full_description].split.first.singularize

  context 'unauthorized' do
    context 'there is no acess_token' do
      it "does not create the #{object_name}" do
        expect { do_request }.not_to change(model, :count)
      end
    end

    context 'acess_token is invalid' do
      it "does not create the #{object_name}" do
        expect { do_request(access_token: '1234') }.not_to change(model, :count)
      end
    end
  end

  context 'authorized' do
    let(:name) { model.model_name.singular }

    context 'with valid params' do
      it "user creates the #{object_name}" do
        expect do
          do_request(access_token: access_token.token)
        end.to change(user.send(name.pluralize.to_sym), :count).by(1)
      end

      it 'returns 201 status' do
        do_request(access_token: access_token.token)
        expect(response.status).to eq 201
      end
    end

    context 'with invalid params' do
      it "does not create the #{object_name}" do
        expect do
          do_request(name.to_sym => attributes_for("invalid_#{name}".to_sym),
                     :access_token => access_token.token)
        end.not_to change(model, :count)
      end

      it 'returns 422 status' do
        do_request(name.to_sym => attributes_for("invalid_#{name}".to_sym),
                   :access_token => access_token.token)
        expect(response.status).to eq 422
      end
    end
  end
end
