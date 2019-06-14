defmodule MetroWeb.WaitlistView do
  use MetroWeb, :view
  import Scrivener.HTML

  @distance 10
  @first "<<"
  @previous "<"
  @next ">"
  @last ">>"
  @ellipsis false

  def pagination_params(params) do
    params
    |> Map.delete("page")
    |> Map.put("distance", @distance)
    |> map_to_keyword_list()
  end

  defp map_to_keyword_list(map) when is_map(map),
       do: Enum.map(map, fn {k, v} -> {String.to_atom(k), map_to_keyword_list(v)} end)

  defp map_to_keyword_list(value), do: value
end
