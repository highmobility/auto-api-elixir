# AutoAPI
# The MIT License
#
# Copyright (c) 2018- High-Mobility GmbH (https://high-mobility.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
defmodule AutoApi.TheftAlarmState do
  @moduledoc """
  TheftAlarm state
  """

  alias AutoApi.State

  use AutoApi.State, spec_file: "theft_alarm.json"

  @type active_selected_state :: :inactive_selected | :inactive_not_selected | :active
  @type alarm :: :unarmed | :armed | :triggered
  @type event_type ::
          :idle
          | :front_left
          | :front_middle
          | :front_right
          | :right
          | :rear_right
          | :rear_middle
          | :rear_left
          | :left
          | :unknown
  @type last_warning_reason ::
          :no_alarm
          | :basic_alarm
          | :door_front_left
          | :door_front_right
          | :door_rear_left
          | :door_rear_right
          | :hood
          | :trunk
          | :common_alm_in
          | :panic
          | :glovebox
          | :center_box
          | :rear_box
          | :sensor_vta
          | :its
          | :its_slv
          | :tps
          | :horn
          | :hold_com
          | :remote
          | :unknown
          | :siren
  @type level :: :low | :medium | :high
  @type triggered :: :not_triggered | :triggered

  @type t :: %__MODULE__{
          status: State.property(alarm),
          interior_protection_status: State.property(active_selected_state),
          tow_protection_status: State.property(active_selected_state),
          last_warning_reason: State.property(last_warning_reason),
          last_event: State.property(DateTime.t()),
          last_event_level: State.property(level),
          event_type: State.property(event_type),
          interior_protection_triggered: State.property(triggered),
          tow_protection_triggered: State.property(triggered)
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 2>>
    iex> AutoApi.TheftAlarmState.from_bin(bin)
    %AutoApi.TheftAlarmState{status: %AutoApi.Property{data: :triggered}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.TheftAlarmState{status: %AutoApi.Property{data: :triggered}}
    iex> AutoApi.TheftAlarmState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
