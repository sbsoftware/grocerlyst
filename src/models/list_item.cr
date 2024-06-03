class ListItem < Orma::Record
  id_column id : Int32?
  column name : String?
  column list_id : Int32?
  column active : Bool = true
  column created_at : Time?

  boolean_flip_action :switch, :active, :default_view

  model_template :default_view do
    switch_action.template.to_html do
      li active do
        strong do
          name
        end
      end
    end
  end
end
