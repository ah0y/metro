defmodule MetroWeb.UserView do
  use MetroWeb, :view

  def due_date(due_date) do
    if NaiveDateTime.compare(due_date, NaiveDateTime.utc_now()) == :lt do
      ~e"""
      <td style="color: red"><%= due_date %></td>
      """
    else
      ~e"""
      <td><%= due_date %></td>
      """
    end
  end
end
