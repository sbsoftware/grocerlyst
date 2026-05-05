require "../../models/list"
require "../../pages/list_page"

module Lists
  class CreateAction < Crumble::Turbo::Action
    controller do
      new_list = List.create(
        name: "List from #{Time.local.to_s("%F")}",
        session_id: ctx.session.id.to_s
      )

      ListAccessPermission.create(list_id: new_list.id, session_id: ctx.session.id.to_s)

      redirect ListPage.uri_path(list_id: new_list.id)
    end

    view do
      template do
        custom_action_trigger.to_html do
          button type: "button" do
            "Create List"
          end
        end
      end
    end
  end
end
