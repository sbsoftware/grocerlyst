class LocalTimeController < Stimulus::Controller
  js_method :connect do
    value = this.element.getAttribute("datetime")
    return nil unless value

    date = _literal_js("new Date(value)")
    return nil if _literal_js("Number.isNaN(date.getTime())")

    this.element.textContent = _literal_js(%(new Intl.DateTimeFormat(undefined, {dateStyle: "medium", timeStyle: "short"}).format(date)))
  end
end
