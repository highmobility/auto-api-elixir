defmodule AutoApi.TheftAlarmState do
  @moduledoc """
  TheftAlarm state
  """

  alias AutoApi.PropertyComponent

  defstruct status: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "theft_alarm.json"

  @type alarm :: :unarmed | :armed | :triggered

  @type t :: %__MODULE__{
          status: %PropertyComponent{data: alarm} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 2>>
    iex> AutoApi.TheftAlarmState.from_bin(bin)
    %AutoApi.TheftAlarmState{status: %AutoApi.PropertyComponent{data: :triggered}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.TheftAlarmState{status: %AutoApi.PropertyComponent{data: :triggered}}
    iex> AutoApi.TheftAlarmState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
