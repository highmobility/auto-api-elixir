defmodule AutoApi.FailureMessageState do
  @moduledoc """
  Keeps Failure Message state
  """

  alias AutoApi.PropertyComponent

  @type failure_reason ::
          :unsupported_capability
          | :unauthorised
          | :unauthorized
          | :incorrect_state
          | :execution_timeout
          | :vehicle_asleep
          | :invalid_command
          | :pending
          | :rate_limit

  @doc """
  FailureMessage state
  """
  defstruct failed_message_id: nil,
            failed_message_type: nil,
            failure_reason: nil,
            failure_description: nil,
            failed_property_ids: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/failure_message.json"

  @type t :: %__MODULE__{
          failed_message_id: %PropertyComponent{data: integer} | nil,
          failed_message_type: %PropertyComponent{data: integer} | nil,
          failure_reason: %PropertyComponent{data: failure_reason} | nil,
          failure_description: %PropertyComponent{data: String.t()} | nil,
          failed_property_ids: %PropertyComponent{data: binary()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<4, 0, 21, 1, 0, 18, 115, 111, 109, 101, 116, 104, 105, 110, 103, 32, 104, 97, 112, 112, 101, 110, 101, 100>>
    iex> AutoApi.FailureMessageState.from_bin(bin)
    %AutoApi.FailureMessageState{failure_description: %AutoApi.PropertyComponent{data: "something happened"}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    bin
    |> parse_bin_properties(%__MODULE__{})
    |> unify_unauthorized_from_bin
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.FailureMessageState{failure_description: %AutoApi.PropertyComponent{data: "something happened"}}
    iex> AutoApi.FailureMessageState.to_bin(state)
    <<4, 0, 21, 1, 0, 18, 115, 111, 109, 101, 116, 104, 105, 110, 103, 32, 104, 97, 112, 112, 101, 110, 101, 100>>
  """
  def to_bin(%__MODULE__{} = state) do
    state
    |> unify_unauthorized_to_bin
    |> parse_state_properties()
  end

  defp unify_unauthorized_from_bin(
         %{failure_reason: %{data: :unauthorised} = failure_reason} = state
       ) do
    %{state | failure_reason: %{failure_reason | data: :unauthorized}}
  end

  defp unify_unauthorized_from_bin(value), do: value

  defp unify_unauthorized_to_bin(
         %{failure_reason: %{data: :unauthorized} = failure_reason} = state
       ) do
    %{state | failure_reason: %{failure_reason | data: :unauthorised}}
  end

  defp unify_unauthorized_to_bin(value), do: value
end
