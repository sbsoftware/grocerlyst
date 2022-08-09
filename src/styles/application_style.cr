class ApplicationStyle < CSS::Stylesheet
  rules do
    rule ListItem.active(false) do
      color Silver
    end
  end
end
