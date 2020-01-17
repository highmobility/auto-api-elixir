defmodule AutoApi.IgnitionState do
  @moduledoc """
  Keeps Ignition state
  """

  alias AutoApi.PropertyComponent

  @type on_off :: :on | :off

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: on_off} | nil,
          accessories_status: %PropertyComponent{data: on_off} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Ignition state
  """
  defstruct status: nil,
            accessories_status: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/ignition.json"

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 0>>
    iex> AutoApi.IgnitionState.from_bin(bin)
    %AutoApi.IgnitionState{status: %AutoApi.PropertyComponent{data: :off}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin

    iex> state = %AutoApi.IgnitionState{status: %AutoApi.PropertyComponent{data: :off}}
    iex> AutoApi.IgnitionState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 0>>
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
