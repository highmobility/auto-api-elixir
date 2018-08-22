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

  alias AutoApi.CommonData
  defstruct power_takeoff: nil, power_takeoff_engaged: nil, timestamp: nil, properties: []

  use AutoApi.State, spec_file: "specs/power_takeoff.json"

  @type power_takeoff :: :inactive | :active
  @type power_takeoff_engaged :: :not_engaged | :engaged

  @type t :: %__MODULE__{
          power_takeoff: power_takeoff | nil,
          power_takeoff_engaged: power_takeoff_engaged | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.PowerTakeoffState.from_bin(<<0x01, 1::integer-16, 0x00>>)
    %AutoApi.PowerTakeoffState{power_takeoff: :inactive}

    iex> AutoApi.PowerTakeoffState.from_bin(<<0x02, 1::integer-16, 0x01>>)
    %AutoApi.PowerTakeoffState{power_takeoff_engaged: :engaged}

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.PowerTakeoffState.to_bin(%AutoApi.PowerTakeoffState{power_takeoff: :inactive, properties: [:power_takeoff]})
    <<1, 1::integer-16, 0>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
