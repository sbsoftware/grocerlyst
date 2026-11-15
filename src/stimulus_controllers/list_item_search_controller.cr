class ListItemSearchController < Stimulus::Controller
  targets :dialog, :input, :form, :placement, :results, :result, :error

  action :open do |event|
    this.opener = event.currentTarget
    this.placementTarget.value = event.params.placement
    this.inputTarget.value = ""
    this.errorTarget.hidden = true
    this.filter._call
    this.dialogTarget.showModal._call
    this.inputTarget.focus._call
  end

  action :close do
    this.dialogTarget.close._call
  end

  action :closed do
    if this.opener
      this.opener.focus._call
    end
  end

  action :backdrop do |event|
    # Only dismiss clicks outside the dialog rectangle, not its padding.
    return unless event.target == this.dialogTarget
    rect = this.dialogTarget.getBoundingClientRect._call
    # Separate conditions avoid the installed js.cr compound-expression bug.
    if event.clientX >= rect.left
      if event.clientX <= rect.right
        if event.clientY >= rect.top
          return if event.clientY <= rect.bottom
        end
      end
    end
    this.close._call
  end

  action :filter do
    search = this.inputTarget.value.trim._call.toLowerCase._call
    # Targets also occur in the real list. Only copies inside results are filtered.
    this.resultsTarget.querySelectorAll("[data-list-item-search-target~='result']").forEach do |item|
      name = item.querySelector(Classes::ItemName.to_css_selector.to_s.to_js_ref)
      item.hidden = true
      unless search == ""
        if name
          # Keep negation out of this call chain: js.cr 1.8.2 leaves it untranslated.
          if name.textContent.trim._call.toLowerCase._call.includes(search)
            item.hidden = false
          end
        end
      end
    end
  end

  js_method :resultsTargetConnected do
    this.filter._call if this.hasInputTarget
  end

  js_method :resultTargetConnected do
    return unless this.hasInputTarget
    this.filter._call if this.hasResultsTarget
  end

  action :add do
    this.formTarget.requestSubmit._call
  end

  action :validate do |event|
    if this.inputTarget.value.trim._call == ""
      event.preventDefault._call
      this.inputTarget.focus._call
    end
    this.errorTarget.hidden = true
  end

  action :submitted do |event|
    # Delete and toggle use nested action forms; canceled confirmations never submit.
    if event.detail.success
      if event.target == this.formTarget
        this.close._call
      elsif event.target.action.endsWith("/switch")
        this.close._call
      end
    else
      this.errorTarget.hidden = false
    end
  end

  action :before_cache do
    this.dialogTarget.close._call
  end
end
