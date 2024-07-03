class ApplicationStyle < CSS::Stylesheet
  rules do
    rule Classes::AddItemForm do
      display None
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
      width 100.percent
      fontSize 1.25.em
      prop("line-height", 30.px)
      prop("box-sizing", "border-box")
    end

    rule Classes::ListItem >> li do
      padding 8.px
      border(1.px, Solid, {0xBB, 0xBB, 0xBB})
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

    rule Classes::HideCheckedItems >> ListItem.active(false) do
      display None
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
