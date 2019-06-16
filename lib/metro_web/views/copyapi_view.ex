defmodule MetroWeb.CopyApiView do
  use MetroWeb, :view

  def copy_json(copy) do
    %{
      isbn: copy.isbn_id,
      checked_out?: copy.checked_out?,
      library: copy.library_id
    }
  end


  def render("show.json", %{copy: copy}) do
    %{copy: copy_json(copy)}
  end
end