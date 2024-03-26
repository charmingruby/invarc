defmodule InvarcWeb.Helpers.Response do
  @moduledoc """
  Module with auxiliary methods for responses
  """

  def wrap_response(status_code, msg, data) do
    %{
      message: msg,
      status_code: status_code,
      data: data
    }
  end
end
