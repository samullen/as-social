defmodule SocialWeb.PageController do
  use SocialWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
