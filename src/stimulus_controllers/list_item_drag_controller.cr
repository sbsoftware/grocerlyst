class ListItemDragController < Stimulus::Controller
  targets :subject_id, :target_id, :submit

  action :dragstart do |event|
    event.dataTransfer.setData("text/plain", event.target.getAttribute("data-crumble-list-item-id"))
    event.dataTransfer.effectAllowed = "move"
  end

  action :drag do |event|
    if event.clientY > (window.outerHeight - 120) && window.scrollY < (window.outerHeight - 15)
      window.scrollTo({"top" => window.scrollY + 15})
    elsif event.clientY < 120 && window.scrollY > 0
      window.scrollTo({"top" => window.scrollY - 15})
    end
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
    target_id = target.getAttribute("data-crumble-list-item-id")
    positionComparison = target.compareDocumentPosition(draggedItem)

    this.subjectIdTarget.value = data
    this.targetIdTarget.value = target_id

    if positionComparison & 4
      target.insertAdjacentElement("beforebegin", draggedItem)
    elsif positionComparison & 2
      target.insertAdjacentElement("afterend", draggedItem)
    end

    event.preventDefault._call

    this.submitTarget.click._call
  end

  action :dragend do |event|
  end
end
