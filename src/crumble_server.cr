require "./styles/*"
require "./models/*"
require "./stimulus_controllers/*"
require "./views/*"
require "./resources/*"

StimulusInclude = {{ run("./stimulus_include.cr").stringify }}

if ENV.fetch("ORMA_CONTINUOUS_MIGRATION", "").in?(["1", "true"])
  {% for orm_class in Orma::Record.all_subclasses %}
    {% if !orm_class.abstract? %}
      {{orm_class.id}}.continuous_migration!
    {% end %}
  {% end %}
end

Crumble::Server.start
