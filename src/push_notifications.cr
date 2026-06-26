require "json"
require "crumble-web-push"

module PushNotifications
  TTL_SECONDS            = 60
  ITEM_CHANGE_RATE_LIMIT = 5.minutes

  abstract class Sender
    abstract def send_to_sessions(sessions : Enumerable(Crumble::Web::Push::Server::Subscription), payload : String) : Nil
  end

  class WebPushSender < Sender
    def send_to_sessions(sessions : Enumerable(Crumble::Web::Push::Server::Subscription), payload : String) : Nil
      outcomes = Crumble::Web::Push::Server::Integration.sender.send_subscriptions(sessions, payload, ttl: TTL_SECONDS)
      outcomes.each { |outcome| PushNotifications.subscription_adapter.delete(outcome.subscription.session_id) if outcome.cleanup? }
    end
  end

  @@sender : Sender = WebPushSender.new

  def self.configure!(adapter : Crumble::Web::Push::Server::SubscriptionAdapter = Crumble::Web::Push::Server::InMemorySubscriptionAdapter.new, sender : Sender = WebPushSender.new) : Nil
    Crumble::Web::Push::Server::Integration.subscription_adapter = adapter
    @@sender = sender
  end

  def self.sender=(sender : Sender) : Sender
    @@sender = sender
  end

  def self.subscribed?(session_id : String) : Bool
    !!subscription_adapter.get(session_id)
  rescue Crumble::Web::Push::Server::Integration::ConfigurationError
    false
  end

  def self.notify_member_joined(list_access_permission : ListAccessPermission) : Nil
    list = list_access_permission.list
    member_permissions = list.list_access_permissions.to_a
    return unless member_permissions.size > 1

    subscriptions = member_permissions.compact_map do |member_permission|
      next if member_permission.session_id.value == list_access_permission.session_id.value

      subscription_adapter.get(member_permission.session_id.value)
    end
    return if subscriptions.empty?

    @@sender.send_to_sessions(subscriptions, joined_payload(list_access_permission))
  rescue Crumble::Web::Push::Server::Integration::ConfigurationError
  end

  def self.notify_item_changed(event : ListActionEvent) : Nil
    list = event.list
    if sent_at = list.item_change_notification_sent_at
      return if sent_at.value > Time.utc - ITEM_CHANGE_RATE_LIMIT
    end

    subscriptions = list.list_access_permissions.to_a.compact_map do |member_permission|
      next if member_permission.session_id.value == event.actor_session_id.value

      subscription_adapter.get(member_permission.session_id.value)
    end
    return if subscriptions.empty?

    @@sender.send_to_sessions(subscriptions, item_changed_payload(event))
    list.update(item_change_notification_sent_at: Time.utc)
  rescue Crumble::Web::Push::Server::Integration::ConfigurationError
  end

  def self.subscription_adapter : Crumble::Web::Push::Server::SubscriptionAdapter
    Crumble::Web::Push::Server::Integration.subscription_adapter
  end

  private def self.joined_payload(list_access_permission : ListAccessPermission) : String
    {
      title: "New list member",
      body:  "#{list_access_permission.name.try(&.value) || "Someone"} joined #{list_access_permission.list.name.try(&.value) || "your list"}",
      url:   ListPage.uri_path(list_id: list_access_permission.list_id.value),
    }.to_json
  end

  private def self.item_changed_payload(event : ListActionEvent) : String
    {
      title: "List changed",
      body:  "#{event.actor_name} has made changes to #{event.list.name.try { |name| "List #{name.value}" } || "your list"}",
      url:   ListPage.uri_path(list_id: event.list_id.value),
    }.to_json
  end
end
