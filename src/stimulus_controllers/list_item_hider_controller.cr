class ListItemHiderController < Stimulus::Controller
  targets :list, :switch

  js_method :connect do
    this.update_icon._call
  end

  action :switch do
    this.listTarget.classList.toggle(Classes::HideCheckedItems.to_js_ref)
    this.update_icon._call
  end

  action :show_inactive do
    this.listTarget.classList.remove(Classes::HideCheckedItems.to_js_ref)
    this.update_icon._call
  end

  action :hide_inactive do
    this.listTarget.classList.add(Classes::HideCheckedItems.to_js_ref)
    this.update_icon._call
  end

  js_method :update_icon do
    if this.listTarget.classList.contains(Classes::HideCheckedItems.to_js_ref)
      this.switchTarget.innerHTML = Crumble::Material::Icon.new("visibility").to_html.to_js_ref
    else
      this.switchTarget.innerHTML = Crumble::Material::Icon.new("visibility_off").to_html.to_js_ref
    end
  end
end
