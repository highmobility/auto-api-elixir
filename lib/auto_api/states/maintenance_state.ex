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
defmodule AutoApi.MaintenanceState do
  @moduledoc """
  Maintenance state
  """

  alias AutoApi.{CommonData, State, UnitType}

  use AutoApi.State, spec_file: "maintenance.json"

  @type condition_based_services :: %{
          year: integer,
          month: integer,
          identifier: integer,
          due_status: :ok | :pending | :overdue,
          text: String.t(),
          description: String.t()
        }

  @type activity :: :inactive | :active
  @type teleservice_availability :: :pending | :idle | :successful | :error

  @type due_dates :: %{
          axle: CommonData.location_longitudinal(),
          due_date: DateTime.t()
        }

  @type service_statuses :: %{
          axle: CommonData.location_longitudinal(),
          status: CommonData.service_status()
        }

  @type remaining_distances :: %{
          axle: CommonData.location_longitudinal(),
          distance: UnitType.length()
        }

  @type t :: %__MODULE__{
          # Deprecated
          days_to_next_service: State.property(UnitType.duration()),
          # Deprecated
          kilometers_to_next_service: State.property(UnitType.length()),
          cbs_reports_count: State.property(integer),
          # Deprecated
          months_to_exhaust_inspection: State.property(UnitType.duration()),
          teleservice_availability: State.property(teleservice_availability),
          service_distance_threshold: State.property(UnitType.length()),
          service_time_threshold: State.property(UnitType.duration()),
          automatic_teleservice_call_date: State.property(DateTime.t()),
          teleservice_battery_call_date: State.property(DateTime.t()),
          next_inspection_date: State.property(DateTime.t()),
          condition_based_services: State.multiple_property(condition_based_services),
          brake_fluid_change_date: State.property(DateTime.t()),
          time_to_next_service: State.property(UnitType.duration()),
          distance_to_next_service: State.property(UnitType.length()),
          time_to_exhaust_inspection: State.property(UnitType.duration()),
          last_ecall: State.property(DateTime.t()),
          distance_to_next_oil_service: State.property(UnitType.length()),
          time_to_next_oil_service: State.property(UnitType.duration()),
          brake_fluid_remaining_distance: State.property(UnitType.length()),
          brake_fluid_status: State.property(CommonData.service_status()),
          brakes_service_due_dates: State.multiple_property(due_dates),
          brakes_service_remaining_distances: State.multiple_property(remaining_distances),
          brakes_service_statuses: State.multiple_property(service_statuses),
          drive_in_inspection_date: State.property(DateTime.t()),
          drive_in_inspection_status: State.property(CommonData.service_status()),
          next_oil_service_date: State.property(DateTime.t()),
          next_inspection_distance_to: State.property(UnitType.length()),
          legal_inspection_date: State.property(DateTime.t()),
          service_status: State.property(CommonData.service_status()),
          service_date: State.property(DateTime.t()),
          inspection_status: State.property(CommonData.service_status()),
          drive_in_inspection_distance_to: State.property(UnitType.length()),
          vehicle_check_date: State.property(DateTime.t()),
          vehicle_check_status: State.property(CommonData.service_status()),
          vehicle_check_distance_to: State.property(UnitType.length())
        }

  @doc """
  Build state based on binary value

  ## Example

      iex> AutoApi.MaintenanceState.from_bin(<<3, 0, 4, 1, 0, 1, 42>>)
      %AutoApi.MaintenanceState{cbs_reports_count: %AutoApi.Property{data: 42}}
  """
  @spec from_bin(binary) :: __MODULE__.t()
  def from_bin(bin) do
    parse_bin_properties(bin, %__MODULE__{})
  end

  @doc """
  Parse state to bin

  ## Example

      iex> state = %AutoApi.MaintenanceState{cbs_reports_count: %AutoApi.Property{data: 42}}
      iex> AutoApi.MaintenanceState.to_bin(state)
      <<3, 0, 4, 1, 0, 1, 42>>
  """
  @spec to_bin(__MODULE__.t()) :: binary
  def to_bin(%__MODULE__{} = state) do
    parse_state_properties(state)
  end
end
