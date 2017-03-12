defmodule CitizenAdvocate.User do
  use CitizenAdvocate.Web, :model

  @email_regex ~r/^(?<user>[^\s]+)@(?<domain>[^\s]+\.[^\s]+)$/
  @congress_url "https://congress.api.sunlightfoundation.com/districts/locate"

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :zip, :string
    field :confirmed_at, Ecto.DateTime
    field :hashed_confirmation_token, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :zip])
    |> validate_required([:name, :email, :password, :zip])
    |> validate_zip()
    |> downcase_email()
    |> validate_email()
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password))
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp validate_email(changeset) do
    email = get_field(changeset, :email)
    if !is_nil(email) && Regex.match?(@email_regex, email) do
      changeset
    else
      add_error(changeset, :email, "Invalid email address.")
    end
  end

  def validate_zip(changeset) do
    zip = get_field(changeset, :zip)
    query = %{"zip" => zip}
    url = "#{@congress_url}?#{URI.encode_query(query)}"
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
         {:ok, %{"count" => 1}} <- Poison.decode(body) do
      changeset
    else
      _ ->
        add_error(changeset, :zip, "Invalid zip code.")
    end
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end

  defp downcase_email(changeset) do
    email = get_change(changeset, :email)
    if is_nil(email) do
      changeset
    else
      put_change(changeset, :email, String.downcase(email))
    end
  end

  def confirmation_changeset(user, params = %{"token" => token}) do
    user
    |> cast(params, [])
    |> put_change(:hashed_confirmation_token, nil)
    |> put_change(:confirmed_at, Ecto.DateTime.utc())
    |> validate_token(token)
  end

  alias Comeonin.Bcrypt

  defp validate_token(changeset, token) do
    if Bcrypt.checkpw(token, changeset.data.hashed_confirmation_token) do
      changeset
    else
      add_error(changeset, :confirmation_token, "invalid")
    end
  end

  def confirmation_needed_changeset(changeset) do
    token = SecureRandom.urlsafe_base64(64)
    hashed_token = Comeonin.Bcrypt.hashpwsalt(token)

    changeset =
      changeset
      |> put_change(:hashed_confirmation_token, hashed_token)

    {token, changeset}
  end

end
