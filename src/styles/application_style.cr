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

    rule Classes::ImprovementChangeType do
      backgroundColor({0x00, 0x64, 0x00})
      color White
    end

    rule Classes::BugfixChangeType do
      backgroundColor Red
      color White
    end

    rule Classes::FeatureChangeType do
      backgroundColor({0x00, 0x00, 0x8B})
      color White
    end

    rule Classes::ChangeDescription do
      display Block
      color Silver
      fontSize 0.8.em
      paddingTop 0.8.em
      paddingBottom 0.8.em
    end
  end
end
