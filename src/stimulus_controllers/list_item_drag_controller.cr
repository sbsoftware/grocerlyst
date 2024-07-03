class ListItemDragController < Stimulus::Controller
  action :dragstart do |event|
    event.dataTransfer.setData("text/plain", event.target.getAttribute("data-crumble-list-item-id"))
    event.dataTransfer.effectAllowed = "move"
  end

  action :dragover do |event|
    event.preventDefault._call
    return true
  end

  action :dragenter do |event|
    event.preventDefault._call
  end

  action :drop do |event|
    data = event.dataTransfer.getData("text/plain");
    _literal_js("const draggedItem = this.element.querySelector(`[data-crumble-list-item-id='${data}']`);")
    target = event.target.closest("[draggable=\"true\"]")
    positionComparison = target.compareDocumentPosition(draggedItem)

    if positionComparison & 4
      target.insertAdjacentElement("beforebegin", draggedItem)
    elsif positionComparison & 2
      target.insertAdjacentElement("afterend", draggedItem)
    end

    event.preventDefault._call
  end

  action :dragend do |event|
  end
end
