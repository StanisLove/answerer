shared_context "valid attrs", valid_attrs: true do
  let(:model)  { controller.controller_name.singularize.to_sym }
  let(:parent) { Hash.new }
  let(:form_params) { Hash.new }
  let(:format) { Hash[format: :json] }
  let(:params) { Hash[model => attributes_for(model).merge(form_params)].
                 merge(format).merge(parent) }
end

shared_context "invalid_attrs", invalid_attrs: true do
  let(:model)  { controller.controller_name.singularize.to_sym }
  let(:parent) { Hash.new }
  let(:form_params) { attributes_for ("invalid_" + model.to_s).to_sym }
  let(:format) { Hash[format: :html] }
  let(:params) { Hash[model => attributes_for(model).merge(form_params)].
                 merge(format).merge(parent) }
end

shared_context "updated_attrs", updated_attrs: true do
  let(:model)  { controller.controller_name.singularize.to_sym }
  let(:form_params) { attributes_for ("updated_" + model.to_s).to_sym }
end
