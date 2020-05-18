defmodule AutoApi.DoorsState do
  @moduledoc """
  Door position possible values: :closed, :open
  Door lock possible values: :unlocked, :locked
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct inside_locks: [],
            locks: [],
            positions: [],
            inside_locks_state: nil,
            locks_state: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "doors.json"

  @type lock :: %PropertyComponent{
          data: %{
            location: CommonData.location() | :all,
            lock_state: CommonData.lock()
          }
        }

  @type inside_lock :: %PropertyComponent{
          data: %{
            location: CommonData.location() | :all,
            lock_state: CommonData.lock()
          }
        }

  @type position :: %PropertyComponent{
          data: %{
            location: CommonData.location() | :all,
            position: CommonData.position()
          }
        }

  @type t :: %__MODULE__{
          inside_locks: list(inside_lock),
          locks: list(lock),
          positions: list(position),
          inside_locks_state: CommonData.lock() | nil,
          locks_state: CommonData.lock() | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.DoorsState.from_bin(<<0x03, 5::integer-16, 0x01, 2::integer-16, 0x00, 0x01>>)
    %AutoApi.DoorsState{locks: [%AutoApi.PropertyComponent{data: %{location: :front_left, lock_state: :locked}}]}

    iex> AutoApi.DoorsState.from_bin(<<0x04, 5::integer-16,  0x01, 2::integer-16, 0x05, 0x00>>)
    %AutoApi.DoorsState{positions: [%AutoApi.PropertyComponent{data: %{location: :all, position: :closed}}]}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.DoorsState.to_bin(%AutoApi.DoorsState{positions: [%AutoApi.PropertyComponent{data: %{location: :front_left, position: :open}}]})
    <<0x04, 5::integer-16, 0x01, 2::integer-16, 0x00, 0x01>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
