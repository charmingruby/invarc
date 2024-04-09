defmodule InvarcWeb.AccountsControllerTest do
  use InvarcWeb.ConnCase, async: true

  describe "[POST] /api/accounts" do
    test "it should be able to create a new account", %{conn: conn} do
      body = %{
        "name" => "Dummy Name",
        "email" => "dummy@example.com",
        "password" => "password123"
      }

      name = body["name"]
      email = body["email"]

      result =
        conn
        |> post("/api/accounts", body)
        |> json_response(201)

      assert result["name"] == name
      assert result["email"] == email
    end

    test "it should be not able to create a new account with an email that is already taken", %{
      conn: conn
    } do
      conflicted_email = "dummy@example.com"

      insert(:account, email: conflicted_email)

      body = %{
        "name" => "Dummy Name",
        "email" => conflicted_email,
        "password" => "password123"
      }

      assert %{
               "message" => "email is already taken",
               "status" => "conflict"
             } =
               conn
               |> post("/api/accounts", body)
               |> json_response(409)
    end
  end
end
