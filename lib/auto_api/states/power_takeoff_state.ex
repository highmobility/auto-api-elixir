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
defmodule AutoApi.PowerTakeoffState do
  @moduledoc """
  PowerTakeoff state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct power_takeoff: nil,
            power_takeoff_engaged: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/power_takeoff.json"

  @type power_takeoff_engaged :: :not_engaged | :engaged

  @type t :: %__MODULE__{
          power_takeoff: %PropertyComponent{data: CommonData.activity()} | nil,
          power_takeoff_engaged: %PropertyComponent{data: power_takeoff_engaged} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 4, 1, 0, 1, 1>>
    iex> AutoApi.PowerTakeoffState.from_bin(bin)
    %AutoApi.PowerTakeoffState{power_takeoff: %AutoApi.PropertyComponent{data: :active}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.PowerTakeoffState{power_takeoff: %AutoApi.PropertyComponent{data: :active}}
    iex> AutoApi.PowerTakeoffState.to_bin(state)
    <<1, 0, 4, 1, 0, 1, 1>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
