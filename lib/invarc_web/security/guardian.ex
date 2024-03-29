defmodule InvarcWeb.Security.Guardian do
  @moduledoc """
  Guardian module setup
  """

  use Guardian, otp_app: :invarc

  alias Invarc.Accounts.Loaders.AccountLoaders
  alias Invarc.Accounts.Models.Account

  # 7 days
  @access_token_time 60 * 24 * 7

  def subject_for_token(%Account{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> AccountLoaders.one_by_id()
  end

  def generate_token(account) do
    encode_and_sign(
      account,
      %{},
      ttl: {@access_token_time, :minute},
      token_type: "access"
    )
  end
end
