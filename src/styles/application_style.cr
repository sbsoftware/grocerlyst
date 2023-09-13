class TTFFile < AssetFile
  def mime_type
    "font/ttf"
  end
end

MaterialIconFont = TTFFile.register "assets/MaterialSymbolsOutlined.ttf", "#{__DIR__}/../../assets/MaterialSymbolsOutlined.ttf"

class ApplicationStyle < CSS::Stylesheet
  rules do
    font_face do
      fontFamily "Material Symbols Outlined"
      fontStyle Normal
      src url(MaterialIconFont.uri_path)
    end

    rule Classes::MaterialIcon do
      fontFamily "Material Symbols Outlined"
      fontWeight Normal
      fontStyle Normal
      fontSize 24.px
      display InlineBlock
      # lineHeight 1
      # textTransform None
      # letterSpacing Normal
      # wordWrap Normal
      # whiteSpace NoWrap
      # direction LTR
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
