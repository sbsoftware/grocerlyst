require "./views/application_layout"

macro add_style(layout = ::ApplicationLayout, &blk)
  class Style < CSS::Stylesheet
    rules do
      {{blk.body}}
    end
  end

  class {{layout.id}}
    append_to_head {{@type}}::Style
  end
end
