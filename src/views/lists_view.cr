class ListsView < Template
  @lists : Array(List)

  def initialize(@lists)
  end

  template do
    @lists.each do |list|
      strong { list.id }
      i { list.name }
      i { list.created_at }
    end
  end
end
