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
defmodule AutoApi.RemoteControlState do
  @moduledoc """
  RemoteControl state
  """

  alias AutoApi.PropertyComponent

  defstruct control_mode: nil,
            angle: nil,
            speed: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/remote_control.json"

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
