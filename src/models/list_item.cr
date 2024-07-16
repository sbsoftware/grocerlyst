struct NamedTuple
  def to_html_attrs(_tag, attr_hash)
    each do |key, value|
      attr_hash[key.to_s] = value
    end
  end
end

class ListItem < Orma::Record
  id_column id : Int32?
  column name : String?
  column list_id : Int32?
  column active : Bool = true
  column sort_order : Int32 = 0
  column created_at : Time?

  boolean_flip_action :switch, :active, :default_view

  model_template :default_view, [Classes::ListItem, Classes::ItemSearchable, {draggable: "true"}] do
    switch_action.template.to_html do
      li active do
        name
      end
    end
  end
end
