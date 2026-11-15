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
    response_io.to_s.should contain(%(aria-label="More options"))
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
    response_io.to_s.should contain(%(aria-label="Weitere Optionen"))
    response_io.to_s.should contain("Mitglieder")
    response_io.to_s.should contain("Liste teilen")
    response_io.to_s.should contain("Aktivitätsprotokoll")
    response_io.to_s.should contain(%(aria-label="Artikel hinzufügen"))
    response_io.to_s.should contain(%(aria-label="Schließen"))
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

  it "renders one modal with copied items and add actions before the menu and below the list" do
    list = List.create(name: "Weekly Shopping", session_id: "owner-session")
    ListItem.create(list_id: list.id.value, name: "Milk", active: true)
    ListItem.create(list_id: list.id.value, name: "Bread", active: false)
    response_io = IO::Memory.new
    ctx = Crumble::Server::TestRequestContext.new(response_io: response_io, method: "GET", resource: ListPage.uri_path(list_id: list.id.value))
    ListAccessPermission.create(list_id: list.id, session_id: ctx.session.id.to_s)

    ListPage.handle(ctx).should be_true
    ctx.response.flush

    response = response_io.to_s
    response.scan("<dialog ").size.should eq(1)
    response.scan(%(action="#{List::AddItemAction.uri_path(list.id)}")).size.should eq(1)
    response.scan(">Milk<").size.should eq(2)
    response.scan(">Bread<").size.should eq(2)
    top_action = response.index(ListItemSearchController.param("placement", "top").to_s).not_nil!
    hider = response.index(ListItemHiderController.switch_target.to_s).not_nil!
    menu = response.index(%(aria-label="More options")).not_nil!
    list_index = response.index(Classes::ListItems.to_s).not_nil!
    bottom_action = response.index(ListItemSearchController.param("placement", "bottom").to_s).not_nil!
    top_action.should be < hider
    hider.should be < menu
    list_index.should be < bottom_action
    response.should contain(ListItemSearchController.filter_action("input").to_s)
    response.should contain(%(aria-label="Add item"))
    response.should contain(%(aria-label="Close"))
    response.should contain(%(type="submit" hidden))
  end
end
