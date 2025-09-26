class ListItem < Orma::Record
  id_column id : Int64?
  column name : String?
  column list_id : Int64?
  column active : Bool = true
  column sort_order : Int32 = 0
  column created_at : Time?

  boolean_flip_action :switch, :active, :default_view do
    view do
      template do
        li model.active do
          custom_action_trigger.to_html do
            Crumble::Material::ListItem.to_html do
              div Classes::ListItem do
                span Classes::ItemName do
                  model.name
                end

                model.remove_action_template(ctx).to_html
              end
            end
          end
        end
      end
    end
  end

  delete_record_action :remove, list.items_view do
    before do |ctx, model|
      return true if ListItemPolicy.new(ctx).delete?(model)

      403
    end

    view do
      template do
        custom_action_trigger(confirm_prompt: "#{model.name} wirklich löschen?").to_html do
          Crumble::Material::Icon.new("delete")
        end
      end
    end
  end

  model_template :default_view do
    div Classes::ItemSearchable, ListItemSearchController.disable_search_mode_action("click") do
      switch_action_template(ctx).to_html
    end
  end

  def list
    List.where(id: list_id).first
  end
end
