defmodule InvarcWeb.WalletsControllerTest do
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

  describe "[POST] /api/wallets" do
    @valid_params %{
      name: "dummy wallet"
    }

    test "it should be able to create a new wallet", %{conn: conn, account: account} do
      body = %{
        "name" => @valid_params.name
      }

      result =
        conn
        |> post("/api/wallets", body)
        |> json_response(201)

      assert result["name"] == @valid_params.name
      assert result["funds_applied"] == 0
      assert result["funds_received"] == 0
      assert result["account_id"] == account.id
    end

    test "it not should be able to create a new wallet with a name that is already taken by the same account",
         %{
           conn: conn,
           account: account
         } do
      insert(:wallet,
        name: @valid_params.name,
        account_id: account.id
      )

      body = %{
        "name" => @valid_params.name
      }

      assert %{
               "message" => "name is already taken",
               "status" => "conflict"
             } =
               conn
               |> post("/api/wallets", body)
               |> json_response(409)
    end

    test "it should be able to create a new wallet with a name that is already taken by the another account",
         %{
           conn: conn,
           account: account
         } do
      dummy_account = insert(:account, email: "dummy_account@email.com")

      insert(:wallet,
        name: @valid_params.name,
        account_id: dummy_account.id
      )

      body = %{
        "name" => @valid_params.name
      }

      result =
        conn
        |> post("/api/wallets", body)
        |> json_response(201)

      assert result["name"] == @valid_params.name
      assert result["account_id"] == account.id
    end
  end
end
