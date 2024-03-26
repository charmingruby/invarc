defmodule Invarc.Common.Security do
  @moduledoc """
  Security module to deal with hashes along the application
  """

  def hash(value) when is_binary(value) do
    Argon2.hash_pwd_salt(value)
  end

  def hash(_), do: {:error, "Invalid value to hash"}

  def verify_hash(value, hash) do
    Argon2.verify_pass(value, hash)
  end
end
