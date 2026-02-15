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
    css_class IntroContainer
    css_class IntroCaption

    return if name

    div IntroContainer do
      span IntroCaption do
        "Let others know your name:"
      end
      set_name_action_template(ctx).to_html
    end

    style do
      rule IntroContainer do
        padding 16.px
        background_color rgb(255, 230, 180, alpha: 0.5)
        line_height 1.8
      end

      rule IntroCaption do
        margin_right 5.px
      end
    end
  end

  model_template :members_row do
    css_class MemberRow
    css_class OwnNameButton
    css_class EditFormContainer

    stimulus_controller NameEditorController do
      targets :form

      action :show do
        this.formTarget.hidden = false
      end
    end

    div NameEditorController do
      Crumble::Material::ListItem.to_html do
        div MemberRow do
          Crumble::Material::Icon.new("account_circle")

          if session_id == ctx.session.id.to_s
            button OwnNameButton, NameEditorController.show_action("click"), type: "button" do
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
        div EditFormContainer, NameEditorController.form_target, hidden: true do
          set_name_action_template(ctx).to_html
        end
      end
    end

    style do
      rule MemberRow do
        display :flex
        gap 8.px
        align_items :center
      end

      rule OwnNameButton do
        border 0
        background :none
        padding 0
        property("font", "inherit")
        text_align :left
        cursor :pointer
      end

      rule EditFormContainer do
        padding_top 0.px
        padding_right 16.px
        padding_bottom 12.px
        padding_left 48.px
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
        rule Form do
          display :flex
          gap 8.px
          align_items :center
        end
      end
    end
  end
end
