# AutoAPI
# Copyright (C) 2018 High-Mobility GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#
# Please inquire about commercial licensing options at
# licensing@high-mobility.com
defmodule AutoApi.TheftAlarmState do
  @moduledoc """
  TheftAlarm state
  """

  alias AutoApi.PropertyComponent

  defstruct theft_alarm: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/theft_alarm.json"

  @type alarm :: :not_armed | :armed | :triggered

  @type t :: %__MODULE__{
          theft_alarm: %PropertyComponent{data: alarm} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 2>>
    iex> AutoApi.TheftAlarmState.from_bin(bin)
    %AutoApi.TheftAlarmState{theft_alarm: %AutoApi.PropertyComponent{data: :triggered}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.TheftAlarmState{theft_alarm: %AutoApi.PropertyComponent{data: :triggered}}
    iex> AutoApi.TheftAlarmState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 2>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end