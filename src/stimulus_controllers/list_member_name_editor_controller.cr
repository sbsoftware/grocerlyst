class ListMemberNameEditorController < Stimulus::Controller
  targets :form

  action :show do
    this.formTarget.hidden = false
  end
end
