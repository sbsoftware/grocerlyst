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
    unless name
      div class: "set-name-intro-container" do
        span class: "set-name-intro-caption" do
          "Let others know your name:"
        end
        set_name_action_template(ctx).to_html
      end
    end
  end

  model_template :members_row do
    if session_id == ctx.session.id.to_s
      toggle_id = "list-member-edit-toggle-#{id.value}"

      div class: "list-member-editor" do
        input type: "checkbox", id: toggle_id, class: "list-member-edit-toggle"
        label class: "list-member-edit-trigger", for: toggle_id do
          Crumble::Material::ListItem.to_html do
            div class: "list-member-row" do
              Crumble::Material::Icon.new("account_circle")

              if current_name = name
                span class: "own-list-member-name" do
                  current_name
                end
              else
                i do
                  "Anonymous"
                end
              end
            end
          end
        end

        div class: "list-member-edit-form-container" do
          set_name_action_template(ctx).to_html
        end
      end
    else
      Crumble::Material::ListItem.to_html do
        div class: "list-member-row" do
          Crumble::Material::Icon.new("account_circle")

          if current_name = name
            current_name
          else
            i do
              "Anonymous"
            end
          end
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
      css_class Form

      template do
        form Form, action: action.uri_path, method: "POST" do
          input type: :text, name: "name", value: action.model.name
          button type: "submit" do
            "Save"
          end
        end
      end

      style do
        rule ".set-name-intro-container" do
          padding 16.px
          background_color rgb(255, 230, 180, alpha: 0.5)
          line_height 1.8
        end

        rule ".set-name-intro-caption" do
          margin_right 5.px
        end

        rule ".list-member-row" do
          display :flex
          gap 8.px
          align_items :center
        end

        rule ".own-list-member-name" do
          text_decoration :underline
        end

        rule ".list-member-edit-trigger" do
          cursor :pointer
          display :block
        end

        rule ".list-member-edit-toggle" do
          display :none
        end

        rule ".list-member-edit-form-container" do
          display :none
        end

        rule ".list-member-edit-form-container" do
          padding_top 0.px
          padding_right 16.px
          padding_bottom 12.px
          padding_left 48.px
        end

        rule ".list-member-editor > .list-member-edit-toggle:checked + .list-member-edit-trigger + .list-member-edit-form-container" do
          display :block
        end

        rule Form do
          display :flex
          gap 8.px
          align_items :center
        end
      end
    end
  end
end
