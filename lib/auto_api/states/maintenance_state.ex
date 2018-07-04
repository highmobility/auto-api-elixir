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
defmodule AutoApi.MaintenanceState do
  @moduledoc """
  Maintenance state
  """

  alias AutoApi.CommonData

  defstruct days_to_next_service: nil,
            kilometers_to_next_service: nil,
            timestamp: nil,
            properties: []

  use AutoApi.State, spec_file: "specs/maintenance.json"

  @type activity :: :inactive | :active

  @type t :: %__MODULE__{
          days_to_next_service: integer | nil,
          kilometers_to_next_service: integer | nil,
          timestamp: DateTime.t(),
          properties: list(atom)
        }

  @doc """
  Build state based on binary value

    iex> AutoApi.MaintenanceState.from_bin(<<0x01, 2::integer-16, 0x00, 0x01>>)
    %AutoApi.MaintenanceState{days_to_next_service: 1}

    iex> AutoApi.MaintenanceState.from_bin(<<0x02, 3::integer-16,  -1::integer-24>>)
    %AutoApi.MaintenanceState{kilometers_to_next_service: 16777215}

    The above case invalid! it should convert to -1

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
    iex> AutoApi.MaintenanceState.to_bin(%AutoApi.MaintenanceState{days_to_next_service: 10, properties: [:days_to_next_service]})
    <<1, 2::integer-16, 0, 10>>

    iex> AutoApi.MaintenanceState.to_bin(%AutoApi.MaintenanceState{kilometers_to_next_service: -1, properties: [:kilometers_to_next_service]})
    <<2, 3::integer-16, -1::integer-signed-24>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
