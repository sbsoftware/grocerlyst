class ListItemHiderController < Stimulus::Controller
  targets :list, :switch

  action :switch do
    this.listTarget.classList.toggle(Classes::HideCheckedItems.to_js_ref)

    if this.switchTarget.innerHTML == "visibility"
      this.switchTarget.innerHTML = "visibility_off"
    else
      this.switchTarget.innerHTML = "visibility"
    end
  end
end
