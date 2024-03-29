defmodule InvarcWeb.ErrorJSON do
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  # -
  # Authentication errors
  # -
  def error(%{status: :invalid_credentials}) do
    %{
      status: :unauthorized,
      message: "invalid credentials"
    }
  end

  # -
  # Not Found
  # -
  def error(%{error: %{status: :not_found, entity: entity}}) do
    %{
      status: :not_found,
      message: "#{entity} not found"
    }
  end

  # -
  # Conflict errors
  # -
  def error(%{error: %{status: :conflict, field: field}}) do
    %{
      status: :conflict,
      message: "#{field} is already taken"
    }
  end

  # -
  # Bad request errors
  # -
  def error(%{error: %{status: :bad_request, params: params}}) do
    %{
      status: :bad_request,
      errors: params
    }
  end

  # -
  # Not handled error
  # -
  def error(%{error: %{status: :internal_server_error, reason: reason}}) do
    %{
      status: :internal_server_error,
      error: reason
    }
  end

  # -
  # Changeset errors
  # -
  def error(%{error: %{status: :unprocessable_entity, changeset: changeset}}) do
    %{
      status: :unprocessable_entity,
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)
    }
  end

  defp translate_errors({msg, opts}) do
    Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
