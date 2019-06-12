import Metro.Factory

insert_list(80000, :user)

insert_list(10, :library)

Enum.map(1..100000, &(
  build(:author, %{id: &1})
  |> insert
  |> with_ten_books
  )
)

Enum.map(1..1000000, &(
  build(:copy_without_book_and_library, %{library_id: Enum.random(1..10), isbn_id: &1})
  |> insert
  ))
