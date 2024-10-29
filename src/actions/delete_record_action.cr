abstract class DeleteRecordAction < Orma::ModelAction
  module ClassMethods
    abstract def model_class
  end

  def model_class
    self.class.model_class
  end

  include ClassMethods

  class Template
    getter uri_path : String

    def initialize(@uri_path); end

    css_class DeleteRecordForm

    style do
      rule DeleteRecordForm do
        display None
      end
    end

    ToHtml.instance_template do
      form DeleteRecordForm, action: uri_path, method: "POST" do
        input DeleteActionController.submit_target, type: "submit"
      end
    end
  end

  def controller
    model.db.exec("DELETE FROM #{model.table_name} WHERE id=#{model.id}")

    model_template.turbo_stream.to_html(ctx.response)

    true
  end
end

class Orma::Record
  macro delete_record_action(name, model_tpl, &blk)
    class {{name.id.capitalize}}Action < DeleteRecordAction
      @model : {{@type}}?

      def model
        @model ||= self.class.model_class.find(model_id)
      end

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
        def before_action
          {{blk.body.block.body}}
        end
      {% end %}
    end

    def {{name.id.underscore}}_action_template
      raise RuntimeError.new("DeleteRecordAction only works for persisted records!") unless id = self.id

      {{name.capitalize.id}}Action::Template.new({{name.capitalize.id}}Action.uri_path(id.value))
    end

    Crumble::Turbo::ActionRegistry.add({{@type.name}}::{{name.capitalize.id}}Action)
  end
end
