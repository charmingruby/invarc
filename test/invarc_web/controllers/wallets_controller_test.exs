defmodule InvarcWeb.WalletsControllerTest do
  use InvarcWeb.ConnCase, async: true

  alias Invarc.Common.Pagination
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

  describe "[GET] /api/wallets/:wallet_id" do
    test "it should be able to fetch a wallet by id that the user owns", %{
      conn: conn,
      account: account
    } do
      wallet = insert(:wallet, account_id: account.id)

      wallet_id = wallet.id
      wallet_name = wallet.name
      wallet_funds_applied = wallet.funds_applied
      wallet_funds_received = wallet.funds_received
      account_id = account.id

      assert %{
               "account_id" => ^account_id,
               "funds_applied" => ^wallet_funds_applied,
               "funds_received" => ^wallet_funds_received,
               "id" => ^wallet_id,
               "inserted_at" => _,
               "name" => ^wallet_name,
               "updated_at" => _
             } =
               conn
               |> get("/api/wallets/#{wallet.id}")
               |> json_response(200)
    end

    test "it should not be able to fetch a wallet by id that the user don't owns", %{
      conn: conn
    } do
      dummy_account = insert(:account, email: "alternativedummy@email.com")

      wallet = insert(:wallet, account_id: dummy_account.id)

      assert %{"message" => "unauthorized", "status" => "unauthorized"} =
               conn
               |> get("/api/wallets/#{wallet.id}")
               |> json_response(401)
    end
  end

  describe "[GET] /api/wallets" do
    test "it should be able to fetch the wallets the user owns", %{
      conn: conn,
      account: account
    } do
      wallet_1 = insert(:wallet, account_id: account.id)
      wallet_2 = insert(:wallet, account_id: account.id)

      wallet_1_id = wallet_1.id
      wallet_2_id = wallet_2.id
      account_id = account.id

      assert [
               %{"account_id" => ^account_id, "id" => ^wallet_1_id},
               %{"account_id" => ^account_id, "id" => ^wallet_2_id}
             ] =
               conn
               |> get("/api/wallets")
               |> json_response(200)
    end

    test "it should be able to fetch the wallets the user owns, even if is empty", %{
      conn: conn
    } do
      assert [] =
               conn
               |> get("/api/wallets")
               |> json_response(200)
    end

    test "it should be able to fetch paginated wallets the user owns", %{
      conn: conn,
      account: account
    } do
      extra_records = 2

      generate_multiple_wallets(Pagination.items_per_page() + extra_records, account.id)

      response =
        conn
        |> get("/api/wallets?page=2")
        |> json_response(200)

      transactions_quantity = length(response)
      assert transactions_quantity == extra_records
    end
  end

  defp generate_multiple_wallets(n, account_id)
       when n <= 1 do
    insert(:wallet, account_id: account_id)
  end

  defp generate_multiple_wallets(n, account_id) do
    insert(:wallet, account_id: account_id)

    generate_multiple_wallets(n - 1, account_id)
  end
end
