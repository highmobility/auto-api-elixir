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
defmodule AutoApi.VehicleTimeState do
  @moduledoc """
  VehicleTime state
  """

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct vehicle_time: nil,
            timestamp: nil

  use AutoApi.State, spec_file: "specs/vehicle_time.json"

  @type t :: %__MODULE__{
          vehicle_time: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil
        }

  @doc """
  Build state based on binary value

    iex> bin = <<1, 0, 5, 1, 0, 2, 12, 42>>
    iex> AutoApi.VehicleTimeState.from_bin(bin)
    %AutoApi.VehicleTimeState{vehicle_time: %AutoApi.PropertyComponent{data: %{hour: 12, minute: 42}}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

    iex> state = %AutoApi.VehicleTimeState{vehicle_time: %AutoApi.PropertyComponent{data: %{hour: 12, minute: 42}}}
    iex> AutoApi.VehicleTimeState.to_bin(state)
    <<1, 0, 5, 1, 0, 2, 12, 42>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
