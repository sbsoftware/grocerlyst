# HACK: Add ordering
class Orma::Query
  getter order_clause : String?

  def order_by_sort_order!
    @order_clause = " ORDER BY sort_order ASC"

    self
  end

  private def find_all_query
    qry = previous_def

    if order = order_clause
      qry + order
    else
      qry
    end
  end
end

# HACK: Add #find for associations
class Orma::Query
  def find(id)
    if where_clause = @where_clause
      @where_clause = "#{where_clause} AND id=#{id}"
    else
      @where_clause = "id=#{id}"
    end

    T.query_one("#{find_all_query} LIMIT 1")
  end
end

# Allow indexing in arrays
class Orma::Record
  def ==(other)
    id.value == other.id.value
  end
end
