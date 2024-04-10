defmodule InvarcWeb.SessionsControllerTest do
  use InvarcWeb.ConnCase, async: true

  setup ctx do
    acc =
      insert(:account,
        email: "dummy@email.com",
        password_hash: Argon2.hash_pwd_salt("password123")
      )

    %{
      conn: ctx.conn,
      account: acc
    }
  end

  describe "[POST] /api/sessions" do
    @valid_credentials %{
      email: "dummy@email.com",
      password: "password123"
    }

    @invalid_credentials %{
      email: "invalid_email@invalid.com",
      password: "not the password"
    }

    test "it should be able to authenticate with a valid payload", %{conn: conn} do
      body = %{
        "email" => @valid_credentials.email,
        "password" => @valid_credentials.password
      }

      result =
        conn
        |> post("/api/sessions", body)
        |> json_response(200)

      assert nil != result["access_token"]
    end

    test "it should not be able to authenticate with a invalid email", %{conn: conn} do
      body = %{
        "email" => @invalid_credentials.email,
        "password" => @invalid_credentials.password
      }

      assert %{"message" => "invalid credentials", "status" => "unauthorized"} =
               conn
               |> post("/api/sessions", body)
               |> json_response(401)
    end

    test "it should not be able to validate authentication with invalid password", %{conn: conn} do
      body = %{
        "email" => @valid_credentials.email,
        "password" => @invalid_credentials.password
      }

      assert %{"message" => "invalid credentials", "status" => "unauthorized"} =
               conn
               |> post("/api/sessions", body)
               |> json_response(401)
    end
  end
end
