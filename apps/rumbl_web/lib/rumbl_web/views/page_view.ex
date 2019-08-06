defmodule RumblWeb.PageView do
  use RumblWeb, :view

  def render("404.html", _assigns) do
    "Page not Found"
  end
end
