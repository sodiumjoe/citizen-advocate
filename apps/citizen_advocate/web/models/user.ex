defmodule CitizenAdvocate.User do
  use CitizenAdvocate.Web, :model
  require Logger

  @email_regex ~r/^(?<user>[^\s]+)@(?<domain>[^\s]+\.[^\s]+)$/
  @congress_url "https://congress.api.sunlightfoundation.com/districts/locate"

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :zip, :string

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
    url = "#{@congress_url}?#{URI.encode_query(%{"zip" => zip})}"
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

end
