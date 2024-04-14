defmodule InvarcWeb.InvestmentsControllerTest do
  use InvarcWeb.ConnCase, async: true

  alias Invarc.Investments.Changesets.TransactionChangesets
  alias Invarc.Investments.Loaders.{TransactionLoaders, WalletLoaders}
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

    test "it should be able to create a new investment category for an account", %{
      conn: conn,
      account: account
    } do
      body = %{
        "name" => @valid_params.name
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

  describe "[POST] /api/investments" do
    test "it should be able to create a new investment for an account", %{
      conn: conn,
      account: account
    } do
      wallet = insert(:wallet, account_id: account.id)
      category = insert(:investment_category, account_id: account.id)

      body = %{
        "name" => "dummy_investment",
        "description" => "dummy investment description",
        "source" => "dummy_investment_company",
        "value" => 10_000,
        "category_id" => category.id,
        "wallet_id" => wallet.id
      }

      result =
        conn
        |> post("/api/investments", body)
        |> json_response(201)

      parsed_value = body["value"] / 100
      empty_resultant_value = 0.0

      assert result["category_id"] == category.id
      assert result["description"] == body["description"]
      assert result["initial_value"] == parsed_value
      assert result["name"] == body["name"]
      assert result["resultant_value"] == empty_resultant_value
      assert result["source"] == body["source"]
      assert result["wallet_id"] == wallet.id

      {:ok, transactions_list} = TransactionLoaders.load_many_by_investment_id(result["id"])

      assert length(transactions_list) == 1

      transaction = hd(transactions_list)

      assert transaction.wallet_id == wallet.id
      assert transaction.category_id == category.id
      assert transaction.amount == body["value"]
    end
  end

  describe "[POST] /api/investments/:wallet_id/withdraw/:investment_id" do
    test "it should be able to withdraw an available investment", %{
      conn: conn,
      account: account
    } do
      initial_funds = 100_000
      transacted_funds = 150_000

      wallet =
        insert(:wallet, account_id: account.id, funds_applied: initial_funds, funds_received: 0)

      category = insert(:investment_category, account_id: account.id)

      investment =
        insert(:investment,
          category_id: category.id,
          wallet_id: wallet.id,
          initial_value: initial_funds
        )

      outcome_transaction =
        insert(:transaction,
          name:
            TransactionChangesets.build_transaction_name(%{
              wallet_name: wallet.name,
              type: "outcome"
            }),
          investment_id: investment.id,
          category_id: category.id,
          wallet_id: wallet.id,
          amount: initial_funds,
          type: "outcome",
          status: "success"
        )

      body = %{
        "resultant_value" => transacted_funds
      }

      wallet_id = wallet.id
      category_id = category.id
      parsed_resultant_value = body["resultant_value"] / 100
      parsed_initial_funds = initial_funds / 100
      investment_description = investment.description
      investment_name = investment.name
      investment_source = investment.source

      assert %{
               "category_id" => ^category_id,
               "description" => ^investment_description,
               "id" => _,
               "initial_value" => ^parsed_initial_funds,
               "inserted_at" => _,
               "name" => ^investment_name,
               "resultant_value" => ^parsed_resultant_value,
               "source" => ^investment_source,
               "updated_at" => _,
               "wallet_id" => ^wallet_id
             } =
               conn
               |> post("/api/investments/#{wallet.id}/withdraw/#{investment.id}", body)
               |> json_response(200)

      {:ok, transactions_list} = TransactionLoaders.load_many_by_investment_id(investment.id)
      assert length(transactions_list) == 2

      [%{type: "outcome"} = out_transaction, %{type: "income"} = in_transaction] =
        transactions_list

      assert out_transaction.id == outcome_transaction.id
      assert in_transaction.wallet_id == wallet.id
      assert in_transaction.category_id == category.id
      assert in_transaction.amount == transacted_funds

      {:ok, wallet} = WalletLoaders.load_one_by_id(wallet.id)
      assert wallet.funds_received == transacted_funds
    end

    test "it should not be able to withdraw an investment not available", %{
      conn: conn,
      account: account
    } do
      initial_funds = 100_000
      transacted_funds = 150_000

      wallet =
        insert(:wallet,
          account_id: account.id,
          funds_applied: initial_funds,
          funds_received: transacted_funds
        )

      category = insert(:investment_category, account_id: account.id)

      investment =
        insert(:investment,
          category_id: category.id,
          wallet_id: wallet.id,
          initial_value: initial_funds,
          resultant_value: transacted_funds
        )

      insert(:transaction,
        name:
          TransactionChangesets.build_transaction_name(%{
            wallet_name: wallet.name,
            type: "outcome"
          }),
        investment_id: investment.id,
        category_id: category.id,
        wallet_id: wallet.id,
        amount: initial_funds,
        type: "outcome",
        status: "success"
      )

      insert(:transaction,
        name:
          TransactionChangesets.build_transaction_name(%{
            wallet_name: wallet.name,
            type: "income"
          }),
        investment_id: investment.id,
        category_id: category.id,
        wallet_id: wallet.id,
        amount: transacted_funds,
        type: "income",
        status: "success"
      )

      body = %{
        "resultant_value" => transacted_funds
      }

      assert %{"errors" => "investment already withdrawed", "status" => "bad_request"} =
               conn
               |> post("/api/investments/#{wallet.id}/withdraw/#{investment.id}", body)
               |> json_response(400)
    end
  end
end
