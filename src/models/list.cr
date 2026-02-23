require "./list_item"
require "./list_access_permission"
require "../pages/list_page"
require "../views/lists/*"

class List < Orma::Record
  id_column id : Int64
  column name : String?
  column session_id : String
  column created_at : Time?

  has_many_of ListAccessPermission

  accessible ListAccessPermission, ListPage, items_view do
    access_view do
      css_class Container

      template do
        div Container do
          h1 do
            "You have been invited to join the list \"#{model.name}\"!"
          end

          model.accept_access_action_template(ctx).to_html
        end
      end

      style do
        rule Container do
          display :flex
          flex_direction :column
          align_items :center
          padding 16.px
        end
      end
    end

    accept_access_view do
      template do
        button do
          "Join"
        end
      end
    end

    access_model_attributes session_id: ctx.session.id.to_s
  end

  def list_items
    ListItem.where(list_id: id).order_by_sort_order!
  end

  create_child_action :add_item, ListItem, list_id, {items_view, card_view} do
    form do
      field name : String
    end

    view do
      template do
        form action: action.uri_path, method: "POST" do
          input(ListItemSearchController.addInput_target, ListItemSearchController.filter_action("input"), ListItemSearchController.add_action("keydown.enter"), ListItemSearchController.disable_search_mode_action("keydown.esc"), name: "name", type: "text")
          input(ListItemSearchController.addSubmit_target, name: "Add Child", type: "submit")
        end
      end
    end

    controller do
      return unless body = ctx.request.body

      form = Form.from_www_form(ctx, body.gets_to_end)
      return unless form.valid? && (name = form.name) && name.size.positive?

      if existing_item = ListItem.where(list_id: model.id.value, name: name).first?
        existing_item.update(active: !existing_item.active.value)
      else
        ListItem.create(list_id: model.id.value, name: name)
      end
    end
  end

  reorder_children_action :reorder_list_items, list_items, default_view, items_view

  model_action :set_name, {header_view, card_view} do
    form do
      field name : String
    end

    controller do
      return unless body = ctx.request.body

      form = Form.from_www_form(ctx, body.gets_to_end)

      model.update(**form.values) if form.valid? && (name = form.name) && name.size.positive?
    end

    view do
      css_class Hidden
      css_class Container
      css_class TopRow

      stimulus_controller ActionController do
        outlets FormController

        action :show do
          this.listSetNameActionTemplateFormOutlet.show._call
        end
      end

      stimulus_controller FormController do
        js_method :show do
          this.element.classList.remove(Hidden.to_js_ref)
        end

        action :hide do
          this.element.classList.add(Hidden.to_js_ref)
        end
      end

      template do
        div Container, FormController, Hidden do
          div TopRow do
            div FormController.hide_action("click") do
              Crumble::Material::Icon.new("close")
            end
          end
          form action: action.uri_path, method: "POST" do
            label do
              "List name:"
            end
            input type: :text, name: "name", value: action.model.name
            button FormController.hide_action("click") do
              "Update"
            end
          end
        end
      end

      style do
        rule Container do
          padding 16.px

          rule label do
            display :block
            margin_bottom 8.px
          end

          rule input do
            width 100.percent
            margin_bottom 8.px
          end
        end

        rule TopRow do
          display :flex
          flex_direction :row_reverse
        end

        rule Hidden do
          display :none
        end
      end

      def form_controller_outlet
        ActionController.form_controller_outlet(FormController.selector.to_s)
      end

      def action_controller
        ActionController
      end

      def action_element_attributes
        [action_controller, action_controller.show_action("click"), form_controller_outlet]
      end
    end
  end

  model_template :header_view do
    Lists::HeaderView.new(ctx: ctx, list: model)
  end

  model_template :card_view do
    Lists::CardView.new(model)
  end

  model_template :items_view do
    ul Classes::ListItems, ListItemSearchController.itemList_target do
      reorder_list_items_action_template(ctx).to_html
    end
  end
end
