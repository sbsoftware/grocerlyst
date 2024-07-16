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
