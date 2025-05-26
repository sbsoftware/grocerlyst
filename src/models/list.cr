require "./list_item"
require "./list_access_permission"
require "../views/lists/*"

class List < Orma::Record
  id_column id : Int32?
  column name : String?
  column session_id : String?
  column access_token : String?
  column created_at : Time?

  has_many_of ListAccessPermission

  def list_items
    ListItem.where({"list_id" => id}).order_by_sort_order!
  end

  create_child_action :add_item, ListItem, list_id, items_view do
    params :name

    form do
      input(ListItemSearchController.addInput_target, ListItemSearchController.filter_action("input"), ListItemSearchController.add_action("keydown.enter"), ListItemSearchController.disable_search_mode_action("keydown.esc"), name: "name", type: "text")
      input(ListItemSearchController.addSubmit_target, name: "Add Child", type: "submit")
    end

    controller do
      if body = ctx.request.body
        new_child = child_instance(body.gets_to_end)

        if existing_item = ListItem.where({"list_id" => model.id, "name" => new_child.name}).first?
          existing_item.update(active: !existing_item.active.value)
        else
          new_child.save
        end
      end
    end
  end

  reorder_children_action :reorder_list_items, list_items, default_view, items_view

  model_action :set_name, header_view do
    NAME_FIELD = "name"

    controller do
      return unless body = ctx.request.body

      name = nil
      HTTP::Params.parse(body.gets_to_end) do |key, val|
        case key
        when NAME_FIELD
          name = val
        end
      end

      model.update(name: name) if name && name.size.positive?
    end

    class Template
      getter uri_path : String
      getter current_name : Orma::Attribute(String)?

      def initialize(@uri_path, @current_name); end

      css_class Hidden
      css_class Wrapper
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

      ToHtml.instance_template do
        div Wrapper, FormController, Hidden do
          div TopRow do
            div FormController.hide_action("click") do
              Crumble::Material::Icon.new("close")
            end
          end
          form action: uri_path, method: "POST" do
            label do
              "Name der Liste:"
            end
            input type: :text, name: NAME_FIELD, value: current_name
            button FormController.hide_action("click") do
              "Aktualisieren"
            end
          end
        end
      end

      add_style do
        rule Wrapper do
          padding 16.px
        end

        rule Wrapper >> label do
          display Block
          marginBottom 8.px
        end

        rule Wrapper >> input do
          width 100.percent
          marginBottom 8.px
        end

        rule TopRow do
          display Flex
          flexDirection RowReverse
        end

        rule Hidden do
          display None
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

    def self.action_template(model)
      Template.new(self.uri_path(model.id), model.name)
    end
  end

  model_template :header_view do
    Lists::HeaderView.new(model)
  end

  model_template :card_view do
    Lists::CardView.new(@model)
  end

  model_template :items_view do
    ul Classes::ListItems, ListItemSearchController.itemList_target do
      div ListItemSearchController.addDisplayContainer_target, Classes::AddItemDisplayHidden, ListItem.active(false) do
        Crumble::Material::ListItem.to_html do
          li Classes::ListItem do
            div Classes::AddItemForm do
              add_item_action_template.to_html
              span ListItemSearchController.add_action("click") do
                Crumble::Material::Icon.new("add_circle")
              end
              span ListItemSearchController.disable_search_mode_action("click") do
                Crumble::Material::Icon.new("cancel")
              end
            end
          end
        end
      end
      reorder_list_items_action_template.to_html
    end
  end
end
