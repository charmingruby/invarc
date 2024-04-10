defmodule InvarcWeb.InvestmentsControllerTest do
  use InvarcWeb.ConnCase, async: true

  alias InvarcWeb.Security.Guardian

  setup ctx do
    acc =
      insert(:account,
        email: "dummy@email.com",
        password_hash: Argon2.hash_pwd_salt("password123")
      )

    {:ok, token, _payload} = Guardian.generate_token(acc)

    authenticated_conn = put_req_header(ctx.conn, "authorization", "Bearer #{token}")

    %{
      conn: authenticated_conn,
      account: acc
    }
  end

  describe "[POST] /api/investments/categories" do
    @valid_params %{
      name: "dummy category name"
    }

    test "it should be able to create a new investment category in an account", %{
      conn: conn,
      account: account
    } do
      body = %{
        name: @valid_params.name
      }

      result =
        conn
        |> post("/api/investments/categories", body)
        |> json_response(201)

      assert result["name"] == @valid_params.name
      assert result["account_id"] == account.id
    end

    test "it should be able to create a new investment category with a name already taken by another account",
         %{conn: conn, account: account} do
      dummy_account = insert(:account, email: "dummy_example@email.com")

      insert(:investment_category,
        name: @valid_params.name,
        account_id: dummy_account.id
      )

      body = %{
        name: @valid_params.name
      }

      result =
        conn
        |> post("/api/investments/categories", body)
        |> json_response(201)

      assert result["name"] == @valid_params.name
      assert result["account_id"] == account.id
    end

    test "it should not be able to create a new investment category with a name already taken by the account",
         %{conn: conn, account: account} do
      insert(:investment_category,
        name: @valid_params.name,
        account_id: account.id
      )

      body = %{
        name: @valid_params.name
      }

      assert %{"message" => "name is already taken", "status" => "conflict"} =
               conn
               |> post("/api/investments/categories", body)
               |> json_response(409)
    end
  end
end
