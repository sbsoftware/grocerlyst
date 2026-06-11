require "./list_item_hider_controller"

class ListItemSearchController < Stimulus::Controller
  targets :addInput, :addSubmit, :addButtonContainer, :addDisplayContainer, :itemList
  outlets ListItemHiderController

  action :enable_search_mode do
    this.addButtonContainerTarget.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
    this.addDisplayContainerTarget.classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
    this.listItemHiderOutlet.show_inactive._call
    this.addInputTarget.value = ""
    this.addInputTarget.focus._call
  end

  action :disable_search_mode do
    unless this.addDisplayContainerTarget.classList.contains(Classes::AddItemDisplayHidden.to_js_ref)
      this.addDisplayContainerTarget.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
      this.addButtonContainerTarget.classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
      this.itemListTarget.classList.remove(Classes::ItemListSearchActive.to_js_ref)
      this.listItemHiderOutlet.hide_inactive._call
    end
  end

  action :filter do
    search = this.addInputTarget.value
    that = this

    if search == ""
      this.itemListTarget.classList.remove(Classes::ItemListSearchActive.to_js_ref)
    else
      this.itemListTarget.classList.add(Classes::ItemListSearchActive.to_js_ref)
      Array.from(this.itemListTarget.querySelectorAll(Classes::ItemSearchable.to_css_selector.to_s.to_js_ref)).forEach do |item|
        name = item.querySelector(Classes::ItemName.to_css_selector.to_s.to_js_ref)
        if name.textContent.trim._call.toLowerCase._call.includes(search.trim._call.toLowerCase._call)
          item.classList.add(Classes::ItemSearchMatch.to_js_ref)
        else
          item.classList.remove(Classes::ItemSearchMatch.to_js_ref)
        end
      end
    end
  end

  action :add do
    if this.addInputTarget.value != ""
      this.disable_search_mode._call
      this.addSubmitTarget.click._call
    end
  end
end
