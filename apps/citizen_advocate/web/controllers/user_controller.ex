defmodule CitizenAdvocate.UserController do
  use CitizenAdvocate.Web, :controller
  alias CitizenAdvocate.User
  alias CitizenAdvocate.Emails
  alias CitizenAdvocate.Mailer

  plug :authenticate when action in [:show, :confirmation_instructions]

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do

    {token, changeset} = User.registration_changeset(%User{}, user_params)
                         |> User.confirmation_needed_changeset()

    case Repo.insert(changeset) do
      {:ok, user } ->

        Emails.confirm_email(user, token)
        |> Mailer.deliver_now()

        conn
        |> CitizenAdvocate.Auth.login(user)
        |> put_flash(:info, "#{user.email} created!")
        |> redirect(to: user_path(conn, :show, user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  def confirm(conn, params = %{"id" => id, "token" => _token}) do
    case Repo.get(User, id)
    |> User.confirmation_changeset(params)
    |> Repo.update() do
      {:ok, _user } ->
        conn
        |> put_flash(:info, "Successfully confirmed your account")
        |> redirect(to: user_path(conn, :show, id))
      {:error, _changeset} ->
        conn
        |> put_status(422)
        |> put_flash(:error, "Unable to confirm your account")
        |> redirect(to: "/")
    end
  end

  def confirmation_instructions(conn, _params) do
    user = Repo.get(CitizenAdvocate.User, conn.assigns.current_user.id)
    render conn, "confirm.html", user: user
  end

  def resend_confirmation_instructions(conn, _params) do
    {token, changeset} = Repo.get(User, conn.assigns.current_user.id)
                         |> Ecto.Changeset.cast(%{}, [:hashed_confirmation_token])
                         |> User.confirmation_needed_changeset()
    {:ok, user } = Repo.update(changeset)
    Emails.confirm_email(user, token) |> Mailer.deliver_now()
    conn
    |> redirect(to: user_path(conn, :show, user.id))
  end

end
