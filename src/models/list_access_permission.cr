require "./list"

class ListAccessPermission < Orma::Record
  id_column id : Int64?
  column list_id : Int64?
  column session_id : String?
  column name : String?
  column created_at : Time?

  def list
    List.where({"id" => list_id}).first
  end

  model_template :set_name_form do
    set_name_action_template(ctx).to_html unless name
  end

  model_action :set_name, set_name_form do
    before do
      unless model.session_id == ctx.session.id.to_s
        return 403
      end

      true
    end

    form do
      field name : String
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      form = Form.from_www_form(body.gets_to_end)

      model.update(**form.values) if form.valid? && (new_name = form.name) && new_name.size.positive?
    end

    view do
      css_class Container
      css_class Caption
      css_class Button

      template do
        div Container do
          span Caption do
            "Sag' den anderen, wie du heißt:"
          end
          action_form.to_html do
            button Button do
              "OK"
            end
          end
        end
      end

      style do
        rule Container do
          padding 16.px
          backgroundColor "rgba(255, 230, 180, 0.5)"
          prop("line-height", 1.8)
        end

        rule Caption do
          marginRight 5.px
        end

        rule Container > form do
          display InlineBlock
        end

        rule Button do
          fontFamily "Roboto"
          padding 3.px
          marginLeft 5.px
          border 1.px, Solid, Black
        end
      end
    end
  end
end
