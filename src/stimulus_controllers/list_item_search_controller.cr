class ListItemSearchController < StimulusController
  targets :searchInput, :addInput, :addSubmit, :addDisplay, :addDisplayContainer, :itemList

  method :sync do
    search = this.searchInputTarget.value

    this.addInputTarget.value = search
    this.addDisplayTarget.innerHTML = search

    if search === ""
      this.itemListTarget.classList.remove(Classes::ItemListSearchActive)
      this.addDisplayContainerTarget.classList.add(Classes::AddItemDisplayHidden)
    else
      this.addDisplayContainerTarget.classList.remove(Classes::AddItemDisplayHidden)
      this.itemListTarget.classList.add(Classes::ItemListSearchActive)
      this.itemListTarget.children.each do |item|
        if item != this.addDisplayContainerTarget
          if item.textContent.trim.toLowerCase === search.trim.toLowerCase
            this.addDisplayContainerTarget.classList.add(Classes::AddItemDisplayHidden)
          end

          if item.textContent.trim.toLowerCase.includes(search.trim.toLowerCase)
            item.classList.add(Classes::ItemSearchMatch)
          else
            item.classList.remove(Classes::ItemSearchMatch)
          end
        end
      end
    end
  end

  method :add do
    this.addSubmitTarget.click
    this.addInputTarget.value = ""
    this.searchInputTarget.value = ""
  end
end
