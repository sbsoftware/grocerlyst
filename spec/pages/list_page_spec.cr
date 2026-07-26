require "../spec_helper"

describe ListPage do
  before_each do
    SpecSupport.reset_db!
  end

  it "redirects to the home page when the list is not accessible" do
    list = List.create(name: "Groceries", session_id: "another-session")
    ctx = Crumble::Server::TestRequestContext.new(method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListPage.handle(ctx).should be_true

    ctx.response.status_code.should eq(303)
    ctx.response.headers["Location"].should eq(HomePage.uri_path)
    ctx.session.last_used_list_id.should be_nil
  end

  it "renders an accessible list and stores it as last used" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    ctx.response.status_code.should eq(200)
    response_io.to_s.should contain("Weekly Shopping")
    response_io.to_s.should contain("id=\"#{Crumble::Material::TopAppBar::TopAppBarId}\"")
    response_io.to_s.should contain(%(href="#{HomePage.uri_path}"))
    response_io.to_s.should contain("arrow_back")
    response_io.to_s.should contain("Get notifications when your lists change.")
    response_io.to_s.should contain(PushSubscriptionBannerController.subscribe_action("click").to_s)
    response_io.to_s.should contain(PushSubscriptionBannerController.dismiss_action("click").to_s)
    response_io.to_s.should contain("aria-label=\"Dismiss notification hint\"")
    response_io.to_s.should contain("close")
    response_io.to_s.should_not contain("Menu")
    response_io.to_s.should contain("visibility")
    response_io.to_s.should contain("history")
    response_io.to_s.should contain(ListItemHiderController.switch_target.to_s)
    ctx.session.last_used_list_id.should eq(list.id.value)
  end

  it "renders the push subscription banner in the accepted language" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    headers = HTTP::Headers{"Accept-Language" => "de"}
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value), headers: headers)

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response_io.to_s.should contain("Benachrichtigungen erhalten, wenn sich deine Listen ändern.")
    response_io.to_s.should contain("Abonnieren")
  end

  it "renders the list name form directly below the top app bar before the subscription banner" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response = response_io.to_s
    top_app_bar_index = response.index(%(id="#{Crumble::Material::TopAppBar::TopAppBarId}")).not_nil!
    set_name_form_index = response.index(%(action="#{List::SetNameAction.uri_path(list.id)}")).not_nil!
    subscription_banner_index = response.index(PushSubscriptionBanner::Banner.to_s).not_nil!
    label_index = response.index("List name:", set_name_form_index).not_nil!
    input_index = response.index(%(name="name"), set_name_form_index).not_nil!
    submit_index = response.index("Update", set_name_form_index).not_nil!
    dismiss_index = response.index(%(aria-label="Dismiss list name form"), set_name_form_index).not_nil!

    top_app_bar_index.should be < set_name_form_index
    set_name_form_index.should be < subscription_banner_index
    label_index.should be < input_index
    input_index.should be < submit_index
    submit_index.should be < dismiss_index
  end

  it "hides the push subscription banner when the current session is subscribed" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)
    PushNotifications.subscription_adapter.save(Crumble::Web::Push::Server::Subscription.new(session_id: ctx.session.id.to_s, web_push_subscription: WebPush::Subscription.new(endpoint: "https://example.com/push", p256dh: "p256dh", auth: "auth")))

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response_io.to_s.should_not contain("Get notifications when your lists change.")
  end

  it "renders add item actions above and below the active list" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    9.times do |index|
      ListItem.create(list_id: list.id.value, name: "Item #{index}", active: true)
    end
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response = response_io.to_s
    response.index(AddModeButton::Container.to_s).should_not be_nil
    response.index(ListItemSearchController.addButtonContainer_target.to_s).should_not be_nil
    response.index(AddModeButton::AddModeButtonController.enable_action("click").to_s).should_not be_nil
    top_button_index = response.index(AddModeButton::AddModeButtonController.param("placement", "top").to_s).not_nil!
    top_form_index = response.index(%(name="placement" type="hidden" value="top")).not_nil!
    list_index = response.index(Classes::ListItems.to_s).not_nil!
    bottom_form_index = response.index(%(name="placement" type="hidden" value="bottom")).not_nil!
    bottom_button_index = response.index(AddModeButton::AddModeButtonController.param("placement", "bottom").to_s).not_nil!
    top_button_index.should be < top_form_index
    top_form_index.should be < list_index
    list_index.should be < bottom_form_index
    bottom_form_index.should be < bottom_button_index
  end

  it "renders the top add item button hidden so client-side visibility can account for inactive items" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))

    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response = response_io.to_s
    response.should contain(AddModeButton::AddModeButtonController.param("placement", "top").to_s)
    response.should contain(AddModeButton::AddModeButtonController.param("placement", "bottom").to_s)
    response.index(Classes::AddItemDisplayHidden.to_s).not_nil!.should be < response.index(AddModeButton::AddModeButtonController.param("placement", "top").to_s).not_nil!
  end
end
