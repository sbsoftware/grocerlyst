class ListItem < Crumble::ORM::Base
  id_column id : Int32?
  column name : String?
  column list_id : Int32?
  column active : Bool = true
  column created_at : Time?

  boolean_flip_action :switch, :active, :default_view

  model_template :default_view do
    within switch_action.template do
      li active do
        strong do
          name
        end
      end
    end
  end
end
