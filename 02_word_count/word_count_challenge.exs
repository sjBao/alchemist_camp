filename =
  IO.gets("File to count the words from: ")
  |> String.trim()

count_type =
  IO.gets(~s{What would you like to count?\nwords, chars, lines\n})
  |> String.trim()

my_count = fn filename, strategy ->
  File.read!(filename)
  |> String.split(strategy)
  |> Enum.count()
end

case count_type do
  "words" ->
    filename
    |> my_count.(~r{(\\n|[^\w'])+})
    |> Enum.filter(fn x -> x != "" end)
    |> IO.puts()

  "chars" ->
    filename
    |> my_count.("")
    |> Enum.filter(fn x -> x != "" end)
    |> IO.puts()

  "lines" ->
    filename
    |> my_count.(~r{\n})
    |> IO.puts()

  _ ->
    IO.puts("Unrecognized option")
end
