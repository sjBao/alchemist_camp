defmodule MinimalTodo do
  def start do
    filename = IO.gets("Name of .csv to load: ") |> String.trim()

    read(filename)
    |> parse
    |> get_command
  end

  def get_command(data) do
    prompt = """
    Type the first letter of the command you want to run
    R)ead Todos   A)dd a Todo    D) Delete a Todo    L)oad a .csv    S)ave a .csv
    """

    command =
      IO.gets(prompt)
      |> String.trim()
      |> String.downcase()

    case command do
      "r" -> show_todos(data)
      "d" -> delete_todo(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def delete_todo(data) do
    show_todos(data, false)
    todo = IO.gets("Which todo would you like to delete?\n") |> String.trim()

    cond do
      Map.has_key?(data, todo) ->
        IO.puts("ok.")
        new_map = Map.drop(data, [todo])
        IO.puts(~s("#{todo}" has been deleted.))
        get_command(new_map)

      todo == "q" ->
        get_command(data)

      true ->
        IO.puts(~s(There is no Todo named "#{todo}"!))
        delete_todo(data)
    end
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body} ->
        inspect(body)
        body

      {:error, reason} ->
        IO.puts(~s(Could not open file "#{filename}"\n))
        IO.inspect(reason)
        start()
    end
  end

  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = tl(String.split(header, ","))
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")

      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("You have the following Todos:\n")
    Enum.each(items, fn item -> IO.puts(item) end)
    IO.puts("\n")

    if next_command? do
      get_command(data)
    end
  end
end
