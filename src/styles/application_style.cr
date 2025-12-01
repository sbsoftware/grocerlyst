class ApplicationStyle < CSS::Stylesheet
  rule a do
    color :black
  end

  rule "[data-action]" do
    cursor :pointer
    _webkit_tap_highlight_color :transparent
  end

  rule input, button do
    font_family "Roboto"
  end

  rule Classes::TextView do
    margin_left 16.px
    margin_right 16.px
  end

  rule Classes::AddItemForm do
    display :flex
    justify_content :space_between
    width 100.percent

    rule "input[type=\"text\"]" do
      border 0.px
      border_style :solid
      border_color :white
      background_color :white
      outline :none
      font_family :inherit
      font_size :inherit
      padding 0
      margin 0
    end

    rule "input[type=\"submit\"]" do
      display :none
    end

    rule Crumble::Material::Icon::IconClass do
      color :black
    end
  end

  rule Classes::AddItemForm > div do
    flex_grow 2
  end

  rule Classes::AddItemDisplayHidden do
    display :none
  end

  rule Classes::ListItems do
    list_style :none
    margin 0
    padding 0
  end

  rule Classes::ListItem do
    display :flex
    justify_content :space_between
    align_items :center
  end

  rule ListItem.active(false) do
    color :silver
  end

  rule Classes::ItemSearchable do
    width 100.percent
  end

  rule Classes::ItemListSearchActive do
    rule Classes::ItemSearchable do
      display :none
    end

    rule Classes::ItemSearchMatch do
      display :block
    end
  end

  rule Classes::HideCheckedItems do
    rule ListItem.active(false) do
      display :none
    end
  end
end
