abstract class ReorderItemsAction < Orma::ModelAction
  abstract def association

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

    css_class ReorderItemsForm

    style do
      rule ReorderItemsForm do
        display None
      end
    end

    ToHtml.instance_template do
      form ReorderItemsForm, action: uri_path, method: "POST" do
        input ListItemDragController.subject_id_target, type: "text", name: "subject_id"
        input ListItemDragController.target_id_target, type: "text", name: "target_id"
        input ListItemDragController.submit_target, type: "submit"
      end
    end
  end

  def model_action_controller
    unless body = ctx.request.body
      ctx.response.status = :bad_request
      return true
    end

    subject_id = nil
    target_id = nil
    HTTP::Params.parse(body.gets_to_end) do |key, value|
      case key
      when "subject_id"
        subject_id = value.to_i32
      when "target_id"
        target_id = value.to_i32
      end
    end

    subject = association.find(subject_id)
    target = association.find(target_id)

    items = association.to_a
    if i = items.index(target)
      items.delete(subject)
      if i >= items.size
        items.push(subject)
      else
        items.insert(i, subject)
      end
    end

    items.each_with_index do |item, index|
      item.sort_order = index + 1
      item.save
    end

    ctx.response.status = :created
    model_template.turbo_stream.to_html(ctx.response)

    true
  end
end

class Orma::Record
  macro reorder_items_action(name, assoc, model_tpl)
    class {{name.id.capitalize}}Action < ReorderItemsAction
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

      def association
        model.{{assoc.id}}
      end

      def model_template : IdentifiableView
        model.{{model_tpl.id}}
      end
    end

    def {{name.id}}_action_template
      raise RuntimeError.new("ReorderItemsAction only works for persisted records!") unless id = self.id

      {{name.capitalize.id}}Action::Template.new({{name.capitalize.id}}Action.uri_path(id.value))
    end

    Crumble::Turbo::ActionRegistry.add({{@type.name}}::{{name.capitalize.id}}Action)
  end
end
