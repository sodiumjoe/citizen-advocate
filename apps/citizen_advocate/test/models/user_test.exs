defmodule CitizenAdvocate.UserTest do
  use CitizenAdvocate.ModelCase

  alias CitizenAdvocate.User

  @valid_attrs %{name: "some content", email: "test@testing.com", password: "some content", zip: "97212"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
