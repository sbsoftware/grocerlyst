abstract class DeleteRecordAction < Crumble::ORM::Action
  module ClassMethods
    abstract def model_class
  end

  def model_class
    self.class.model_class
  end

  include ClassMethods

  class Form
    getter action : DeleteRecordAction

    def initialize(@action); end

    css_class DeleteRecordForm

    style do
      rule DeleteRecordForm do
        display None
      end
    end

    ToHtml.instance_template do
      form DeleteRecordForm, action: action.uri_path, method: "POST" do
        input DeleteActionController.submit_target, type: "submit"
      end
    end
  end

  def form
    Form.new(self)
  end


  def self.handle(ctx) : Bool
    match = path_matcher.match(ctx.request.path)
    return false unless match

    model = model_class.find(match[1])
    action = self.new(model)

    return true unless action.before_action_halted?(ctx)

    model.db.exec("DELETE FROM #{model.table_name} WHERE id=#{model.id}")

    ctx.response.status = :ok
    ctx.response.headers.add("Content-Type", TURBO_STREAM_MIME_TYPE)
    action.model_template.turbo_stream.to_html(ctx.response)

    true
  end
end

class Orma::Record
  macro delete_record_action(name, model_tpl, &blk)
    class {{name.id.capitalize}}Action < DeleteRecordAction
      getter model : {{@type}}

      def initialize(@model); end

      def self.model_class : ::Orma::Record.class
        {{@type.resolve}}
      end

      def self.action_name : String
        {{name.id.stringify}}
      end

      def model_template : IdentifiableView
        model.{{model_tpl.id}}
      end

      {% if blk.body.is_a?(Call) && blk.body.name.stringify == "before" && blk.body.block %}
        def before_action({{blk.body.block.args.splat}})
          {{blk.body.block.body}}
        end
      {% end %}
    end

    def {{name.id.underscore}}_action
      {{name.id.capitalize}}Action.new(self)
    end

    Crumble::ORM::ActionRegistry.add({{@type.name}}::{{name.capitalize.id}}Action)
  end
end
