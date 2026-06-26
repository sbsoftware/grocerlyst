require "./spec_helper"

private class RecordingPushSender < PushNotifications::Sender
  getter sessions = [] of String
  getter payloads = [] of String

  def send_to_sessions(sessions : Enumerable(Crumble::Web::Push::Server::Subscription), payload : String) : Nil
    sessions.each { |subscription| @sessions << subscription.session_id }
    payloads << payload
  end
end

describe PushNotifications do
  before_each do
    SpecSupport.reset_db!
  end

  it "notifies subscribed existing list members when a new member joins" do
    sender = RecordingPushSender.new
    PushNotifications.sender = sender
    list = List.create(name: "Dinner", session_id: "owner-session")
    reloaded_list = List.where(id: list.id).first
    ctx = Crumble::Server::TestRequestContext.new(method: "POST", resource: List::AcceptAccessAction.uri_path(reloaded_list.id.value), body: "access_token=#{reloaded_list.access_token.value}")

    ListAccessPermission.create(list_id: list.id, session_id: "owner-session", name: "Alice")
    ListAccessPermission.create(list_id: list.id, session_id: "unsubscribed-session", name: "Chris")
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "owner-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/owner", p256dh: "p256dh", auth: "auth")))
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: ctx.session.id.to_s, web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/joining", p256dh: "p256dh", auth: "auth")))
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "outside-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/outside", p256dh: "p256dh", auth: "auth")))

    List::AcceptAccessAction.handle(ctx).should be_true

    sender.sessions.should eq(["owner-session"])
    sender.payloads.size.should eq(1)
    JSON.parse(sender.payloads.first)["body"].as_s.should eq("Someone joined Dinner")
  end

  it "notifies subscribed list members when an item change action is logged" do
    sender = RecordingPushSender.new
    PushNotifications.sender = sender
    list = List.create(name: "Dinner", session_id: "owner-session")
    item = ListItem.create(list_id: list.id, name: "Milk")
    ListAccessPermission.create(list_id: list.id, session_id: "actor-session", name: "Alice")
    ListAccessPermission.create(list_id: list.id, session_id: "member-session", name: "Bob")
    ListAccessPermission.create(list_id: list.id, session_id: "unsubscribed-session", name: "Chris")
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "actor-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/actor", p256dh: "p256dh", auth: "auth")))
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "member-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/member", p256dh: "p256dh", auth: "auth")))
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "outside-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/outside", p256dh: "p256dh", auth: "auth")))

    ListActionEvent.record!("actor-session", "added", item)

    sender.sessions.should eq(["member-session"])
    sender.payloads.size.should eq(1)
    payload = JSON.parse(sender.payloads.first)
    payload["title"].as_s.should eq("List changed")
    payload["body"].as_s.should eq("Alice has made changes to List Dinner")
    payload["url"].as_s.should eq(ListPage.uri_path(list_id: list.id.value))
    List.find(list.id).item_change_notification_sent_at.should_not be_nil
  end

  it "rate-limits item change notifications per list for five minutes" do
    sender = RecordingPushSender.new
    PushNotifications.sender = sender
    list = List.create(name: "Dinner", session_id: "owner-session")
    item = ListItem.create(list_id: list.id, name: "Milk")
    ListAccessPermission.create(list_id: list.id, session_id: "actor-session", name: "Alice")
    ListAccessPermission.create(list_id: list.id, session_id: "member-session", name: "Bob")
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: "member-session", web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/member", p256dh: "p256dh", auth: "auth")))

    ListActionEvent.record!("actor-session", "added", item)
    ListActionEvent.record!("actor-session", "activated", item)

    sender.payloads.size.should eq(1)

    List.find(list.id).update(item_change_notification_sent_at: Time.utc - 6.minutes)
    ListActionEvent.record!("actor-session", "deactivated", item)

    sender.payloads.size.should eq(2)
  end
end
