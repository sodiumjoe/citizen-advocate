defmodule CitizenAdvocate.UserView do
  use CitizenAdvocate.Web, :view
  alias CitizenAdvocate.User

  def email(%User{email: email}) do
    email
  end
end
