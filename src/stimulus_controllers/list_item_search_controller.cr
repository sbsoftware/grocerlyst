class ListItemSearchController < Stimulus::Controller
  targets :searchInput, :addInput, :addSubmit, :addDisplay, :addDisplayContainer, :itemList

  action :sync do
    _literal_js("var search = this.searchInputTarget.value;")

    this.addInputTarget.value = search
    this.addDisplayTarget.innerHTML = search

    if search == ""
      this.itemListTarget.classList.remove(Classes::ItemListSearchActive.to_js_ref)
      this.addDisplayContainerTarget.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
    else
      this.addDisplayContainerTarget.classList.remove(Classes::AddItemDisplayHidden.to_js_ref)
      this.itemListTarget.classList.add(Classes::ItemListSearchActive.to_js_ref)
      _literal_js("var that = this;")
      Array.from(this.itemListTarget.children).forEach do |item|
        if item != that.addDisplayContainerTarget
          if item.textContent.trim._call.toLowerCase._call == search.trim._call.toLowerCase._call
            that.addDisplayContainerTarget.classList.add(Classes::AddItemDisplayHidden.to_js_ref)
          end

          if item.textContent.trim._call.toLowerCase._call.includes(search.trim._call.toLowerCase._call)
            item.classList.add(Classes::ItemSearchMatch.to_js_ref)
          else
            item.classList.remove(Classes::ItemSearchMatch.to_js_ref)
          end
        end
      end
    end
  end

  action :add do
    this.addSubmitTarget.click._call
    this.addInputTarget.value = ""
    this.searchInputTarget.value = ""
  end
end
