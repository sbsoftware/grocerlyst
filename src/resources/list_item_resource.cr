class ListItemResource < ApplicationResource
  def update
    body = @ctx.request.body
    unless body.nil?
      li = list_item

      HTTP::Params.parse(body.gets_to_end).each do |name, value|
        case name
        when "name"
          li.name = value
        end
      end
      li.save
    end
  end

  def list_item
    ListItem.find(id)
  end
end
