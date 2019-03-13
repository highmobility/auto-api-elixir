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

  alias AutoApi.{CommonData, PropertyComponent}

  defstruct days_to_next_service: nil,
            kilometers_to_next_service: nil,
            cbs_reports_count: nil,
            months_to_exhaust_inpection: nil,
            service_distance_threshold: nil,
            teleservice_availability: nil,
            service_time_threshold: nil,
            automatic_teleservice_call_date: nil,
            teleservice_battery_call_date: nil,
            next_inspection_date: nil,
            condition_based_services: [],
            brake_fluid_change_date: nil,
            timestamp: nil,
            properties: [],
            property_timestamps: %{}

  use AutoApi.State, spec_file: "specs/maintenance.json"

  @type condition_based_services :: %PropertyComponent{
          data: %{
            year: integer,
            month: integer,
            identifier: integer,
            due_status: :ok | :pending | :overdue,
            text_size: integer,
            text: String.t(),
            description_size: integer,
            description: String.t()
          }
        }

  @type activity :: :inactive | :active
  @type teleservice_availability :: :pending | :idle | :succesful | :error

  @type t :: %__MODULE__{
          days_to_next_service: %PropertyComponent{data: integer} | nil,
          kilometers_to_next_service: %PropertyComponent{data: integer} | nil,
          cbs_reports_count: %PropertyComponent{data: integer} | nil,
          months_to_exhaust_inpection: %PropertyComponent{data: integer} | nil,
          teleservice_availability: %PropertyComponent{data: teleservice_availability} | nil,
          service_distance_threshold: %PropertyComponent{data: integer} | nil,
          service_time_threshold: %PropertyComponent{data: integer} | nil,
          automatic_teleservice_call_date: %PropertyComponent{data: integer} | nil,
          teleservice_battery_call_date: %PropertyComponent{data: integer} | nil,
          next_inspection_date: %PropertyComponent{data: integer} | nil,
          condition_based_services: list(condition_based_services),
          brake_fluid_change_date: %PropertyComponent{data: integer} | nil,
          timestamp: DateTime.t() | nil,
          properties: list(atom),
          property_timestamps: map()
        }

  @doc """
  Build state based on binary value

    ix> AutoApi.MaintenanceState.from_bin(<<0x02, 3::integer-16,  -1::integer-24>>)
    %AutoApi.MaintenanceState{kilometers_to_next_service: 16777215}

    The above case invalid! it should convert to -1

  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
