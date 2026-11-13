class ListContextMenu
  include Crumble::ContextView
  include Crumble::Crababel

  getter list : List

  def initialize(@ctx, @list); end

  css_class Entry

  template do
    Crumble::Material::ContextMenu.new(icon_name: "more_vert", label: t.label).to_html do
      ViewListMembersButton.new(ctx: ctx, list: list)
      ShareList.new(ctx: ctx, list: list)
      ViewListActionLogButton.new(ctx: ctx, list: list)
    end
  end

  style do
    rule Entry do
      display :flex
      align_items :center
      gap 12.px
      width 100.percent
      box_sizing :border_box
      padding 12.px, 16.px
      border 0
      background_color :transparent
      color :inherit
      font_size :inherit
      font_family :inherit
      text_decoration :none
      text_align :left
      cursor :pointer
    end

    rule Entry && ":hover", Entry && ":focus-visible" do
      background_color "#EAF6EF"
    end

    rule Entry && ":focus-visible" do
      outline 2.px, :solid, "#2F6D45"
      outline_offset -2.px
    end

    # The sharing controller wraps its button in an inline-block container.
    rule Crumble::Material::ContextMenu::Body > Orma::Record::Accessible::ShareElement::ShareContainer do
      display :block
    end
  end
end
