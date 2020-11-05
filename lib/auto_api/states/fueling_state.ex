defmodule AutoApiL11.FuelingState do
  @moduledoc """
  Fueling state
  """

  alias AutoApiL11.{CommonData, PropertyComponent}

  defstruct gas_flap_position: nil,
            gas_flap_lock: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/fueling.json"

  @type gas_flap_position :: :closed | :open

  @type t :: %__MODULE__{
          gas_flap_position: %PropertyComponent{data: gas_flap_position} | nil,
          gas_flap_lock: %PropertyComponent{data: CommonData.lock()} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<3, 0, 4, 1, 0, 1, 0>>
    iex> AutoApiL11.FuelingState.from_bin(bin)
    %AutoApiL11.FuelingState{gas_flap_position: %AutoApiL11.PropertyComponent{data: :closed}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.FuelingState{gas_flap_position: %AutoApiL11.PropertyComponent{data: :closed}}
    iex> AutoApiL11.FuelingState.to_bin(state)
    <<3, 0, 4, 1, 0, 1, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
