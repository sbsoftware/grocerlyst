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

    rule "a" do
      text_decoration :underline
    end
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

  rule Classes::HideCheckedItems do
    rule Classes::ListItems do
      rule ListItem.active(false) do
        display :none
      end
    end
  end
end
