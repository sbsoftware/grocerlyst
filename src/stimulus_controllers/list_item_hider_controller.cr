class ListItemHiderController < Stimulus::Controller
  targets :list, :switch

  js_method :connect do
    this.update_icon._call
  end

  action :switch do
    this.listTarget.classList.toggle(Classes::HideCheckedItems.to_js_ref)
    this.update_icon._call
  end

  js_method :update_icon do
    if this.listTarget.classList.contains(Classes::HideCheckedItems.to_js_ref)
      this.switchTarget.innerHTML = "visibility"
    else
      this.switchTarget.innerHTML = "visibility_off"
    end
  end
end
