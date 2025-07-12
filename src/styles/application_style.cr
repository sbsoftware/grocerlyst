class ApplicationStyle < CSS::Stylesheet
  rules do
    rule a do
      color Black
    end

    rule "[data-action]" do
      prop("cursor", "pointer")
      prop("-webkit-tap-highlight-color", "transparent")
    end

    rule input, button do
      fontFamily "Roboto"
    end

    rule Classes::TextView do
      prop("margin-left", 16.px)
      prop("margin-right", 16.px)
    end

    rule Classes::AddItemForm do
      display Flex
      justifyContent SpaceBetween
      width 100.percent
    end

    rule Classes::AddItemForm >> form do
      flexGrow 2
    end

    rule Classes::AddItemForm >> "input[type=\"text\"]" do
      border 0.px, Solid, White
      prop("outline", "none")
      fontFamily "inherit"
      fontSize "inherit"
      padding 0
      margin 0
    end

    rule Classes::AddItemForm >> "input[type=\"submit\"]" do
      display None
    end

    rule Classes::AddItemForm >> Crumble::Material::Icon::IconClass do
      color Black
    end

    rule Classes::AddItemDisplayHidden do
      display None
    end

    rule Classes::ListItems do
      listStyle None
      margin 0
      padding 0
    end

    rule Classes::ListItem do
      display Flex
      justifyContent SpaceBetween
      alignItems Center
    end

    rule ListItem.active(false) do
      color Silver
    end

    rule Classes::ItemSearchable do
      width 100.percent
    end

    rule Classes::ItemListSearchActive >> Classes::ItemSearchable do
      display None
    end

    rule Classes::ItemListSearchActive >> Classes::ItemSearchMatch do
      display Block
    end

    rule Classes::HideCheckedItems >> ListItem.active(false) do
      display None
    end
  end
end
