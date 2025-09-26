class Lists::HeaderView
  include Crumble::ContextView

  getter list : List

  css_class ListHeader

  ToHtml.instance_template do
    div ListHeader, list.set_name_action_template(ctx).action_element_attributes do
      list.name
    end
  end

  add_style do
    rule ListHeader do
      prop("overflow", "hidden")
      prop("text-overflow", "ellipsis")
    end
  end
end
