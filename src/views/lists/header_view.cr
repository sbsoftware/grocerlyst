class Lists::HeaderView
  include Crumble::ContextView

  getter list : List

  css_class ListHeader

  ToHtml.instance_template do
    div ListHeader, list.set_name_action_template(ctx).action_element_attributes do
      list.name
    end
  end

  style do
    rule ListHeader do
      overflow :hidden
      text_overflow :ellipsis
    end
  end
end
