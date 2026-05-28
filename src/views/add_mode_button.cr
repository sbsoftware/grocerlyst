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
  css_class Container
  css_class Button

  class AddModeButtonController < Stimulus::Controller
    outlets ListItemSearchController

    action :enable do |event|
      this.listItemSearchOutlet.enable_search_mode(event)
    end
  end

  ToHtml.class_template do
    div Container do
      button Button, AddModeButtonController, AddModeButtonController.enable_action("click"), AddModeButtonController.list_item_search_controller_outlet(ListItemSearchController.selector.to_s), type: "button" do
        Crumble::Material::Icon.new("add")
      end
    end
  end

  style do
    rule Container do
      display :flex
      justify_content :center
      padding 8.px, 16.px
    end

    rule Button do
      padding 0
    end
  end
end
