require "./list"

class ListAccessPermission < Orma::Record
  id_column id : Int64
  column list_id : Int64
  column session_id : String
  column name : String?
  column created_at : Time?

  def list
    List.where(id: list_id).first
  end

  model_template :set_name_form do
    return if name

    div style: "padding:16px; background-color:rgba(255,230,180,0.5); line-height:1.8;" do
      span style: "margin-right:5px;" do
        "Let others know your name:"
      end
      set_name_action_template(ctx).to_html
    end
  end

  model_template :members_row do
    stimulus_controller NameEditorController do
      targets :form

      action :show do
        this.formTarget.hidden = false
      end
    end

    div NameEditorController do
      Crumble::Material::ListItem.to_html do
        div style: "display:flex; gap:8px; align-items:center;" do
          Crumble::Material::Icon.new("account_circle")

          if session_id == ctx.session.id.to_s
            button NameEditorController.show_action("click"), type: "button", style: "border:0; background:none; padding:0; font:inherit; text-align:left; cursor:pointer;" do
              if current_name = name
                current_name
              else
                i do
                  "Anonymous"
                end
              end
            end
          elsif current_name = name
            current_name
          else
            i do
              "Anonymous"
            end
          end
        end
      end

      if session_id == ctx.session.id.to_s
        div NameEditorController.form_target, hidden: true, style: "padding:0 16px 12px 48px;" do
          set_name_action_template(ctx).to_html
        end
      end
    end
  end

  model_action :set_name, {set_name_form, list.members_view} do
    before do
      unless model.session_id == ctx.session.id.to_s
        return 403
      end

      true
    end

    form do
      field name : String, allow_blank: false
    end

    controller do
      model.update(**form.values) if form.valid?
    end

    view do
      template do
        form action: action.uri_path, method: "POST", style: "display:flex; gap:8px; align-items:center;" do
          input type: :text, name: "name", value: action.model.name
          button type: "submit" do
            "Save"
          end
        end
      end
    end
  end
end
