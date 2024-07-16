abstract class ReorderItemsAction < Crumble::ORM::Action
  abstract def association

  module ClassMethods
    abstract def model_class
  end

  def model_class
    self.class.model_class
  end

  include ClassMethods

  class Form
    getter action : ReorderItemsAction

    def initialize(@action); end

    css_class ReorderItemsForm

    style do
      rule ReorderItemsForm do
        display None
      end
    end

    ToHtml.instance_template do
      form ReorderItemsForm, action: action.uri_path, method: "POST" do
        input ListItemDragController.subject_id_target, type: "text", name: "subject_id"
        input ListItemDragController.target_id_target, type: "text", name: "target_id"
        input ListItemDragController.submit_target, type: "submit"
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

    subject = action.association.find(subject_id)
    target = action.association.find(target_id)

    items = action.association.to_a
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
    ctx.response.headers.add("Content-Type", TURBO_STREAM_MIME_TYPE)
    action.model_template.turbo_stream.to_html(ctx.response)

    true
  end
end

class Orma::Record
  macro reorder_items_action(name, assoc, model_tpl)
    class {{name.id.capitalize}}Action < ReorderItemsAction
      getter model : {{@type}}

      def initialize(@model); end

      def self.model_class : Orma::Record.class
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

    def {{name.id}}_action
      {{name.id.capitalize}}Action.new(self)
    end

    Crumble::ORM::ActionRegistry.add({{@type.name}}::{{name.capitalize.id}}Action)
  end
end
