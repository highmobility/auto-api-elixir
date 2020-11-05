defmodule AutoApiL11.TheftAlarmState do
  @moduledoc """
  TheftAlarm state
  """

  alias AutoApiL11.PropertyComponent

  defstruct status: nil,
            timestamp: nil

  use AutoApiL11.State, spec_file: "specs/theft_alarm.json"

  @type alarm :: :unarmed | :armed | :triggered

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: alarm} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 2>>
    iex> AutoApiL11.TheftAlarmState.from_bin(bin)
    %AutoApiL11.TheftAlarmState{status: %AutoApiL11.PropertyComponent{data: :triggered}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApiL11.TheftAlarmState{status: %AutoApiL11.PropertyComponent{data: :triggered}}
    iex> AutoApiL11.TheftAlarmState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
