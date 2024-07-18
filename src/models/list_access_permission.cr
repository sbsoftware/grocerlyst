require "./list"

class ListAccessPermission < Orma::Record
  id_column id : Int32?
  column list_id : Int32?
  column session_id : String?
  column created_at : Time?

  def list
    List.where({"id" => list_id})
  end
end
