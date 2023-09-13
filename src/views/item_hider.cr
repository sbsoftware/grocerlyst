class ItemHider < Template
  template do
    a Classes::MaterialIcon, ListItemHiderController.switch_action(ClickEvent), ListItemHiderController.switch_target do
      "Visibility"
    end
  end
end
