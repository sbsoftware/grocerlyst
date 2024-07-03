class ItemHider
  ToHtml.class_template do
    a Crumble::Material::Classes::MaterialIcon, ListItemHiderController.switch_action("click"), ListItemHiderController.switch_target do
      "visibility"
    end
  end
end
