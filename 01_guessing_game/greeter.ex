defmodule Greeter do
  @author "Tony"
  def start do
    name =
      IO.gets("Hi there! What is your name?\n")
      |> String.trim()
      |> String.capitalize()

    if name === @author do
      "Wow! #{@author} is my favorite name. " <>
        "I was programmed by someone named #{@author}."
    else
      "Hello #{name}, its nice to meet you."
    end
  end
end
