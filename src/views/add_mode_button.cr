class CSS::AttrSelector
  def to_s(io : IO)
    io << "["
    io << @attr_name
    io << "~='"
    io << @value
    io << "']"
  end
end

class Stimulus::Controller
  def self.selector
    CSS::AttrSelector.new(ATTR_NAME, controller_name)
  end
end

class AddModeButton
  include Crumble::ContextView
  include Crumble::Crababel

  getter placement : String

  def initialize(@ctx, @placement = "bottom"); end

  css_class Container
  css_class Button

  ToHtml.instance_template do
    div Container do
      button Button, ListItemSearchController.open_action("click"), ListItemSearchController.param("placement", placement), type: "button", aria: {label: t.label, haspopup: "dialog"} do
        Crumble::Material::Icon.new("add_circle")
      end
    end
  end

  style do
    rule Container do
      display :flex
      justify_content :center
      padding 16.px, 16.px
    end

    rule Button do
      padding 0
    end
  end
end
