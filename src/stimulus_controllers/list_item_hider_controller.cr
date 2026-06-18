class ListItemHiderController < Stimulus::Controller
  targets :list, :switch

  js_method :connect do
    this.update_icon._call
    this.update_top_add_button._call
  end

  action :switch do
    this.listTarget.classList.toggle(Classes::HideCheckedItems.to_js_ref)
    this.update_icon._call
    this.update_top_add_button._call
  end

  action :show_inactive do
    this.listTarget.classList.remove(Classes::HideCheckedItems.to_js_ref)
    this.update_icon._call
    this.update_top_add_button._call
  end

  action :hide_inactive do
    this.listTarget.classList.add(Classes::HideCheckedItems.to_js_ref)
    this.update_icon._call
    this.update_top_add_button._call
  end

  js_method :update_top_add_button do
    listItemSearchController = this.application.getControllerForElementAndIdentifier._call(
      document.body,
      ::ListItemSearchController.controller_name.to_js_ref
    )
    listItemSearchController.update_top_add_button._call if listItemSearchController
  end

  js_method :update_icon do
    if this.listTarget.classList.contains(Classes::HideCheckedItems.to_js_ref)
      this.switchTarget.innerHTML = Crumble::Material::Icon.new("visibility").to_html.to_js_ref
    else
      this.switchTarget.innerHTML = Crumble::Material::Icon.new("visibility_off").to_html.to_js_ref
    end
  end
end
