require "./session"
require "./styles/*"
require "./models/*"
require "./stimulus_controllers/*"
require "./policies/*"
require "./views/*"
require "./resources/*"
require "./request_context"

if ENV.fetch("ORMA_CONTINUOUS_MIGRATION", "").in?(["1", "true"])
  {% for orm_class in Orma::Record.all_subclasses %}
    {% if !orm_class.abstract? %}
      {{orm_class.id}}.continuous_migration!
    {% end %}
  {% end %}
end

# Data migration v12
List.all.each do |list|
  if list.list_access_permissions.count.zero?
    ListAccessPermission.create(list_id: list.id, session_id: list.session_id)
  end
end

Crumble::Server.start
