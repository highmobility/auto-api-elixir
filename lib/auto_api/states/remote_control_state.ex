defmodule AutoApi.RemoteControlState do
  @moduledoc """
  RemoteControl state
  """

  alias AutoApi.PropertyComponent

  defstruct control_mode: nil,
            angle: nil,
            speed: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "remote_control.json"

  @type modes ::
          :control_mode_unavailable
          | :control_mode_available
          | :control_started
          | :control_failed_to_start
          | :control_aborted
          | :control_ended

  @type t :: %__MODULE__{
          control_mode: %PropertyComponent{data: modes} | nil,
          angle: %PropertyComponent{data: integer} | nil,
          speed: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 2>>
    iex> AutoApi.RemoteControlState.from_bin(bin)
    %AutoApi.RemoteControlState{control_mode: %AutoApi.PropertyComponent{data: :started}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.RemoteControlState{control_mode: %AutoApi.PropertyComponent{data: :started}}
    iex> AutoApi.RemoteControlState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
