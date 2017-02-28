defmodule Action.UserView do
  use Action.Web, :view
  alias Action.User

  def email(%User{email: email}) do
    email
  end
end
