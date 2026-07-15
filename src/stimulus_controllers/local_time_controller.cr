class LocalTimeController < Stimulus::Controller
  js_method :connect do
    _literal_js(%(const value = this.element.dateTime || this.element.getAttribute("datetime");))
    _literal_js(%(if (!value) return;))
    _literal_js(%(const date = new Date(value);))
    _literal_js(%(if (Number.isNaN(date.getTime())) return;))
    _literal_js(%(this.element.textContent = new Intl.DateTimeFormat(undefined, {dateStyle: "medium", timeStyle: "short"}).format(date);))
  end
end
