require "../actions/delete_record_action"

class ListItem < Orma::Record
  id_column id : Int32?
  column name : String?
  column list_id : Int32?
  column active : Bool = true
  column sort_order : Int32 = 0
  column created_at : Time?

  boolean_flip_action :switch, :active, :default_view

  delete_record_action :remove, list.items_view do
    before do |ctx, model|
      return true if ListItemPolicy.new(ctx).delete?(model)

      403
    end
  end

  model_template :default_view, [Classes::ListItem, Classes::ItemSearchable, DeleteActionController, {draggable: "true"}] do
    switch_action_template.to_html do
      remove_action_template.to_html
      li active do
        name

        span Crumble::Material::Classes::MaterialIcon, DeleteActionController.delete_action("click") do
          "delete"
        end
      end
    end
  end

  def list
    List.where({"id" => list_id}).to_a.first
  end
end
