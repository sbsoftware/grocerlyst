class ListItemHiderController < StimulusController
  targets :list, :switch

  method :switch do
    label = this.switchTarget.innerHTML
    this.listTarget.classList.toggle(Classes::HideCheckedItems)

    if label === ""
      this.switchTarget.innerHTML = "Visibility Off"
    else
      this.switchTarget.innerHTML = "Visibility"
    end
  end
end
