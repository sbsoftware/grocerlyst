class Lists::HeaderView
  getter list : List

  def initialize(@list); end

  css_class ListHeader

  ToHtml.instance_template do
    div ListHeader, list.set_name_action_template.action_element_attributes do
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
