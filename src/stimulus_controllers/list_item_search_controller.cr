require "./list_item_hider_controller"

class ListItemSearchController < Stimulus::Controller
  outlets ListItemHiderController

  targets :addInput, :addSubmit, :addButtonContainer, :addDisplayContainer, :itemList

  js_method :connect do
    this.update_top_add_button._call
    this.observe_item_list_changes._call
  end

  js_method :disconnect do
    if this.itemListObserver
      this.itemListObserver.disconnect._call
    end
  end

  js_method :itemListTargetConnected do
    this.update_top_add_button._call
    this.observe_item_list_changes._call
  end

  js_method :itemListTargetDisconnected do
    if this.itemListObserver
      this.itemListObserver.disconnect._call
    end
  end

  js_method :observe_item_list_changes do
    if this.itemListObserver
      this.itemListObserver.disconnect._call
    end
    this.itemListObserver = MutationObserver.new(-> { this.update_top_add_button._call })
    this.itemListObserver.observe(this.itemListTarget, {"childList" => true, "subtree" => true, "attributes" => true, "attributeFilter" => [ListItem.active(false).to_css_selector.attr_name.to_js_ref, "class"]})
  end

  js_method :visible_item_count do
    count = this.itemListTarget.querySelectorAll(Classes::ItemSearchable.to_css_selector.to_s.to_js_ref).length
    if document.body.classList.contains(Classes::HideCheckedItems.to_js_ref)
      count = count - this.itemListTarget.querySelectorAll("#{Classes::ItemSearchable.to_css_selector} #{ListItem.active(false).to_css_selector}".to_js_ref).length
    end
    return count
  end

  js_method :add_forms_hidden do
    hidden = true
    this.addDisplayContainerTargets.forEach do |container|
      unless container.classList.contains(Classes::AddItemDisplayHidden.to_js_ref)
        hidden = false
      end
    end
    return hidden
  end

  js_method :clear_search_matches do
    Array.from(this.itemListTarget.querySelectorAll(Classes::ItemSearchable.to_css_selector.to_s.to_js_ref)).forEach do |item|
      item.classList.remove(Classes::ItemSearchMatch.to_js_ref)
    end
  end

  js_method :update_top_add_button do
    topButtonContainer = this.addButtonContainerTargets[0]
    unless this.add_forms_hidden._call
      topButtonContainer.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
      return
    end

    if this.visible_item_count._call > 8
      topButtonContainer.classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
    else
      topButtonContainer.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
    end
  end

  action :enable_search_mode do |event|
    index = 0
    index = 1 if event.params.placement == "bottom"
    this.addButtonContainerTargets.forEach do |container|
      container.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
    end
    this.addDisplayContainerTargets[index].classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
    this.listItemHiderOutlet.show_inactive._call
    this.itemListTarget.classList.add(Classes::ItemListSearchActive.to_js_ref)
    this.clear_search_matches._call
    this.addInputTargets[index].value = ""
    this.addInputTargets[index].focus._call
  end

  action :disable_search_mode do
    unless this.add_forms_hidden._call
      this.addDisplayContainerTargets.forEach do |container|
        container.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
      end
      this.addButtonContainerTargets.forEach do |container|
        container.classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
      end
      this.update_top_add_button._call
      this.itemListTarget.classList.remove(Classes::ItemListSearchActive.to_js_ref)
      this.listItemHiderOutlet.hide_inactive._call
    end
  end

  action :filter do |event|
    search = event.currentTarget.value
    that = this

    this.itemListTarget.classList.add(Classes::ItemListSearchActive.to_js_ref)
    this.clear_search_matches._call

    unless search == ""
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
    index = 0
    index = 1 if event.params.placement == "bottom"
    if this.addInputTargets[index].value != ""
      this.disable_search_mode._call
      this.addSubmitTargets[index].click._call
    end
  end
end
