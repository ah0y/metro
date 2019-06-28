defmodule MetroWeb.CheckboxHelper do
  use Phoenix.HTML

  def multiselect_checkboxes(form, field, options, opts \\ []) do
    {selected, _} = get_selected_values(form, field, opts)

    # HACK: If there is an error on the form, we inspect the posted params
    # as expected, but they may be strings and we're converting ints.
    selected_as_strings = Enum.map(selected, &"#{&1}")

    boxes =
      for {val, key} <- options, into: [] do
        content_tag(:li, class: "checkbox") do
          field_id = input_id(form, field, key)

          checkbox =
            tag(
              :input,
              name: input_name(form, field) <> "[]",
              id: field_id,
              type: "checkbox",
              value: key,
              class: "check_boxes optional",
              checked: Enum.member?(selected_as_strings, "#{key}")
            )

            [checkbox, val]

#          content_tag(:label) do
#            [checkbox, val]
#          end
        end
      end

    content_tag(:div, class: "form-group check_boxes optional") do
      [label(form, field), boxes]
    end
  end

  defp get_selected_values(form, field, opts) do
    {selected, opts} = Keyword.pop(opts, :selected)
    param = field_to_string(field)

    case form do
      %{params: %{^param => sent}} ->
        {sent, opts}

      _ ->
        {selected || input_value(form, field), opts}
    end
  end

  defp field_to_string(field) when is_atom(field), do: Atom.to_string(field)
  defp field_to_string(field) when is_binary(field), do: field
end