defmodule InvarcWeb.Helpers.Response do
  def wrap_response(status_code, msg, data) do
    %{
      message: msg,
      status_code: status_code,
      data: data
    }
  end
end
