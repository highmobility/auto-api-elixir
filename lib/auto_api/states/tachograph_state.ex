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
defmodule AutoApi.TachographState do
  @moduledoc """
  Keeps Tachograph state

  """

  @doc """
  Tachograph state
  """
  defstruct driver_working_state: [],
            driver_time_state: [],
            driver_card: [],
            vehicle_motion: nil,
            vehicle_overspeed: nil,
            vehicle_direction: nil,
            vehicle_speed: nil,
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/tachograph.json"

  @type t :: %__MODULE__{
          driver_working_state: list(any),
          driver_time_state: list(any),
          driver_card: list(any),
          vehicle_motion: :not_detected | :detected | nil,
          vehicle_overspeed: :no_overspeed | :overspeed | nil,
          vehicle_direction: :forward | :reverse | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @spec to_bin(__MODULE__.t()) :: binary
  @doc """
  Parse state to bin
  """
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
