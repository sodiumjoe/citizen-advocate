defmodule CitizenAdvocate.Emails do
  import Bamboo.Email
  use Bamboo.Phoenix, view: CitizenAdvocate.EmailView
  alias CitizenAdvocate.Router.Helpers
  alias CitizenAdvocate.Endpoint

  def confirm_email(%{:email => email, :id => id}, token) do
    url = Helpers.user_url(Endpoint, :confirm, id: id, token: token)
    new_email()
    |> put_header("Reply-To", "mail@citizen-advocate.org")
    |> to(email)
    |> from("mail@citizen-advocate.org")
    |> subject("Please confirm your email address")
    |> render(:welcome, email: email, url: url)
  end

end
