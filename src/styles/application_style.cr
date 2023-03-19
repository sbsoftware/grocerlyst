class ApplicationStyle < CSS::Stylesheet
  rules do
    rule Classes::HeaderContainer do
    end

    rule Classes::AddItemForm do
      display None
    end

    rule Classes::AddItemDisplayHidden do
      display None
    end

    rule ListItem.active(false) do
      color Silver
    end

    rule Classes::ItemListSearchActive > Classes::ItemSearchable do
      display None
    end

    rule Classes::ItemListSearchActive > Classes::ItemSearchMatch do
      display Block
    end
  end
end
