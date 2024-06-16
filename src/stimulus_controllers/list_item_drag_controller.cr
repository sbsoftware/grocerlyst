class ListItemDragController < Stimulus::Controller
  action :dragstart do |event|
    event.dataTransfer.setData("text/plain", event.target.getAttribute("data-crumble-list-item-id"))
    event.dataTransfer.effectAllowed = "move"
  end

  action :dragover do |event|
    event.preventDefault._call
    _literal_js("return true;")
  end

  action :dragenter do |event|
    event.preventDefault._call
  end

  action :drop do |event|
    _literal_js("var data = event.dataTransfer.getData(\"text/plain\");");
    _literal_js("const draggedItem = this.element.querySelector(`[data-crumble-list-item-id='${data}']`);")
    _literal_js("const target = event.target.closest('[draggable=\"true\"]');")
    _literal_js("const positionComparison = target.compareDocumentPosition(draggedItem);")

    if positionComparison & 4
      target.insertAdjacentElement("beforebegin", draggedItem)
    else
      # FIXME: This `if` is ignored when it stands alone
      console.log._call
      if positionComparison & 2
        target.insertAdjacentElement("afterend", draggedItem)
      end
    end

    event.preventDefault._call
  end

  action :dragend do |event|
  end
end
