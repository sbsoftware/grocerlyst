require "./list"

class ListAccessPermission < Orma::Record
  id_column id : Int32?
  column list_id : Int32?
  column session_id : String?
  column name : String?
  column created_at : Time?

  def list
    List.where({"id" => list_id}).first
  end

  model_template :set_name_form do
    set_name_action_template.to_html unless name
  end

  model_action :set_name, set_name_form do
    NAME_FIELD = "name"

    before do
      unless model.session_id == ctx.session.id.to_s
        return 403
      end

      true
    end

    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      new_name = nil
      HTTP::Params.parse(body.gets_to_end) do |key, value|
        case key
        when NAME_FIELD
          new_name = value
        end
      end

      model.update(name: new_name) if new_name && new_name.size.positive?
    end

    class Template
      getter uri_path : String

      def initialize(@uri_path); end

      css_class Wrapper
      css_class Caption
      css_class Button

      ToHtml.instance_template do
        div Wrapper do
          span Caption do
            "Sag' den anderen, wie du heißt:"
          end
          form action: uri_path, method: "POST" do
            input type: :text, name: NAME_FIELD, required: true
            button Button do
              "OK"
            end
          end
        end
      end

      style do
        rule Wrapper do
          padding 16.px
          backgroundColor "rgba(255, 230, 180, 0.5)"
          prop("line-height", 1.8)
        end

        rule Caption do
          marginRight 5.px
        end

        rule Wrapper > form do
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

    def self.action_template(model)
      Template.new(self.uri_path(model.id))
    end
  end
end
