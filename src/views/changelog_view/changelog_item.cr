require "./change_type"

class ChangelogItem
  getter change_title : String
  getter description : String?
  getter change_type : ChangeType

  def initialize(@change_title, @change_type, @description = nil)
  end

  ToHtml.instance_template do
    li do
      span(Classes::ChangeType, change_type.css_class) { change_type }
      span(Classes::ChangeTitle) { change_title }
      span(Classes::ChangeDescription) { description } if description
    end
  end
end
