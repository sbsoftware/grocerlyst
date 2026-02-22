class ApplicationTopAppBar
  include Crumble::ContextView

  ToHtml.instance_template do
    Crumble::Material::TopAppBar.new(
      leading_icon: Crumble::Material::NavigationDrawer::MenuSwitch,
      headline: "Grocerlyst",
      trailing_icons: [] of Nil,
      type: :center_aligned
    )
  end
end
