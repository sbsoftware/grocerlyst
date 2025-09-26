class ListItem < Orma::Record
  id_column id : Int64?
  column name : String?
  column list_id : Int64?
  column active : Bool = true
  column sort_order : Int32 = 0
  column created_at : Time?

  boolean_flip_action :switch, :active, :default_view

  delete_record_action :remove, list.items_view do
    before do |ctx, model|
      return true if ListItemPolicy.new(ctx).delete?(model)

      403
    end

    def self.confirm_prompt(model)
      "#{model.name} wirklich löschen?"
    end
  end

  model_template :default_view do
    div Classes::ItemSearchable, ListItemSearchController.disable_search_mode_action("click") do
      switch_action_template.to_html do
        li active do
          Crumble::Material::ListItem.to_html do
            div Classes::ListItem do
              span Classes::ItemName do
                name
              end

              remove_action_template.to_html do
                Crumble::Material::Icon.new("delete")
              end
            end
          end
        end
      end
    end
  end

  def list
    List.where(id: list_id).first
  end
end
