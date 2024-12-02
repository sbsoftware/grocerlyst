class CSS::AttrSelector
  def to_s(io : IO)
    io << "["
    io << @name
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
  class AddModeButtonController < Stimulus::Controller
    outlets ListItemSearchController

    action :enable do |event|
      this.listItemSearchOutlet.enable_search_mode(event)
    end
  end

  ToHtml.class_template do
    a Crumble::Material::Classes::MaterialIcon, AddModeButtonController, AddModeButtonController.enable_action("click"), AddModeButtonController.list_item_search_controller_outlet(ListItemSearchController.selector.to_s) do
      "add"
    end
  end
end
