defmodule InvarcWeb.AccountsControllerTest do
  alias Invarc.Common.Pagination
  alias InvarcWeb.Security.Guardian
  use InvarcWeb.ConnCase, async: true

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

  describe "[GET] /api/accounts/me/transactions" do
    test "it should be able to fetch accounts transactions", %{conn: conn, account: account} do
      wallet = insert(:wallet, account_id: account.id)
      category = insert(:investment_category, account_id: account.id)
      investment = insert(:investment, category_id: category.id, wallet_id: wallet.id)

      transaction_1 =
        insert(:transaction,
          account_id: account.id,
          investment_id: investment.id,
          category_id: category.id,
          wallet_id: wallet.id
        )

      transaction_2 =
        insert(:transaction,
          account_id: account.id,
          investment_id: investment.id,
          category_id: category.id,
          wallet_id: wallet.id
        )

      transaction_3 =
        insert(:transaction,
          account_id: account.id,
          investment_id: investment.id,
          category_id: category.id,
          wallet_id: wallet.id
        )

      account_id = account.id
      wallet_id = wallet.id
      category_id = category.id
      investment_id = investment.id
      transaction_1_id = transaction_1.id
      transaction_2_id = transaction_2.id
      transaction_3_id = transaction_3.id

      assert [
               %{
                 "account_id" => ^account_id,
                 "category_id" => ^category_id,
                 "investment_id" => ^investment_id,
                 "id" => ^transaction_1_id,
                 "wallet_id" => ^wallet_id
               },
               %{
                 "account_id" => ^account_id,
                 "category_id" => ^category_id,
                 "id" => ^transaction_2_id,
                 "investment_id" => ^investment_id,
                 "wallet_id" => ^wallet_id
               },
               %{
                 "account_id" => ^account_id,
                 "category_id" => ^category_id,
                 "id" => ^transaction_3_id,
                 "investment_id" => ^investment_id,
                 "wallet_id" => ^wallet_id
               }
             ] =
               conn
               |> get("/api/accounts/me/transactions?page=1")
               |> json_response(200)
    end

    test "it should be able to fetch paginated accounts transactions", %{
      conn: conn,
      account: account
    } do
      wallet = insert(:wallet, account_id: account.id)
      category = insert(:investment_category, account_id: account.id)
      investment = insert(:investment, category_id: category.id, wallet_id: wallet.id)

      extra_records = 2

      generate_multiple_transactions(
        Pagination.items_per_page() + extra_records,
        account.id,
        investment.id,
        category.id,
        wallet.id
      )

      response =
        conn
        |> get("/api/accounts/me/transactions?page=2")
        |> json_response(200)

      transactions_quantity = length(response)
      assert transactions_quantity == extra_records
    end
  end

  defp generate_multiple_transactions(n, account_id, investment_id, category_id, wallet_id)
       when n <= 1 do
    insert(:transaction,
      account_id: account_id,
      investment_id: investment_id,
      category_id: category_id,
      wallet_id: wallet_id
    )
  end

  defp generate_multiple_transactions(n, account_id, investment_id, category_id, wallet_id) do
    insert(:transaction,
      account_id: account_id,
      investment_id: investment_id,
      category_id: category_id,
      wallet_id: wallet_id
    )

    generate_multiple_transactions(n - 1, account_id, investment_id, category_id, wallet_id)
  end
end
