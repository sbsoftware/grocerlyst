class ListActionEvent < Orma::Record
  id_column id : Int64
  column list_id : Int64
  column actor_session_id : String
  column action_type : String
  column item_id : Int64?
  column item_name : String?
  column created_at : Time?

  def self.record!(actor_session_id, action_type, item : ListItem)
    event = create(list_id: item.list_id.value, actor_session_id: actor_session_id, action_type: action_type, item_id: item.id.value, item_name: item.name.try(&.value))
    PushNotifications.notify_item_changed(event)
    event
  end

  def list
    List.where(id: list_id).first
  end

  def actor_name
    ListAccessPermission.where(list_id: list_id, session_id: actor_session_id).first?.try(&.name).try(&.value) || "Anonymous"
  end

  def formatted_created_at
    created_at.try(&.value.to_s("%Y-%m-%d %H:%M")) || ""
  end

  def display_action
    case action_type.value
    when "added"
      "added"
    when "activated"
      "activated"
    when "deactivated"
      "deactivated"
    when "deleted"
      "deleted"
    else
      action_type.value
    end
  end

  model_template :row_view do
    div class: "list-action-event-row" do
      Crumble::Material::Card.new.to_html do
        div class: "list-action-event-main" do
          span class: "list-action-event-actor" do
            actor_name
          end
          span do
            " #{display_action} "
          end
          strong do
            item_name.try(&.value) || "deleted item"
          end
        end
        time class: "list-action-event-time", datetime: created_at.try(&.value.to_rfc3339) || "" do
          formatted_created_at
        end
      end
    end
  end
end
