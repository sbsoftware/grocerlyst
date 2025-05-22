class ItemHider
  ToHtml.class_template do
    a ListItemHiderController.switch_action("click"), ListItemHiderController.switch_target do
      Crumble::Material::Icon.new("visibility")
    end
  end
end
