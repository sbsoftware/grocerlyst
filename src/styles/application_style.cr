class ApplicationStyle < CSS::Stylesheet
  rules do
    rule SwitchController.toggle_value(false) do
      color Silver
    end
  end
end
