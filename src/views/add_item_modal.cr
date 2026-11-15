class AddItemModal
  include Crumble::ContextView
  include Crumble::Crababel

  getter list : List

  def initialize(@ctx, @list); end

  css_class Dialog
  css_class Controls
  css_class Results
  css_id Title
  css_id NameInput

  class AppBarAction
    include Crumble::ContextView
    include Crumble::Crababel

    css_class Button

    def initialize(@ctx); end

    ToHtml.instance_template do
      button Button, ListItemSearchController.open_action("click"), ListItemSearchController.param("placement", "top"), type: "button", aria: {label: t.label, haspopup: "dialog"} do
        Crumble::Material::Icon.new("add_circle")
      end
    end

    style do
      rule Button do
        # Fit the app bar's 24px trailing-icon slot, like the context-menu trigger.
        padding 0
      end
    end
  end

  template do
    dialog Dialog, ListItemSearchController.dialog_target, ListItemSearchController.closed_action("close"), ListItemSearchController.backdrop_action("click"), ListItemSearchController.submitted_action("turbo:submit-end"), ListItemSearchController.before_cache_action("turbo:before-cache@document"), aria: {labelledby: Title.to_s} do
      div Controls do
        h2 Title do
          t.title
        end
        button ListItemSearchController.close_action("click"), type: "button", aria: {label: t.close} do
          Crumble::Material::Icon.new("close")
        end
      end
      form Controls, ListItemSearchController.form_target, ListItemSearchController.validate_action("submit"), action: List::AddItemAction.uri_path(list.id), method: "POST" do
        input ListItemSearchController.placement_target, name: "placement", type: "hidden", value: "bottom"
        label for: NameInput.to_s do
          t.name
        end
        input NameInput, ListItemSearchController.input_target, ListItemSearchController.filter_action("input"), name: "name", type: "text", required: true, autocomplete: "off"
        button ListItemSearchController.add_action("click"), type: "button", aria: {label: t.add} do
          Crumble::Material::Icon.new("add_circle")
        end
        input type: "submit", hidden: true
      end
      p ListItemSearchController.error_target, role: "alert", hidden: true do
        t.error
      end
      div Results do
        list.search_results_view(ctx)
      end
    end
  end

  style do
    rule Dialog do
      width 560.px
      height 560.px
      max_width calc(100.vw - 32.px)
      max_height calc(100.dvh - 32.px)
      box_sizing :border_box
      padding 16.px
      border 0
      border_radius 16.px
      background_color :white
      color :black
      overflow :hidden
    end

    # Only open dialogs participate in flex layout; closed dialogs stay hidden.
    rule Dialog && "[open]" do
      display :flex
      flex_direction :column
    end

    rule Dialog && "::backdrop" do
      background_color "#0008"
    end

    rule Controls do
      display :flex
      flex_shrink 0
      align_items :center
      gap 8.px

      rule h2 do
        flex_grow 1
        margin 0, 0, 16.px
      end

      rule "input[type=text]" do
        flex_grow 1
        min_width 0
        font_size 1.em
      end
    end

    rule Results do
      margin_top 16.px
      flex_grow 1
      min_height 0
      overflow :auto
      property "scrollbar-gutter", "stable"

      rule li do
        list_style :none
      end
    end
  end
end
