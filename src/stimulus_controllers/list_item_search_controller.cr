require "./list_item_hider_controller"

class ListItemSearchController < Stimulus::Controller
  targets :addInput, :addSubmit, :addButtonContainer, :addDisplayContainer, :itemList
  outlets ListItemHiderController

  action :enable_search_mode do
    index = event.params.placement == "bottom" ? 1 : 0
    this.addButtonContainerTargets.forEach do |container|
      container.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
    end
    this.addDisplayContainerTargets[index].classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
    this.listItemHiderOutlet.show_inactive._call
    this.addInputTargets[index].value = ""
    this.addInputTargets[index].focus._call
  end

  action :disable_search_mode do
    unless this.addDisplayContainerTargets.every do |container|
             container.classList.contains(Classes::AddItemDisplayHidden.to_js_ref)
           end
      this.addDisplayContainerTargets.forEach do |container|
        container.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
      end
      this.addButtonContainerTargets.forEach do |container|
        container.classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
      end
      this.itemListTarget.classList.remove(Classes::ItemListSearchActive.to_js_ref)
      this.listItemHiderOutlet.hide_inactive._call
    end
  end

  action :filter do |event|
    search = event.currentTarget.value
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

  action :add do |event|
    index = event.params.placement == "bottom" ? 1 : 0
    if this.addInputTargets[index].value != ""
      this.disable_search_mode._call
      this.addSubmitTargets[index].click._call
    end
  end
end
